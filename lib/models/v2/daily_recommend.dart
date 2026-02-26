import 'dart:convert';

// class Root {
//   /// 核心数据对象
//   final DailyRecommend
//? data;

//   /// 响应状态码，通常 1 表示成功
//   final int? status;

//   /// 错误码，0 表示无错误
//   final int? errorCode;

//   const Root({
//     required this.data,
//     required this.status,
//     required this.errorCode,
//   });

//   factory Root.fromMap(Map<String, dynamic> map) {
//     return Root(
//       data: map['data'] != null
//           ? DailyRecommend
// .fromMap(map['data'])
//           : null,
//       status: map['status'],
//       errorCode: map['error_code'],
//     );
//   }

//   factory Root.fromJson(String str) => Root.fromMap(json.decode(str));

//   Map<String, dynamic> toMap() {
//     return {'data': data?.toMap(), 'status': status, 'error_code': errorCode};
//   }

//   String toJson() => json.encode(toMap());
// }

class DailyRecommend {
  /// 生成日期，格式 YYYYMMDD (例如: 20260226)
  final String? creationDate;

  /// 机器/用户标识 ID
  final String? mid;

  /// 业务标识，例如 "rcmd_evd" 可能代表 "recommend everyday"
  final String? biBiz;

  /// 签名字符串，用于校验数据完整性
  final String? sign;

  /// 推荐歌曲列表的长度 (例如: 30)
  final int? songListSize;

  /// 实验 ID 列表，用于 A/B 测试或灰度发布
  final String? olexpIds;

  /// 客户端播放列表标志
  final int? clientPlaylistFlag;

  /// 是否为保底推荐 (0: 否, 1: 是)，当算法计算失败时可能返回保底数据
  final int? isGuaranteeRec;

  /// 歌曲列表详情
  final List<SongItem>? songList;

  /// 副标题
  final String? subTitle;

  /// 每日推荐的封面背景图 URL
  final String? coverImgUrl;

  const DailyRecommend({
    required this.creationDate,
    required this.mid,
    required this.biBiz,
    required this.sign,
    required this.songListSize,
    required this.olexpIds,
    required this.clientPlaylistFlag,
    required this.isGuaranteeRec,
    required this.songList,
    required this.subTitle,
    required this.coverImgUrl,
  });

  factory DailyRecommend.fromMap(Map<String, dynamic> map) {
    return DailyRecommend(
      creationDate: map['creation_date'],
      mid: map['mid'],
      biBiz: map['bi_biz'],
      sign: map['sign'],
      songListSize: map['song_list_size'],
      olexpIds: map['OlexpIds'],
      clientPlaylistFlag: map['client_playlist_flag'],
      isGuaranteeRec: map['is_guarantee_rec'],
      songList: map['song_list'] != null
          ? List<SongItem>.from(
              (map['song_list'] as List).map((x) => SongItem.fromMap(x)),
            )
          : null,
      subTitle: map['sub_title'],
      coverImgUrl: map['cover_img_url'],
    );
  }

  factory DailyRecommend.fromJson(String str) =>
      DailyRecommend.fromMap(json.decode(str));

  Map<String, dynamic> toMap() {
    return {
      'creation_date': creationDate,
      'mid': mid,
      'bi_biz': biBiz,
      'sign': sign,
      'song_list_size': songListSize,
      'OlexpIds': olexpIds,
      'client_playlist_flag': clientPlaylistFlag,
      'is_guarantee_rec': isGuaranteeRec,
      'song_list': songList?.map((x) => x.toMap()).toList(),
      'sub_title': subTitle,
      'cover_img_url': coverImgUrl,
    };
  }

  String toJson() => json.encode(toMap());
}

// -----------------------------------------------------------------------------
// Song_list 类 (重命名为 SongItem)：单曲详情
// -----------------------------------------------------------------------------
class SongItem {
  /// 无损 FLAC 格式的文件大小 (字节)
  final int? filesizeFlac;

  /// 官方正式歌名
  final String? officialSongname;

  /// 原始音频文件名
  final String? oriAudioName;

  /// 192kbps 音质的 Hash 值 (文件指纹)
  final String? hash192;

  /// 无损 FLAC 音质的 Hash 值
  final String? hashFlac;

  /// 展示用的歌名
  final String? songname;

  /// 音乐音轨号
  final int? musicTrac;

  /// 是否为原创/原唱标识 (1: 是)
  final int? isOriginal;

  /// 付费类型 (0: 免费, 3: VIP/付费)
  final int? payType;

  /// 歌曲类型 (例如 "1" 可能代表普通音频)
  final String? songType;

  /// 专辑 ID
  final String? albumId;

  /// 备注信息
  final String? remark;

  /// 语言 (如: "英语", "国语")
  final String? language;

  /// 320k 文件头大小
  final int? isFileHead320;

  /// 算法追踪路径，用于数据分析推荐效果
  final String? algPath;

  /// 文件头大小
  final int? isFileHead;

  /// 完整文件名 (歌手 - 歌名)
  final String? filename;

  /// 分类 ID
  final int? cid;

  /// 子分类 ID / 场景 ID
  final int? scid;

  /// 音频文件名后缀 (如 "(蚊子音DJ版)")
  final String? suffixAudioName;

  /// 推荐理由文案 (如 "人气歌曲推荐", "本周超十万收听")
  final String? recCopyWrite;

  /// MV 的 Hash 值，用于播放 MV
  final String? mvHash;

  /// 标准音质 Hash 值 (通常是 MP3)
  final String? hash;

  /// 歌手名
  final String? authorName;

  /// 歌曲标签列表 (风格、心情等)
  final List<SongTag>? tags;

  /// 榜单/评价标签 (如 "旋律优美如流动的诗")
  final String? rankLabel;

  /// 比特率 (如 128)
  final int? bitrate;

  /// MV 文件头标识
  final int? isMvFileHead;

  /// 是否有伴奏 (1: 有, 0: 无)
  final int? hasAccompany;

  /// 128kbps 文件大小
  final int? filesize128;

  /// 专辑名称
  final String? albumName;

  /// 流量主/广告追踪标记
  final String? ztcMark;

  /// 高潮片段结束时间 (毫秒)
  final int? climaxEndTime;

  /// 歌曲 ID (唯一键)
  final int? songid;

  /// 音质等级 (3: 高品质)
  final int? qualityLevel;

  /// 192kbps 文件大小
  final int? filesize192;

  /// 发行日期 (YYYY-MM-DD)
  final String? publishDate;

  /// 默认文件大小
  final int? fileSize;

  /// 是否包含专辑信息
  final int? hasAlbum;

  /// 文件扩展名 (如 "mp3")
  final String? extname;

  /// 类型 (如 "audio")
  final String? type;

  /// 追踪器信息，用于反爬或鉴权
  final TrackerInfo? trackerInfo;

  /// 320kbps (高品) 文件大小
  final int? filesize320;

  /// 等级
  final int? level;

  /// 时长 (秒)
  final int? timeLength;

  /// 推荐文案 ID
  final String? recCopyWriteId;

  /// 旧版版权标识 ?
  final int? oldCpy;

  /// 推荐标签前缀
  final String? recLabelPrefix;

  /// 128kbps Hash 值
  final String? hash128;

  /// 320kbps Hash 值
  final String? hash320;

  /// 关联商品 (周边等)
  final RelateGoods? relateGoods;

  /// 混音歌曲 ID ?
  final String? mixsongid;

  /// 其他版本的 Hash
  final String? hashOther;

  /// 可调整大小的封面 URL模板 (包含 {size})
  final String? sizableCover;

  /// MV 类型
  final int? mvType;

  /// 发布时间戳
  final int? publishTime;

  /// APE 无损格式大小
  final int? filesizeApe;

  /// 推荐标签类型
  final int? recLabelType;

  /// 歌手详细信息列表
  final List<SingerInfo>? singerInfo;

  /// APE 格式 Hash
  final String? hashApe;

  /// 传输参数 (包含复杂的版权、播放控制位)
  final TransParam? transParam;

  /// 320k 时长
  final int? timelength320;

  /// 专辑音频备注
  final String? albumAudioRemark;

  /// 专辑音频 ID
  final String? albumAudioId;

  /// 其他格式大小
  final int? filesizeOther;

  /// IPS 标签 (如 "昨日超万人播放" 等热度标签)
  final List<IpsTag>? ipsTags;

  /// 权限位 (Privilege)
  final int? privilege;

  /// 失败处理流程标识
  final int? failProcess;

  /// 高潮片段开始时间 (毫秒)
  final int? climaxStartTime;

  /// 高潮片段时长 (毫秒)
  final int? climaxTimelength;

  /// 是否已发布
  final int? isPublish;

  const SongItem({
    required this.filesizeFlac,
    required this.officialSongname,
    required this.oriAudioName,
    required this.hash192,
    required this.hashFlac,
    required this.songname,
    required this.musicTrac,
    required this.isOriginal,
    required this.payType,
    required this.songType,
    required this.albumId,
    required this.remark,
    required this.language,
    required this.isFileHead320,
    required this.algPath,
    required this.isFileHead,
    required this.filename,
    required this.cid,
    required this.scid,
    required this.suffixAudioName,
    required this.recCopyWrite,
    required this.mvHash,
    required this.hash,
    required this.authorName,
    required this.tags,
    required this.rankLabel,
    required this.bitrate,
    required this.isMvFileHead,
    required this.hasAccompany,
    required this.filesize128,
    required this.albumName,
    required this.ztcMark,
    required this.climaxEndTime,
    required this.songid,
    required this.qualityLevel,
    required this.filesize192,
    required this.publishDate,
    required this.fileSize,
    required this.hasAlbum,
    required this.extname,
    required this.type,
    required this.trackerInfo,
    required this.filesize320,
    required this.level,
    required this.timeLength,
    required this.recCopyWriteId,
    required this.oldCpy,
    required this.recLabelPrefix,
    required this.hash128,
    required this.hash320,
    required this.relateGoods,
    required this.mixsongid,
    required this.hashOther,
    required this.sizableCover,
    required this.mvType,
    required this.publishTime,
    required this.filesizeApe,
    required this.recLabelType,
    required this.singerInfo,
    required this.hashApe,
    required this.transParam,
    required this.timelength320,
    required this.albumAudioRemark,
    required this.albumAudioId,
    required this.filesizeOther,
    required this.ipsTags,
    required this.privilege,
    required this.failProcess,
    required this.climaxStartTime,
    required this.climaxTimelength,
    required this.isPublish,
  });

  factory SongItem.fromMap(Map<String, dynamic> map) {
    return SongItem(
      filesizeFlac: map['filesize_flac'],
      officialSongname: map['official_songname'],
      oriAudioName: map['ori_audio_name'],
      hash192: map['hash_192'],
      hashFlac: map['hash_flac'],
      songname: map['songname'],
      musicTrac: map['music_trac'],
      isOriginal: map['is_original'],
      payType: map['pay_type'],
      songType: map['song_type'],
      albumId: map['album_id'],
      remark: map['remark'],
      language: map['language'],
      isFileHead320: map['is_file_head_320'],
      algPath: map['alg_path'],
      isFileHead: map['is_file_head'],
      filename: map['filename'],
      cid: map['cid'],
      scid: map['scid'],
      suffixAudioName: map['suffix_audio_name'],
      recCopyWrite: map['rec_copy_write'],
      mvHash: map['mv_hash'],
      hash: map['hash'],
      authorName: map['author_name'],
      tags: map['tags'] != null
          ? List<SongTag>.from(
              (map['tags'] as List).map((x) => SongTag.fromMap(x)),
            )
          : null,
      rankLabel: map['rank_label'],
      bitrate: map['bitrate'],
      isMvFileHead: map['is_mv_file_head'],
      hasAccompany: map['has_accompany'],
      filesize128: map['filesize_128'],
      albumName: map['album_name'],
      ztcMark: map['ztc_mark'],
      climaxEndTime: map['climax_end_time'],
      songid: map['songid'],
      qualityLevel: map['quality_level'],
      filesize192: map['filesize_192'],
      publishDate: map['publish_date'],
      fileSize: map['file_size'],
      hasAlbum: map['has_album'],
      extname: map['extname'],
      type: map['type'],
      trackerInfo: map['tracker_info'] != null
          ? TrackerInfo.fromMap(map['tracker_info'])
          : null,
      filesize320: map['filesize_320'],
      level: map['level'],
      timeLength: map['time_length'],
      recCopyWriteId: map['rec_copy_write_id'],
      oldCpy: map['old_cpy'],
      recLabelPrefix: map['rec_label_prefix'],
      hash128: map['hash_128'],
      hash320: map['hash_320'],
      relateGoods: map['relate_goods'] != null
          ? RelateGoods.fromMap(map['relate_goods'])
          : null,
      mixsongid: map['mixsongid'],
      hashOther: map['hash_other'],
      sizableCover: map['sizable_cover'],
      mvType: map['mv_type'],
      publishTime: map['publish_time'],
      filesizeApe: map['filesize_ape'],
      recLabelType: map['rec_label_type'],
      singerInfo: map['singerinfo'] != null
          ? List<SingerInfo>.from(
              (map['singerinfo'] as List).map((x) => SingerInfo.fromMap(x)),
            )
          : null,
      hashApe: map['hash_ape'],
      transParam: map['trans_param'] != null
          ? TransParam.fromMap(map['trans_param'])
          : null,
      timelength320: map['timelength_320'],
      albumAudioRemark: map['album_audio_remark'],
      albumAudioId: map['album_audio_id'],
      filesizeOther: map['filesize_other'],
      ipsTags: map['ips_tags'] != null && map['ips_tags'] is List
          ? List<IpsTag>.from(
              (map['ips_tags'] as List).map((x) => IpsTag.fromMap(x)),
            )
          : null,
      privilege: map['privilege'],
      failProcess: map['fail_process'],
      climaxStartTime: map['climax_start_time'],
      climaxTimelength: map['climax_timelength'],
      isPublish: map['is_publish'],
    );
  }

  factory SongItem.fromJson(String str) => SongItem.fromMap(json.decode(str));

  Map<String, dynamic> toMap() {
    return {
      'filesize_flac': filesizeFlac,
      'official_songname': officialSongname,
      'ori_audio_name': oriAudioName,
      'hash_192': hash192,
      'hash_flac': hashFlac,
      'songname': songname,
      'music_trac': musicTrac,
      'is_original': isOriginal,
      'pay_type': payType,
      'song_type': songType,
      'album_id': albumId,
      'remark': remark,
      'language': language,
      'is_file_head_320': isFileHead320,
      'alg_path': algPath,
      'is_file_head': isFileHead,
      'filename': filename,
      'cid': cid,
      'scid': scid,
      'suffix_audio_name': suffixAudioName,
      'rec_copy_write': recCopyWrite,
      'mv_hash': mvHash,
      'hash': hash,
      'author_name': authorName,
      'tags': tags?.map((x) => x.toMap()).toList(),
      'rank_label': rankLabel,
      'bitrate': bitrate,
      'is_mv_file_head': isMvFileHead,
      'has_accompany': hasAccompany,
      'filesize_128': filesize128,
      'album_name': albumName,
      'ztc_mark': ztcMark,
      'climax_end_time': climaxEndTime,
      'songid': songid,
      'quality_level': qualityLevel,
      'filesize_192': filesize192,
      'publish_date': publishDate,
      'file_size': fileSize,
      'has_album': hasAlbum,
      'extname': extname,
      'type': type,
      'tracker_info': trackerInfo?.toMap(),
      'filesize_320': filesize320,
      'level': level,
      'time_length': timeLength,
      'rec_copy_write_id': recCopyWriteId,
      'old_cpy': oldCpy,
      'rec_label_prefix': recLabelPrefix,
      'hash_128': hash128,
      'hash_320': hash320,
      'relate_goods': relateGoods?.toMap(),
      'mixsongid': mixsongid,
      'hash_other': hashOther,
      'sizable_cover': sizableCover,
      'mv_type': mvType,
      'publish_time': publishTime,
      'filesize_ape': filesizeApe,
      'rec_label_type': recLabelType,
      'singerinfo': singerInfo?.map((x) => x.toMap()).toList(),
      'hash_ape': hashApe,
      'trans_param': transParam?.toMap(),
      'timelength_320': timelength320,
      'album_audio_remark': albumAudioRemark,
      'album_audio_id': albumAudioId,
      'filesize_other': filesizeOther,
      'ips_tags': ipsTags?.map((x) => x.toMap()).toList(),
      'privilege': privilege,
      'fail_process': failProcess,
      'climax_start_time': climaxStartTime,
      'climax_timelength': climaxTimelength,
      'is_publish': isPublish,
    };
  }

  String toJson() => json.encode(toMap());

  ///获取封面url
  /// [size] 封面大小
  String getSizableCoverUrl({int size = 256}) {
    return sizableCover!.replaceAll('{size}', size.toString());
  }
}

// -----------------------------------------------------------------------------
// Tags 类：歌曲标签
// -----------------------------------------------------------------------------
class SongTag {
  /// 标签 ID
  final String? tagId;

  /// 父级标签 ID (用于层级分类)
  final String? parentId;

  /// 标签名称 (如 "国语", "ACG", "轻快休闲")
  final String? tagName;

  const SongTag({
    required this.tagId,
    required this.parentId,
    required this.tagName,
  });

  factory SongTag.fromMap(Map<String, dynamic> map) {
    return SongTag(
      tagId: map['tag_id'],
      parentId: map['parent_id'],
      tagName: map['tag_name'],
    );
  }

  factory SongTag.fromJson(String str) => SongTag.fromMap(json.decode(str));

  Map<String, dynamic> toMap() {
    return {'tag_id': tagId, 'parent_id': parentId, 'tag_name': tagName};
  }

  String toJson() => json.encode(toMap());
}

// -----------------------------------------------------------------------------
// Tracker_info 类：安全/追踪信息
// -----------------------------------------------------------------------------
class TrackerInfo {
  /// 鉴权字符串
  final String? auth;

  /// 模块 ID
  final int? moduleId;

  /// 开放时间/时间戳
  final String? openTime;

  const TrackerInfo({
    required this.auth,
    required this.moduleId,
    required this.openTime,
  });

  factory TrackerInfo.fromMap(Map<String, dynamic> map) {
    return TrackerInfo(
      auth: map['auth'],
      moduleId: map['module_id'],
      openTime: map['open_time'],
    );
  }

  factory TrackerInfo.fromJson(String str) =>
      TrackerInfo.fromMap(json.decode(str));

  Map<String, dynamic> toMap() {
    return {'auth': auth, 'module_id': moduleId, 'open_time': openTime};
  }

  String toJson() => json.encode(toMap());
}

// -----------------------------------------------------------------------------
// Relate_goods 类：关联商品 (JSON 中通常为空对象，保留占位)
// -----------------------------------------------------------------------------
class RelateGoods {
  const RelateGoods();

  factory RelateGoods.fromMap(Map<String, dynamic> map) {
    return const RelateGoods();
  }

  factory RelateGoods.fromJson(String str) =>
      RelateGoods.fromMap(json.decode(str));

  Map<String, dynamic> toMap() {
    return {};
  }

  String toJson() => json.encode(toMap());
}

// -----------------------------------------------------------------------------
// Singerinfo 类：歌手详细信息
// -----------------------------------------------------------------------------
class SingerInfo {
  /// 歌手名称
  final String? name;

  /// 是否发布 (字符串类型的布尔值 "1")
  final String? isPublish;

  /// 歌手 ID
  final String? id;

  const SingerInfo({
    required this.name,
    required this.isPublish,
    required this.id,
  });

  factory SingerInfo.fromMap(Map<String, dynamic> map) {
    return SingerInfo(
      name: map['name'],
      isPublish: map['is_publish'],
      id: map['id'],
    );
  }

  factory SingerInfo.fromJson(String str) =>
      SingerInfo.fromMap(json.decode(str));

  Map<String, dynamic> toMap() {
    return {'name': name, 'is_publish': isPublish, 'id': id};
  }

  String toJson() => json.encode(toMap());
}

// -----------------------------------------------------------------------------
// Trans_param 类：传输与版权控制参数
// -----------------------------------------------------------------------------
class TransParam {
  /// 版权等级/分数
  final int? cpyGrade;

  /// 统一封面 URL
  final String? unionCover;

  /// 是否所有音质免费 (1: 是)
  final int? allQualityFree;

  /// 语言
  final String? language;

  /// 版权属性位 (Bitmask)
  final int? cpyAttr0;

  /// 音乐包预告/提前量 ?
  final int? musicpackAdvance;

  /// 展示控制位
  final int? display;

  /// 展示率
  final int? displayRate;

  /// OGG 320k 格式大小
  final int? ogg320Filesize;

  /// 音质映射表
  final QualityMap? qualitymap;

  /// OGG 128k Hash
  final String? ogg128Hash;

  /// OGG 320k Hash
  final String? ogg320Hash;

  /// 分类 ID
  final int? cid;

  /// 类别映射表
  final ClassMap? classmap;

  /// OGG 128k 大小
  final int? ogg128Filesize;

  /// IP 限制映射表 (区域限制等)
  final IpMap? ipmap;

  /// APP ID 屏蔽列表 (如 "3124")
  final String? appidBlock;

  /// 多音轨 Hash
  final String? hashMultitrack;

  /// 付费块模板 ID
  final int? payBlockTpl;

  /// 版权等级
  final int? cpyLevel;

  const TransParam({
    required this.cpyGrade,
    required this.unionCover,
    required this.allQualityFree,
    required this.language,
    required this.cpyAttr0,
    required this.musicpackAdvance,
    required this.display,
    required this.displayRate,
    required this.ogg320Filesize,
    required this.qualitymap,
    required this.ogg128Hash,
    required this.ogg320Hash,
    required this.cid,
    required this.classmap,
    required this.ogg128Filesize,
    required this.ipmap,
    required this.appidBlock,
    required this.hashMultitrack,
    required this.payBlockTpl,
    required this.cpyLevel,
  });

  factory TransParam.fromMap(Map<String, dynamic> map) {
    return TransParam(
      cpyGrade: map['cpy_grade'],
      unionCover: map['union_cover'],
      allQualityFree: map['all_quality_free'],
      language: map['language'],
      cpyAttr0: map['cpy_attr0'],
      musicpackAdvance: map['musicpack_advance'],
      display: map['display'],
      displayRate: map['display_rate'],
      ogg320Filesize: map['ogg_320_filesize'],
      qualitymap: map['qualitymap'] != null
          ? QualityMap.fromMap(map['qualitymap'])
          : null,
      ogg128Hash: map['ogg_128_hash'],
      ogg320Hash: map['ogg_320_hash'],
      cid: map['cid'],
      classmap: map['classmap'] != null
          ? ClassMap.fromMap(map['classmap'])
          : null,
      ogg128Filesize: map['ogg_128_filesize'],
      ipmap: map['ipmap'] != null ? IpMap.fromMap(map['ipmap']) : null,
      appidBlock: map['appid_block'],
      hashMultitrack: map['hash_multitrack'],
      payBlockTpl: map['pay_block_tpl'],
      cpyLevel: map['cpy_level'],
    );
  }

  factory TransParam.fromJson(String str) =>
      TransParam.fromMap(json.decode(str));

  Map<String, dynamic> toMap() {
    return {
      'cpy_grade': cpyGrade,
      'union_cover': unionCover,
      'all_quality_free': allQualityFree,
      'language': language,
      'cpy_attr0': cpyAttr0,
      'musicpack_advance': musicpackAdvance,
      'display': display,
      'display_rate': displayRate,
      'ogg_320_filesize': ogg320Filesize,
      'qualitymap': qualitymap?.toMap(),
      'ogg_128_hash': ogg128Hash,
      'ogg_320_hash': ogg320Hash,
      'cid': cid,
      'classmap': classmap?.toMap(),
      'ogg_128_filesize': ogg128Filesize,
      'ipmap': ipmap?.toMap(),
      'appid_block': appidBlock,
      'hash_multitrack': hashMultitrack,
      'pay_block_tpl': payBlockTpl,
      'cpy_level': cpyLevel,
    };
  }

  String toJson() => json.encode(toMap());

  /// 获取封面url
  /// [size] 封面大小
  String getUnionCoverUrl({int size = 256}) {
    return unionCover!.replaceAll('{size}', size.toString());
  }
}

// -----------------------------------------------------------------------------
// Qualitymap 类：音质位映射
// -----------------------------------------------------------------------------
class QualityMap {
  /// 音质位掩码字符串
  final String? bits;

  /// 属性位 0
  final int? attr0;

  /// 属性位 1
  final int? attr1;

  const QualityMap({
    required this.bits,
    required this.attr0,
    required this.attr1,
  });

  factory QualityMap.fromMap(Map<String, dynamic> map) {
    return QualityMap(
      bits: map['bits'],
      attr0: map['attr0'],
      attr1: map['attr1'],
    );
  }

  factory QualityMap.fromJson(String str) =>
      QualityMap.fromMap(json.decode(str));

  Map<String, dynamic> toMap() {
    return {'bits': bits, 'attr0': attr0, 'attr1': attr1};
  }

  String toJson() => json.encode(toMap());
}

// -----------------------------------------------------------------------------
// Classmap 类：分类映射
// -----------------------------------------------------------------------------
class ClassMap {
  /// 属性位 0
  final int? attr0;

  const ClassMap({required this.attr0});

  factory ClassMap.fromMap(Map<String, dynamic> map) {
    return ClassMap(attr0: map['attr0']);
  }

  factory ClassMap.fromJson(String str) => ClassMap.fromMap(json.decode(str));

  Map<String, dynamic> toMap() {
    return {'attr0': attr0};
  }

  String toJson() => json.encode(toMap());
}

// -----------------------------------------------------------------------------
// Ipmap 类：IP 限制映射
// -----------------------------------------------------------------------------
class IpMap {
  /// 属性位 0 (通常是大整数，表示区域掩码)
  final int? attr0;

  const IpMap({required this.attr0});

  factory IpMap.fromMap(Map<String, dynamic> map) {
    return IpMap(attr0: map['attr0']);
  }

  factory IpMap.fromJson(String str) => IpMap.fromMap(json.decode(str));

  Map<String, dynamic> toMap() {
    return {'attr0': attr0};
  }

  String toJson() => json.encode(toMap());
}

// -----------------------------------------------------------------------------
// Ips_tags 类：热度/榜单标签 (如 "昨日超万人播放")
// -----------------------------------------------------------------------------
class IpsTag {
  /// 标签显示名称
  final String? name;

  /// 标签 ID
  final String? ipId;

  /// 父级 ID / PID
  final String? pid;

  const IpsTag({required this.name, required this.ipId, required this.pid});

  factory IpsTag.fromMap(Map<String, dynamic> map) {
    return IpsTag(name: map['name'], ipId: map['ip_id'], pid: map['pid']);
  }

  factory IpsTag.fromJson(String str) => IpsTag.fromMap(json.decode(str));

  Map<String, dynamic> toMap() {
    return {'name': name, 'ip_id': ipId, 'pid': pid};
  }

  String toJson() => json.encode(toMap());
}
