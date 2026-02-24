class PlaylistTrackData {
  final int? count;
  final int? userId;
  final List<PlaylistSong>? songs;
  final PlaylistInfo? listInfo;

  PlaylistTrackData({this.count, this.userId, this.songs, this.listInfo});

  factory PlaylistTrackData.fromJson(Map<String, dynamic> json) {
    return PlaylistTrackData(
      count: json['count'] as int?,
      userId: json['userid'] as int?,
      songs: (json['songs'] as List<dynamic>?)
          ?.map((e) => PlaylistSong.fromJson(e as Map<String, dynamic>))
          .toList(),
      listInfo: json['list_info'] != null
          ? PlaylistInfo.fromJson(json['list_info'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'count': count,
    'userid': userId,
    'songs': songs?.map((e) => e.toJson()).toList(),
    'list_info': listInfo?.toJson(),
  };
}

/// 歌单元数据 (对应 list_info)
class PlaylistInfo {
  final int? listId;
  final String? name; // 歌单名
  final String? intro; // 简介
  final String? pic; // 封面图 (包含 {size})
  final int? playCount; // 播放量
  final int? collectCount; // 收藏量
  final String? tags; // 标签字符串
  final String? username; // 创建者昵称
  final String? userPic; // 创建者头像
  final int? userId; // 创建者ID
  final int? createTime; // 创建时间
  final int? updateTime; // 更新时间

  PlaylistInfo({
    this.listId,
    this.name,
    this.intro,
    this.pic,
    this.playCount,
    this.collectCount,
    this.tags,
    this.username,
    this.userPic,
    this.userId,
    this.createTime,
    this.updateTime,
  });

  factory PlaylistInfo.fromJson(Map<String, dynamic> json) {
    return PlaylistInfo(
      listId: json['listid'] as int?,
      name: json['name'] as String?,
      intro: json['intro'] as String?,
      pic: json['pic'] as String?,
      // 兼容 play_count 和 count 字段
      playCount: json['play_count'] as int? ?? json['count'] as int?,
      collectCount:
          json['collect_total'] as int? ?? json['collect_count'] as int?,
      tags: json['tags'] as String?,
      username: json['list_create_username'] as String?,
      userPic: json['create_user_pic'] as String?,
      userId: json['list_create_userid'] as int?,
      createTime: json['create_time'] as int?,
      updateTime: json['update_time'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'listid': listId,
    'name': name,
    'intro': intro,
    'pic': pic,
    'play_count': playCount,
    'list_create_username': username,
  };

  /// 获取封面图 URL
  String getCoverUrl({int size = 400}) {
    if (pic == null || pic!.isEmpty) return "";
    return pic!.replaceAll('{size}', size.toString());
  }

  /// 获取头像 URL
  String getAvatarUrl({int size = 240}) {
    if (userPic == null || userPic!.isEmpty) return "";
    // 头像 URL 有时候没有 {size} 占位符，直接返回即可，如果有则替换
    if (userPic!.contains('{size}')) {
      return userPic!.replaceAll('{size}', size.toString());
    }
    return userPic!;
  }
}

/// 歌单内的歌曲实体 (对应 songs 列表项)
class PlaylistSong {
  final String? name; // 歌曲全名 "歌手 - 歌名"
  final String? hash; // 文件 Hash
  final int? audioId;
  final int? timeLen; // 时长 (毫秒! 注意与搜索结果的秒不同)
  final int? bitrate;
  final String? extName; // mp3
  final int? privilege; // 权限

  // 嵌套信息
  final AlbumInfo? albumInfo;
  final List<SingerInfo>? singerInfo;
  final List<MvInfo>? mvData;

  // 额外字段
  final String? remark; // 备注/副标题 "更强 (什么不会杀你)"
  final Map<String, dynamic>? transParam;

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
  });

  factory PlaylistSong.fromJson(Map<String, dynamic> json) {
    return PlaylistSong(
      name: json['name'] as String?,
      hash: json['hash'] as String?,
      audioId: json['audio_id'] as int? ?? json['Audioid'] as int?,
      // 注意：歌单详情里的 timelen 通常是毫秒
      timeLen: json['timelen'] as int?,
      bitrate: json['bitrate'] as int?,
      extName: json['extname'] as String?,
      privilege: json['privilege'] as int?,

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
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'hash': hash,
    'timelen': timeLen,
    'albuminfo': albumInfo?.toJson(),
    'singerinfo': singerInfo?.map((e) => e.toJson()).toList(),
  };

  /// 辅助 Getter: 获取歌手名字符串 (逗号分隔)
  String get singerName {
    if (singerInfo == null || singerInfo!.isEmpty) return "";
    return singerInfo!.map((e) => e.name).join("、");
  }

  /// 辅助 Getter: 尝试分离歌名 (去除歌手部分)
  /// 如果 name 是 "Kelly Clarkson - Stronger"，返回 "Stronger"
  String get songNameOnly {
    if (name == null) return "";
    if (name!.contains(" - ")) {
      return name!.split(" - ").last;
    }
    return name!;
  }
}

// --- 辅助类 ---

class AlbumInfo {
  final int? id;
  final String? name;

  AlbumInfo({this.id, this.name});

  factory AlbumInfo.fromJson(Map<String, dynamic> json) {
    return AlbumInfo(
      id: int.tryParse(json['id']?.toString() ?? ''),
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class SingerInfo {
  final int? id;
  final String? name;
  final String? avatar;

  SingerInfo({this.id, this.name, this.avatar});

  factory SingerInfo.fromJson(Map<String, dynamic> json) {
    return SingerInfo(
      id: int.tryParse(json['id']?.toString() ?? ''),
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'avatar': avatar};
}

class MvInfo {
  final int? id; // MV ID
  final String? hash;

  MvInfo({this.id, this.hash});

  factory MvInfo.fromJson(Map<String, dynamic> json) {
    return MvInfo(
      id: int.tryParse(json['id']?.toString() ?? ''),
      hash: json['hash'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'hash': hash};
}
// ```

// ### 使用方法

// **API 调用示例：**

// ```dart
// // 假设获取歌单详情接口
// Future<ApiResponse<PlaylistDetailData>> getPlaylistDetail(String specialId) async {
//   final response = await _apiClient.get(
//     '/playlist/detail', 
//     query: {'specialid': specialId},
//   );

//   return ApiResponse<PlaylistDetailData>.fromJson(
//     response.data,
//     (json) => PlaylistDetailData.fromJson(json as Map<String, dynamic>),
//   );
// }