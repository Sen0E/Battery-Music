import 'dart:async';
import 'dart:io';

import 'package:kugou_music_api_dart/kugou_music_api_dart.dart';

typedef ApiRunner =
    Future<Map<String, dynamic>> Function(ValidationContext ctx);

class ApiCase {
  const ApiCase(
    this.name,
    this.runner, {
    this.destructive = false,
    this.skipIf,
  });

  final String name;
  final ApiRunner runner;
  final bool destructive;
  final String? Function(ValidationContext ctx)? skipIf;
}

class ValidationContext {
  final Map<String, dynamic> values = {};

  String env(String name, [String fallback = '']) {
    final value = Platform.environment[name];
    return value == null || value.isEmpty ? fallback : value;
  }

  bool get includeDestructive => env('KUGOU_INCLUDE_DESTRUCTIVE') == '1';
}

Future<String> _prompt(String label) async {
  stdout.write(label);
  return stdin.readLineSync()?.trim() ?? '';
}

Map<String, dynamic> _syncBody(Map<String, dynamic> body) {
  return {'status': 200, 'body': body, 'cookie': <String>[]};
}

dynamic _findFirst(dynamic value, String key) {
  if (value is Map) {
    if (value.containsKey(key) && value[key] != null) return value[key];
    for (final item in value.values) {
      final found = _findFirst(item, key);
      if (found != null) return found;
    }
  }
  if (value is List) {
    for (final item in value) {
      final found = _findFirst(item, key);
      if (found != null) return found;
    }
  }
  return null;
}

dynamic _findAny(dynamic value, List<String> keys) {
  for (final key in keys) {
    final found = _findFirst(value, key);
    if (found != null) return found;
  }
  return null;
}

String _stringValue(dynamic value, [String fallback = '']) {
  if (value == null) return fallback;
  final text = value.toString();
  return text.isEmpty ? fallback : text;
}

Future<void> main(List<String> args) async {
  final ctx = ValidationContext();
  final mobile = ctx.env('KUGOU_MOBILE', args.isNotEmpty ? args.first : '');

  if (mobile.trim().isEmpty) {
    stderr.writeln('请通过环境变量 KUGOU_MOBILE 或命令行参数提供手机号。');
    exitCode = 64;
    return;
  }

  ApiClient().init(savedCookies: {});

  stdout.writeln('== 1. 注册设备指纹，准备登录态 ==');
  final deviceResp = await Device.registerDev();
  stdout.writeln('Device.registerDev => status=${deviceResp['status']}');

  stdout.writeln('== 2. 发送手机验证码 ==');
  final captchaResp = await Login.captchaSent(mobile);
  stdout.writeln('Login.captchaSent => status=${captchaResp['status']}');
  stdout.writeln('body => ${captchaResp['body']}');

  final code = ctx.env('KUGOU_CAPTCHA').isNotEmpty
      ? ctx.env('KUGOU_CAPTCHA')
      : await _prompt('请输入短信验证码: ');
  if (code.trim().isEmpty) {
    stderr.writeln('验证码不能为空。');
    exitCode = 65;
    return;
  }

  stdout.writeln('== 3. 手机号 + 验证码登录，获取 token ==');
  final loginResp = await Login.loginCellphone(mobile, code);
  stdout.writeln('Login.loginCellphone => status=${loginResp['status']}');
  stdout.writeln('body => ${loginResp['body']}');

  final rawLoginBody = loginResp['body'];
  final loginBody = rawLoginBody is Map
      ? Map<String, dynamic>.from(rawLoginBody)
      : <String, dynamic>{};
  final rawLoginData = loginBody['data'];
  final loginData = rawLoginData is Map
      ? Map<String, dynamic>.from(rawLoginData)
      : <String, dynamic>{};

  final token =
      ApiClient().currentCookies['token'] ??
      _stringValue(loginData['token'], ctx.env('KUGOU_TOKEN'));
  final userid =
      ApiClient().currentCookies['userid'] ??
      _stringValue(loginData['userid'], ctx.env('KUGOU_USERID', '0'));

  ctx.values['token'] = token;
  ctx.values['userid'] = userid;

  stdout.writeln('token => $token');
  stdout.writeln('userid => $userid');

  if (token.isEmpty || userid == '0') {
    stderr.writeln('登录未拿到有效 token/userid，停止全量 API 验证。');
    exitCode = 66;
    return;
  }

  stdout.writeln('== 4. 登录后全量 API 验证 ==');
  stdout.writeln(
    '默认跳过会修改账号数据或缺少外部凭证的接口；如需执行破坏性接口，设置 KUGOU_INCLUDE_DESTRUCTIVE=1。',
  );

  final cases = _buildCases();
  var passed = 0;
  var failed = 0;
  var skipped = 0;

  for (final item in cases) {
    final skipReason = item.destructive && !ctx.includeDestructive
        ? '会修改账号数据，默认跳过'
        : item.skipIf?.call(ctx);
    if (skipReason != null) {
      skipped++;
      stdout.writeln('[SKIP] ${item.name} => $skipReason');
      continue;
    }

    try {
      final startedAt = DateTime.now();
      final response = await item
          .runner(ctx)
          .timeout(const Duration(seconds: 30));
      final cost = DateTime.now().difference(startedAt).inMilliseconds;
      final status = response['status'];
      final ok = status == 200 || _isAcceptedBusinessEmpty(item.name, response);

      if (ok) {
        passed++;
      } else {
        failed++;
      }

      stdout.writeln(
        '[${ok ? 'PASS' : 'FAIL'}] ${item.name} => status=$status, ${cost}ms',
      );
      if (!ok) stdout.writeln('       body=${response['body']}');
    } on TimeoutException {
      failed++;
      stdout.writeln('[FAIL] ${item.name} => timeout');
    } catch (e, stack) {
      failed++;
      stdout.writeln('[FAIL] ${item.name} => exception: $e');
      stdout.writeln(stack.toString().split('\n').take(3).join('\n'));
    }
  }

  stdout.writeln('== 验证完成 ==');
  stdout.writeln(
    'PASS=$passed FAIL=$failed SKIP=$skipped TOTAL=${cases.length}',
  );
  if (failed > 0) exitCode = 1;
}

bool _isAcceptedBusinessEmpty(String name, Map<String, dynamic> response) {
  final body = response['body'];
  if (name == 'Yueku.yuekuBanner' && body is Map) {
    return body['error_code'] == 31136 && body['data'] is Map;
  }
  return false;
}

List<ApiCase> _buildCases() {
  return [
    ApiCase('Login.loginToken', (ctx) {
      return Login.loginToken(
        token: ctx.values['token']?.toString(),
        userid: ctx.values['userid']?.toString(),
      );
    }),
    ApiCase('Login.loginDevice', (ctx) {
      return Login.loginDevice(
        token: ctx.values['token'].toString(),
        userid: int.tryParse(ctx.values['userid'].toString()) ?? 0,
      );
    }),
    ApiCase('Login.loginQrKey', (ctx) async {
      final response = await Login.loginQrKey();
      ctx.values['qr_key'] =
          _findFirst(response['body'], 'qrcode') ??
          _findFirst(response['body'], 'key') ??
          _findFirst(response['body'], 'data');
      return response;
    }),
    ApiCase('Login.loginQrCreate', (ctx) async {
      final key = _stringValue(ctx.values['qr_key'], 'verify-dummy-key');
      return _syncBody(Login.loginQrCreate(key));
    }),
    ApiCase(
      'Login.loginQrCheck',
      (ctx) {
        return Login.loginQrCheck(_stringValue(ctx.values['qr_key']));
      },
      skipIf: (ctx) {
        return _stringValue(ctx.values['qr_key']).isEmpty ? '缺少二维码 key' : null;
      },
    ),
    ApiCase('Login.loginWxCreate', (_) => Login.loginWxCreate()),
    ApiCase(
      'Login.loginWxCheck',
      (ctx) {
        return Login.loginWxCheck(ctx.env('KUGOU_WX_UUID'));
      },
      skipIf: (ctx) {
        return ctx.env('KUGOU_WX_UUID').isEmpty ? '缺少 KUGOU_WX_UUID' : null;
      },
    ),
    ApiCase(
      'Login.loginOpenPlat',
      (ctx) {
        return Login.loginOpenPlat(ctx.env('KUGOU_OPENPLAT_CODE'));
      },
      skipIf: (ctx) {
        return ctx.env('KUGOU_OPENPLAT_CODE').isEmpty
            ? '缺少 KUGOU_OPENPLAT_CODE'
            : null;
      },
    ),
    ApiCase(
      'Login.loginByPwd',
      (ctx) {
        return Login.loginByPwd(
          ctx.env('KUGOU_USERNAME'),
          ctx.env('KUGOU_PASSWORD'),
        );
      },
      skipIf: (ctx) {
        return ctx.env('KUGOU_USERNAME').isEmpty ||
                ctx.env('KUGOU_PASSWORD').isEmpty
            ? '缺少 KUGOU_USERNAME/KUGOU_PASSWORD'
            : null;
      },
    ),
    ApiCase('User.userDetail', (_) => User.userDetail()),
    ApiCase('User.userVipDetail', (_) => User.userVipDetail()),
    ApiCase('User.userPlaylist', (ctx) async {
      final response = await User.userPlaylist();
      ctx.values['user_listid'] =
          _findFirst(response['body'], 'listid') ??
          _findFirst(response['body'], 'list_id');
      ctx.values['user_fileid'] = _findFirst(response['body'], 'fileid');
      return response;
    }),
    ApiCase('User.userHistory', (_) => User.userHistory()),
    ApiCase('User.userListen', (_) => User.userListen()),
    ApiCase('User.userFollow', (_) => User.userFollow()),
    ApiCase('User.userVideoCollect', (_) => User.userVideoCollect()),
    ApiCase('User.userVideoLove', (_) => User.userVideoLove()),
    ApiCase(
      'User.userCloudUrl',
      (ctx) {
        return User.userCloudUrl(
          _stringValue(ctx.values['cloud_hash'], ctx.env('KUGOU_CLOUD_HASH')),
          albumAudioId:
              int.tryParse(_stringValue(ctx.values['cloud_album_audio_id'])) ??
              0,
          audioId:
              int.tryParse(_stringValue(ctx.values['cloud_audio_id'])) ?? 0,
          name: _stringValue(ctx.values['cloud_name']),
        );
      },
      skipIf: (ctx) {
        final hash = _stringValue(
          ctx.values['cloud_hash'],
          ctx.env('KUGOU_CLOUD_HASH'),
        );
        return hash.isEmpty ? '未从 User.userCloud 解析到云盘歌曲 hash' : null;
      },
    ),
    ApiCase('User.userCloud', (ctx) async {
      final response = await User.userCloud();
      ctx.values['cloud_hash'] = _findAny(response['body'], [
        'hash',
        'file_hash',
        'audio_hash',
      ]);
      ctx.values['cloud_album_audio_id'] = _findAny(response['body'], [
        'album_audio_id',
        'mixsongid',
        'mixsong_id',
      ]);
      ctx.values['cloud_audio_id'] = _findAny(response['body'], [
        'audio_id',
        'fileid',
      ]);
      ctx.values['cloud_name'] = _findAny(response['body'], [
        'name',
        'filename',
        'songname',
      ]);
      return response;
    }),
    ApiCase(
      'Search.search',
      (ctx) => Search.search(ctx.env('KUGOU_KEYWORD', '周杰伦')),
    ),
    ApiCase(
      'Search.searchComplex',
      (ctx) => Search.searchComplex(ctx.env('KUGOU_KEYWORD', '周杰伦')),
    ),
    ApiCase(
      'Search.searchMixed',
      (ctx) => Search.searchMixed(ctx.env('KUGOU_KEYWORD', '周杰伦')),
    ),
    ApiCase('Search.searchHot', (_) => Search.searchHot()),
    ApiCase(
      'Search.searchSuggest',
      (ctx) => Search.searchSuggest(ctx.env('KUGOU_KEYWORD', '周杰伦')),
    ),
    ApiCase('Search.searchDefault', (_) => Search.searchDefault()),
    ApiCase('Search.searchLyric', (ctx) async {
      final response = await Search.searchLyric(
        keywords: ctx.env('KUGOU_KEYWORD', '周杰伦'),
        albumAudioId:
            int.tryParse(ctx.env('KUGOU_ALBUM_AUDIO_ID', '32155307')) ?? 0,
      );
      ctx.values['lyric_id'] = _findFirst(response['body'], 'id');
      ctx.values['lyric_accesskey'] = _findFirst(response['body'], 'accesskey');
      return response;
    }),
    ApiCase(
      'Lyric.getLyric',
      (ctx) {
        return Lyric.getLyric(
          id: _stringValue(ctx.values['lyric_id'], ctx.env('KUGOU_LYRIC_ID')),
          accesskey: _stringValue(
            ctx.values['lyric_accesskey'],
            ctx.env('KUGOU_LYRIC_ACCESSKEY'),
          ),
        );
      },
      skipIf: (ctx) {
        final id = _stringValue(
          ctx.values['lyric_id'],
          ctx.env('KUGOU_LYRIC_ID'),
        );
        final key = _stringValue(
          ctx.values['lyric_accesskey'],
          ctx.env('KUGOU_LYRIC_ACCESSKEY'),
        );
        return id.isEmpty || key.isEmpty ? '缺少歌词 id/accesskey' : null;
      },
    ),
    ApiCase('Song.songUrlNew', (ctx) {
      return Song.songUrlNew(
        hash: ctx.env('KUGOU_HASH', '98eb07ad8eaf74bf56dece55518ad63e'),
        albumAudioId: ctx.env('KUGOU_ALBUM_AUDIO_ID', '32155307'),
      );
    }),
    ApiCase('Song.songUrl', (ctx) {
      return Song.songUrl(
        hash: ctx.env('KUGOU_HASH', '98eb07ad8eaf74bf56dece55518ad63e'),
        albumAudioId: ctx.env('KUGOU_ALBUM_AUDIO_ID', '32155307'),
      );
    }),
    ApiCase(
      'Song.songClimax',
      (ctx) => Song.songClimax(
        ctx.env('KUGOU_HASH', '98eb07ad8eaf74bf56dece55518ad63e'),
      ),
    ),
    ApiCase(
      'Song.songRanking',
      (ctx) => Song.songRanking(ctx.env('KUGOU_ALBUM_AUDIO_ID', '32155307')),
    ),
    ApiCase('Song.songRankingFilter', (ctx) {
      return Song.songRankingFilter(
        albumAudioId: ctx.env('KUGOU_ALBUM_AUDIO_ID', '32155307'),
      );
    }),
    ApiCase(
      'Album.album',
      (ctx) => Album.album(ctx.env('KUGOU_ALBUM_ID', '960591')),
    ),
    ApiCase(
      'Album.albumDetail',
      (ctx) => Album.albumDetail(ctx.env('KUGOU_ALBUM_ID', '960591')),
    ),
    ApiCase(
      'Album.albumSongs',
      (ctx) => Album.albumSongs(ctx.env('KUGOU_ALBUM_ID', '960591')),
    ),
    ApiCase('Playlist.playlistDetail', (ctx) {
      return Playlist.playlistDetail(
        ctx.env('KUGOU_PLAYLIST_ID', 'collection_3_1373407643_366_0'),
      );
    }),
    ApiCase('Playlist.playlistTrackAll', (ctx) {
      return Playlist.playlistTrackAll(
        id: ctx.env('KUGOU_PLAYLIST_ID', 'collection_3_1373407643_366_0'),
      );
    }),
    ApiCase(
      'Playlist.playlistTrackAllNew',
      (ctx) {
        return Playlist.playlistTrackAllNew(listid: ctx.values['user_listid']);
      },
      skipIf: (ctx) {
        return _stringValue(ctx.values['user_listid']).isEmpty
            ? '未从 User.userPlaylist 解析到自建歌单 listid'
            : null;
      },
    ),
    ApiCase('Playlist.playlistEffect', (_) => Playlist.playlistEffect()),
    ApiCase(
      'Playlist.playlistSimilar',
      (ctx) => Playlist.playlistSimilar(
        ctx.env('KUGOU_PLAYLIST_ID', 'collection_3_1373407643_366_0'),
      ),
    ),
    ApiCase('Playlist.playlistTags', (_) => Playlist.playlistTags()),
    ApiCase('Playlist.playlistAdd', (ctx) {
      return Playlist.playlistAdd(
        name: ctx.env('KUGOU_TEST_PLAYLIST_NAME', 'API验证歌单'),
      );
    }, destructive: true),
    ApiCase(
      'Playlist.playlistDel',
      (ctx) {
        return Playlist.playlistDel(int.parse(ctx.env('KUGOU_MUTATE_LISTID')));
      },
      destructive: true,
      skipIf: (ctx) {
        return ctx.env('KUGOU_MUTATE_LISTID').isEmpty
            ? '缺少 KUGOU_MUTATE_LISTID'
            : null;
      },
    ),
    ApiCase(
      'Playlist.playlistTracksAdd',
      (ctx) {
        return Playlist.playlistTracksAdd(
          ctx.env('KUGOU_MUTATE_LISTID'),
          ctx.env('KUGOU_TRACK_DATA'),
        );
      },
      destructive: true,
      skipIf: (ctx) {
        return ctx.env('KUGOU_MUTATE_LISTID').isEmpty ||
                ctx.env('KUGOU_TRACK_DATA').isEmpty
            ? '缺少 KUGOU_MUTATE_LISTID/KUGOU_TRACK_DATA'
            : null;
      },
    ),
    ApiCase(
      'Playlist.playlistTracksDel',
      (ctx) {
        return Playlist.playlistTracksDel(
          ctx.env('KUGOU_MUTATE_LISTID'),
          ctx.env('KUGOU_MUTATE_FILEIDS'),
        );
      },
      destructive: true,
      skipIf: (ctx) {
        return ctx.env('KUGOU_MUTATE_LISTID').isEmpty ||
                ctx.env('KUGOU_MUTATE_FILEIDS').isEmpty
            ? '缺少 KUGOU_MUTATE_LISTID/KUGOU_MUTATE_FILEIDS'
            : null;
      },
    ),
    ApiCase('Rank.rankTop', (_) => Rank.rankTop()),
    ApiCase('Rank.rankList', (_) => Rank.rankList()),
    ApiCase(
      'Rank.rankInfo',
      (ctx) => Rank.rankInfo(rankid: ctx.env('KUGOU_RANK_ID', '8888')),
    ),
    ApiCase(
      'Rank.rankAudio',
      (ctx) => Rank.rankAudio(rankid: ctx.env('KUGOU_RANK_ID', '8888')),
    ),
    ApiCase(
      'Rank.rankVol',
      (ctx) => Rank.rankVol(rankid: ctx.env('KUGOU_RANK_ID', '8888')),
    ),
    ApiCase('Top.topCard', (_) => Top.topCard()),
    ApiCase('Top.topCardYouth', (_) => Top.topCardYouth()),
    ApiCase('Top.topPlaylist', (_) => Top.topPlaylist()),
    ApiCase('Top.topSong', (_) => Top.topSong()),
    ApiCase('Top.topAlbum', (_) => Top.topAlbum()),
    ApiCase('Top.topIp', (_) => Top.topIp()),
    ApiCase('Yueku.yuekuRecommend', (_) => Yueku.yuekuRecommend()),
    ApiCase('Yueku.yuekuBanner', (_) => Yueku.yuekuBanner()),
    ApiCase('Yueku.yuekuFm', (_) => Yueku.yuekuFm()),
    ApiCase('Everyday.everydayRecommend', (_) => Everyday.everydayRecommend()),
    ApiCase('Everyday.everydayHistory', (_) => Everyday.everydayHistory()),
    ApiCase(
      'Everyday.everydayStyleRecommend',
      (_) => Everyday.everydayStyleRecommend(),
    ),
    ApiCase('Everyday.everydayFriend', (_) {
      return Everyday.everydayFriend(
        cookie: Map<String, String>.from(ApiClient().currentCookies),
      );
    }),
    ApiCase('Fm.personalFm', (_) => Fm.personalFm()),
    ApiCase('KugouArtist.artistLists', (_) => KugouArtist.artistLists()),
    ApiCase('KugouArtist.artistDetail', (ctx) {
      return KugouArtist.artistDetail(
        authorId: ctx.env('KUGOU_ARTIST_ID', '6539'),
      );
    }),
    ApiCase('KugouArtist.artistHonour', (ctx) {
      return KugouArtist.artistHonour(
        singerId: ctx.env('KUGOU_ARTIST_ID', '6539'),
      );
    }),
    ApiCase('KugouArtist.artistAudios', (ctx) {
      return KugouArtist.artistAudios(
        authorId: ctx.env('KUGOU_ARTIST_ID', '6539'),
      );
    }),
    ApiCase('KugouArtist.artistAlbums', (ctx) {
      return KugouArtist.artistAlbums(
        authorId: ctx.env('KUGOU_ARTIST_ID', '6539'),
      );
    }),
    ApiCase('KugouArtist.artistVideos', (ctx) {
      return KugouArtist.artistVideos(
        authorId: ctx.env('KUGOU_ARTIST_ID', '6539'),
      );
    }),
    ApiCase('KugouArtist.artistFollowNewSongs', (_) {
      return KugouArtist.artistFollowNewSongs();
    }),
    ApiCase('KugouArtist.artistFollow', (ctx) {
      return KugouArtist.artistFollow(
        singerId: ctx.env('KUGOU_ARTIST_ID', '6539'),
      );
    }, destructive: true),
    ApiCase('KugouArtist.artistUnfollow', (ctx) {
      return KugouArtist.artistUnfollow(
        singerId: ctx.env('KUGOU_ARTIST_ID', '6539'),
      );
    }, destructive: true),
    ApiCase('KugouComment.commentMusic', (ctx) {
      return KugouComment.commentMusic(
        mixsongid: ctx.env('KUGOU_MIXSONG_ID', '302362878'),
      );
    }),
    ApiCase('KugouComment.commentCount', (ctx) {
      return KugouComment.commentCount(
        hash: ctx.env('KUGOU_HASH', '98eb07ad8eaf74bf56dece55518ad63e'),
      );
    }),
    ApiCase('KugouComment.commentFloor', (ctx) {
      return KugouComment.commentFloor(
        specialId: ctx.env('KUGOU_SPECIAL_ID', '100285259'),
        mixsongid: ctx.env('KUGOU_MIXSONG_ID', '302362878'),
        tid: ctx.env('KUGOU_COMMENT_TID', '678433417'),
      );
    }),
    ApiCase('KugouComment.commentMusicClassify', (ctx) {
      return KugouComment.commentMusicClassify(
        mixsongid: ctx.env('KUGOU_MIXSONG_ID', '302362878'),
        typeId: ctx.env('KUGOU_COMMENT_TYPE_ID', '12'),
      );
    }),
    ApiCase('KugouComment.commentMusicHotword', (ctx) {
      return KugouComment.commentMusicHotword(
        mixsongid: ctx.env('KUGOU_MIXSONG_ID', '302362878'),
        hotWord: ctx.env('KUGOU_HOT_WORD', '生活'),
      );
    }),
    ApiCase(
      'KugouComment.commentAlbum',
      (ctx) =>
          KugouComment.commentAlbum(id: ctx.env('KUGOU_ALBUM_ID', '960591')),
    ),
    ApiCase('KugouComment.commentPlaylist', (ctx) {
      return KugouComment.commentPlaylist(
        id: ctx.env('KUGOU_PLAYLIST_ID', 'collection_3_1373407643_366_0'),
      );
    }),
    ApiCase('Video.videoUrl', (ctx) {
      return Video.videoUrl(
        ctx.env('KUGOU_VIDEO_HASH', '3B5EE16299F703AEB0E5C28CB152EDF0'),
      );
    }),
    ApiCase('Video.videoPrivilege', (ctx) {
      return Video.videoPrivilege(
        hash: ctx.env('KUGOU_VIDEO_HASH', '3B5EE16299F703AEB0E5C28CB152EDF0'),
      );
    }),
    ApiCase('Video.videoDetail', (ctx) {
      return Video.videoDetail(id: ctx.env('KUGOU_VIDEO_ID', '11517822'));
    }),
    ApiCase('Sheet.sheetList', (ctx) {
      return Sheet.sheetList(
        albumAudioId: ctx.env('KUGOU_ALBUM_AUDIO_ID', '32155307'),
      );
    }),
    ApiCase(
      'Sheet.sheetDetail',
      (ctx) {
        return Sheet.sheetDetail(
          id: ctx.env('KUGOU_SHEET_ID'),
          source: ctx.env('KUGOU_SHEET_SOURCE'),
        );
      },
      skipIf: (ctx) {
        return ctx.env('KUGOU_SHEET_ID').isEmpty ||
                ctx.env('KUGOU_SHEET_SOURCE').isEmpty
            ? '缺少 KUGOU_SHEET_ID/KUGOU_SHEET_SOURCE'
            : null;
      },
    ),
    ApiCase('Sheet.sheetHot', (_) => Sheet.sheetHot()),
    ApiCase('Sheet.sheetCollection', (_) => Sheet.sheetCollection()),
    ApiCase(
      'Sheet.sheetCollectionDetail',
      (ctx) {
        return Sheet.sheetCollectionDetail(
          collectionId: ctx.env('KUGOU_SHEET_COLLECTION_ID'),
        );
      },
      skipIf: (ctx) {
        return ctx.env('KUGOU_SHEET_COLLECTION_ID').isEmpty
            ? '缺少 KUGOU_SHEET_COLLECTION_ID'
            : null;
      },
    ),
    ApiCase('Scene.sceneLists', (_) => Scene.sceneLists()),
    ApiCase('Scene.sceneModule', (ctx) {
      return Scene.sceneModule(id: ctx.env('KUGOU_SCENE_ID', '9'));
    }),
    ApiCase('Scene.sceneListsV2', (ctx) {
      return Scene.sceneListsV2(id: ctx.env('KUGOU_SCENE_ID', '9'));
    }),
    ApiCase('Scene.sceneModuleInfo', (ctx) {
      return Scene.sceneModuleInfo(
        id: ctx.env('KUGOU_SCENE_ID', '9'),
        moduleId: ctx.env('KUGOU_SCENE_MODULE_ID', '83'),
      );
    }),
    ApiCase('Scene.sceneCollectionList', (ctx) {
      return Scene.sceneCollectionList(
        tagId: ctx.env('KUGOU_SCENE_TAG_ID', '42391'),
      );
    }),
    ApiCase('Scene.sceneVideoList', (ctx) {
      return Scene.sceneVideoList(
        tagId: ctx.env('KUGOU_SCENE_VIDEO_TAG_ID', '42399'),
      );
    }),
    ApiCase('Scene.sceneAudioList', (ctx) {
      return Scene.sceneAudioList(
        id: ctx.env('KUGOU_SCENE_ID', '9'),
        moduleId: ctx.env('KUGOU_SCENE_MODULE_ID', '173'),
        tag: ctx.env('KUGOU_SCENE_TAG_ID', '42391'),
      );
    }),
    ApiCase('ThemeMusic.themeMusic', (ctx) async {
      final response = await ThemeMusic.themeMusic(
        ids: ctx.env('KUGOU_THEME_IDS', ''),
      );
      ctx.values['theme_id'] = _findAny(response['body'], [
        'theme_category_id',
        'show_theme_category_id',
        'theme_id',
      ]);
      return response;
    }),
    ApiCase(
      'ThemeMusic.themeMusicDetail',
      (ctx) {
        return ThemeMusic.themeMusicDetail(
          id: _stringValue(ctx.values['theme_id'], ctx.env('KUGOU_THEME_ID')),
        );
      },
      skipIf: (ctx) {
        final id = _stringValue(
          ctx.values['theme_id'],
          ctx.env('KUGOU_THEME_ID'),
        );
        return id.isEmpty ? '未从 ThemeMusic.themeMusic 解析到主题 ID' : null;
      },
    ),
    ApiCase('LongAudio.longAudioDailyRecommend', (_) {
      return LongAudio.longAudioDailyRecommend();
    }),
    ApiCase('LongAudio.longAudioRankRecommend', (_) {
      return LongAudio.longAudioRankRecommend();
    }),
    ApiCase('LongAudio.longAudioVipRecommend', (_) {
      return LongAudio.longAudioVipRecommend();
    }),
    ApiCase('LongAudio.longAudioWeekRecommend', (_) {
      return LongAudio.longAudioWeekRecommend();
    }),
    ApiCase('LongAudio.longAudioAlbumDetail', (ctx) {
      return LongAudio.longAudioAlbumDetail(
        ctx.env('KUGOU_LONG_AUDIO_ALBUM_ID', '56655759'),
      );
    }),
    ApiCase('LongAudio.longAudioAlbumAudios', (ctx) {
      return LongAudio.longAudioAlbumAudios(
        ctx.env('KUGOU_LONG_AUDIO_ALBUM_ID', '56655759'),
      );
    }),
    ApiCase('Images.images', (ctx) {
      return Images.images(
        hash: ctx.env('KUGOU_HASH', '98eb07ad8eaf74bf56dece55518ad63e'),
        albumId: ctx.env('KUGOU_ALBUM_ID', '960591'),
        albumAudioId: ctx.env('KUGOU_ALBUM_AUDIO_ID', '32155307'),
      );
    }),
    ApiCase('Images.imagesAudio', (ctx) {
      return Images.imagesAudio(
        hash: ctx.env('KUGOU_HASH', '98eb07ad8eaf74bf56dece55518ad63e'),
        albumAudioId: ctx.env('KUGOU_ALBUM_AUDIO_ID', '32155307'),
      );
    }),
    ApiCase('PlayHistory.playHistoryUpload', (ctx) {
      return PlayHistory.playHistoryUpload(
        mxid: ctx.env('KUGOU_ALBUM_AUDIO_ID', '32155307'),
      );
    }, destructive: true),
    ApiCase('SystemApi.serverNow', (_) => SystemApi.serverNow()),
    ApiCase('SystemApi.brush', (_) => SystemApi.brush()),
    ApiCase('SystemApi.aiRecommend', (ctx) {
      return SystemApi.aiRecommend(
        albumAudioId: ctx.env('KUGOU_ALBUM_AUDIO_ID', '32155307'),
      );
    }),
  ];
}
