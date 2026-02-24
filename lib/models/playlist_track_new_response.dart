class PlaylistTrackDataNew {
  final int? count;
  final int? userId;
  final int? page;
  final int? pageSize;
  final String? snap; // 快照标识
  final String? cursor; // 游标
  final int? listVer; // 列表版本
  final int? listId; // 歌单ID
  final List<PlaylistSong>? songs;

  PlaylistTrackDataNew({
    this.count,
    this.userId,
    this.page,
    this.pageSize,
    this.snap,
    this.cursor,
    this.listVer,
    this.listId,
    this.songs,
  });

  factory PlaylistTrackDataNew.fromJson(Map<String, dynamic> json) {
    return PlaylistTrackDataNew(
      count: json['count'] as int?,
      userId: json['userid'] as int?,
      page: json['page'] as int?,
      pageSize: json['pagesize'] as int?,
      snap: json['snap'] as String?,
      cursor: json['cursor'] as String?,
      listVer: json['list_ver'] as int?,
      listId: json['listid'] as int?,
      // 兼容逻辑：新版使用 info，旧版使用 songs
      songs: ((json['info'] ?? json['songs']) as List<dynamic>?)
          ?.map((e) => PlaylistSong.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'count': count,
    'userid': userId,
    'page': page,
    'pagesize': pageSize,
    'snap': snap,
    'cursor': cursor,
    'list_ver': listVer,
    'listid': listId,
    'info': songs?.map((e) => e.toJson()).toList(),
  };
}

/// 歌单内的歌曲实体 (对应 info/songs 列表项)
class PlaylistSong {
  final String? name; // 歌曲全名 "歌手 - 歌名.mp3"
  final String? hash; // 文件 Hash
  final int? audioId; // 歌曲ID
  final int? timeLen; // 时长 (毫秒)
  final int? bitrate;
  final String? extName; // 后缀 (mp3)
  final int? privilege; // 权限

  // 嵌套信息
  final AlbumInfo? albumInfo;
  final List<SingerInfo>? singerInfo;
  final List<MvInfo>? mvData;

  // 额外字段
  final String? remark; // 备注
  final Map<String, dynamic>? transParam;

  // 新增/修正字段 (兼容新版 JSON)
  final String? cover; // 歌曲封面
  final String? publishDate; // 发布日期
  final String? mvHash; // 新版 MV Hash 直接在歌曲对象里
  final int? size; // 文件大小
  final int? bpm;
  final int? musicpackAdvance;

  PlaylistSong({
    this.name,
    this.hash,
    this.audioId,
    this.timeLen,
    this.bitrate,
    this.extName,
    this.privilege,
    this.albumInfo,
    this.singerInfo,
    this.mvData,
    this.remark,
    this.transParam,
    this.cover,
    this.publishDate,
    this.mvHash,
    this.size,
    this.bpm,
    this.musicpackAdvance,
  });

  factory PlaylistSong.fromJson(Map<String, dynamic> json) {
    return PlaylistSong(
      name: json['name'] as String?,
      hash: json['hash'] as String?,
      // 新版为 audio_id，旧版为 Audioid
      audioId: json['audio_id'] as int? ?? json['Audioid'] as int?,
      // 新版为 timelen (毫秒)
      timeLen: json['timelen'] as int?,
      bitrate: json['bitrate'] as int?,
      // 新版没有直接的 extname，有时候在 name 后缀里，保留旧版兼容
      extName: json['extname'] as String?,
      // 新版为 media_privilege，旧版为 privilege
      privilege: json['media_privilege'] as int? ?? json['privilege'] as int?,

      albumInfo: json['albuminfo'] != null
          ? AlbumInfo.fromJson(json['albuminfo'])
          : null,

      singerInfo: (json['singerinfo'] as List<dynamic>?)
          ?.map((e) => SingerInfo.fromJson(e as Map<String, dynamic>))
          .toList(),

      mvData: (json['mvdata'] as List<dynamic>?)
          ?.map((e) => MvInfo.fromJson(e as Map<String, dynamic>))
          .toList(),

      remark: json['remark'] as String?,
      transParam: json['trans_param'] as Map<String, dynamic>?,

      // 新字段解析
      cover: json['cover'] as String?,
      publishDate: json['publish_date'] as String?,
      // 新版 mvhash 字段在根对象
      mvHash: json['mvhash'] as String?,
      size: json['size'] as int?,
      bpm: json['bpm'] as int?,
      // 是否需要音乐包（会员）
      musicpackAdvance: json['musicpack_advance'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'hash': hash,
    'audio_id': audioId,
    'timelen': timeLen,
    'media_privilege': privilege,
    'albuminfo': albumInfo?.toJson(),
    'singerinfo': singerInfo?.map((e) => e.toJson()).toList(),
    'cover': cover,
    'publish_date': publishDate,
    'mvhash': mvHash,
  };

  /// 辅助 Getter: 获取歌手名字符串 (逗号分隔)
  String get singerName {
    if (singerInfo == null || singerInfo!.isEmpty) return "";
    return singerInfo!.map((e) => e.name).join("、");
  }

  /// 辅助 Getter: 尝试分离歌名 (去除歌手部分和后缀)
  /// 如果 name 是 "OneRepublic - Counting Stars.mp3"，返回 "Counting Stars"
  String get songNameOnly {
    if (name == null) return "";
    String result = name!;

    // 1. 去除歌手前缀 (假设格式 "歌手 - 歌名")
    if (result.contains(" - ")) {
      result = result.split(" - ").last;
    }

    // 2. 去除文件后缀 (.mp3, .flac 等，假设后缀长度不超过 4)
    if (result.contains('.')) {
      int lastDotIndex = result.lastIndexOf('.');
      // 简单判断点号确实在末尾附近
      if (lastDotIndex != -1 && result.length - lastDotIndex <= 5) {
        result = result.substring(0, lastDotIndex);
      }
    }

    return result;
  }

  /// 辅助方法: 获取歌曲封面
  String getCoverUrl({int size = 240}) {
    // 优先使用直接的 cover 字段
    if (cover != null && cover!.isNotEmpty) {
      return cover!.replaceAll('{size}', size.toString());
    }
    // 其次尝试从 transParam 获取 union_cover
    if (transParam != null && transParam!['union_cover'] != null) {
      String url = transParam!['union_cover'];
      return url.replaceAll('{size}', size.toString());
    }
    return "";
  }
}

// --- 辅助类 ---

class AlbumInfo {
  final int? id;
  final String? name;
  final int? category;
  final int? publish;

  AlbumInfo({this.id, this.name, this.category, this.publish});

  factory AlbumInfo.fromJson(Map<String, dynamic> json) {
    return AlbumInfo(
      // 兼容 int 和 String 类型的 ID
      id: int.tryParse(json['id']?.toString() ?? ''),
      name: json['name'] as String?,
      category: json['category'] as int?,
      publish: json['publish'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'publish': publish,
  };
}

class SingerInfo {
  final int? id;
  final String? name;
  final int? type;
  final int? publish;

  SingerInfo({this.id, this.name, this.type, this.publish});

  factory SingerInfo.fromJson(Map<String, dynamic> json) {
    return SingerInfo(
      id: int.tryParse(json['id']?.toString() ?? ''),
      name: json['name'] as String?,
      type: json['type'] as int?,
      publish: json['publish'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'publish': publish,
  };
}

class MvInfo {
  final int? type; // 新版字段名是 typ

  MvInfo({this.type});

  factory MvInfo.fromJson(Map<String, dynamic> json) {
    return MvInfo(type: json['typ'] as int?);
  }

  Map<String, dynamic> toJson() => {'typ': type};
}
