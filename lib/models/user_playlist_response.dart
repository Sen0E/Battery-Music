class UserPlaylistData {
  final List<UserPlaylist>? info;
  final int? listCount; // 自建歌单数
  final int? collectCount; // 收藏歌单数
  final int? albumCount; // 专辑数
  final int? userId;

  UserPlaylistData({
    this.info,
    this.listCount,
    this.collectCount,
    this.albumCount,
    this.userId,
  });

  factory UserPlaylistData.fromJson(Map<String, dynamic> json) {
    return UserPlaylistData(
      // JSON 里的 info 对应歌单列表
      info: (json['info'] as List<dynamic>?)
          ?.map((e) => UserPlaylist.fromJson(e as Map<String, dynamic>))
          .toList(),
      listCount: json['list_count'] as int?,
      collectCount: json['collect_count'] as int?,
      albumCount: json['album_count'] as int?,
      userId: json['userid'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'info': info?.map((e) => e.toJson()).toList(),
    'list_count': listCount,
    'collect_count': collectCount,
    'album_count': albumCount,
    'userid': userId,
  };
}

/// 单个歌单实体 (对应 info 中的每一项)
class UserPlaylist {
  // --- 核心展示信息 ---
  final int? listId;
  final String? name; // 歌单名 "我喜欢"
  final int? count; // 歌曲总数
  final String? pic; // 封面图 (包含 {size})
  final String? intro; // 简介

  // --- 标识 ---
  final int? isDef; // 1: 默认收藏, 2: 我喜欢, null/0: 普通自建
  final String? globalId; // 全局ID collection_...
  final int? source; // 来源
  final int? type;

  // --- 创建者信息 ---
  final int? userId;
  final String? username;
  final String? userPic; // 用户头像

  // --- 时间 ---
  final int? createTime; // 秒级时间戳
  final int? updateTime; // 秒级时间戳

  UserPlaylist({
    this.listId,
    this.name,
    this.count,
    this.pic,
    this.intro,
    this.isDef,
    this.globalId,
    this.source,
    this.type,
    this.userId,
    this.username,
    this.userPic,
    this.createTime,
    this.updateTime,
  });

  factory UserPlaylist.fromJson(Map<String, dynamic> json) {
    return UserPlaylist(
      listId: json['listid'] as int?,
      name: json['name'] as String?,
      // count 兼容逻辑：优先取 count，没有则取 m_count
      count: json['count'] as int? ?? json['m_count'] as int?,
      pic: json['pic'] as String?,
      intro: json['intro'] as String?,

      // 自建歌单可能没有 is_def 字段，解析为 null
      isDef: json['is_def'] as int?,
      globalId: json['global_collection_id'] as String?,
      source: json['source'] as int?,
      type: json['type'] as int?,

      userId: json['list_create_userid'] as int?,
      username: json['list_create_username'] as String?,
      userPic: json['create_user_pic'] as String?,

      createTime: json['create_time'] as int?,
      updateTime: json['update_time'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'listid': listId,
    'name': name,
    'count': count,
    'pic': pic,
    'intro': intro,
    'is_def': isDef,
    'global_collection_id': globalId,
    'list_create_userid': userId,
    'list_create_username': username,
    'create_user_pic': userPic,
    'create_time': createTime,
    'update_time': updateTime,
  };

  /// 辅助方法：判断是否是 "我喜欢" 歌单
  bool get isMyLike => isDef == 2;

  /// 辅助方法：判断是否是 "默认收藏" 列表
  bool get isDefault => isDef == 1;

  /// 辅助方法：判断是否是 "普通自建歌单" (非系统默认)
  bool get isCustom => isDef == null || isDef == 0;

  /// 辅助方法：获取封面图
  /// 1. 如果是系统歌单 (pic为空)，返回空字符串 (UI层需显示默认图或取前几首歌封面)
  /// 2. 如果是自建歌单 (pic有值)，自动替换 {size} 占位符
  String getCoverUrl({int size = 400}) {
    if (pic == null || pic!.isEmpty) {
      return "";
    }
    return pic!.replaceAll('{size}', size.toString());
  }
}
