import 'dart:convert';

/// 歌单标签模型
class MusiclibTag {
  final int? tagId;
  final int? parentId;
  final String? tagName;

  MusiclibTag({this.tagId, this.parentId, this.tagName});

  /// 从Map解析
  factory MusiclibTag.fromMap(Map<String, dynamic> map) {
    return MusiclibTag(
      tagId: map['tag_id'] as int?,
      parentId: map['parent_id'] as int?,
      tagName: map['tag_name'] as String?,
    );
  }

  /// 转为Map
  Map<String, dynamic> toMap() {
    return {'tag_id': tagId, 'parent_id': parentId, 'tag_name': tagName};
  }

  /// JSON序列化/反序列化
  factory MusiclibTag.fromJson(String source) =>
      MusiclibTag.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 专辑作者模型
class Author {
  final String? authorName;
  final int? authorId;

  Author({this.authorName, this.authorId});

  factory Author.fromMap(Map<String, dynamic> map) {
    return Author(
      authorName: map['author_name'] as String?,
      authorId: map['author_id'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {'author_name': authorName, 'author_id': authorId};
  }

  factory Author.fromJson(String source) => Author.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 透传参数模型
class TransParam {
  final int? iden;

  TransParam({this.iden});

  factory TransParam.fromMap(Map<String, dynamic> map) {
    return TransParam(iden: map['iden'] as int?);
  }

  Map<String, dynamic> toMap() {
    return {'iden': iden};
  }

  factory TransParam.fromJson(String source) =>
      TransParam.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 歌单/专辑详情模型（info数组项）
class SongListInfo {
  // 歌单标签（逗号分隔字符串）
  final String? tags;
  // 状态：1 = 正常，0 = 失效 / 删除
  final int? status;
  // 歌单创建者头像 URL
  final String? createUserPic;
  final int? perNum;
  final int? pubNew;
  final int? isDrop;
  // 歌单创建者 ID（自建歌单 = 当前用户 ID，收藏歌单 = 原作者 ID）
  final int? listCreateUserid;
  // 是否公开：1 = 公开，0 = 私有
  final int? isPublish;
  // 标签结构化数据（数组）
  final List<MusiclibTag>? musiclibTags;
  final int? pubTime;
  // 歌单 / 专辑名称
  final String? name;
  final int? isFeatured;
  // 歌单版本号
  final int? listVer;
  // 歌单简介
  final String? intro;
  // 类型标识：0 = 用户自建歌单 / 系统默认歌单，1 = 收藏的他人歌单，2 = 收藏的专辑
  final int? type;
  //原歌单 ID（收藏歌单特有）
  final int? listCreateListid;
  final int? radioId;
  // 来源类型：1 = 歌单，2 = 专辑
  final int? source;
  // 是否删除：0 = 未删除，1 = 已删除
  final int? isDel;
  // 是否为当前用户自建：0 = 否（收藏 / 专辑），1 = 是
  final int? isMine;
  final int? perCount;
  // 创建时间戳（秒级）
  final int? createTime;
  final int? kqTalent;
  // 是否可编辑：1 = 自建歌单可编辑，0 = 收藏 / 专辑不可编辑
  final int? isEdit;
  // 最后更新时间戳
  final int? updateTime;
  // 歌单内歌曲数量
  final int? mCount;
  // 	音质标识（空 = 默认
  final String? soundQuality;
  // 歌单展示排序权重
  final int? sort;
  // 透传参数
  final TransParam? transParam;
  // 是否系统默认歌单：1 = 默认收藏，2 = 我喜欢
  final int? isDef;
  final String? listCreateGid;
  // 全局唯一标识
  final String? globalCollectionId;
  final int? isPer;
  // 歌单封面图 URL 含"{size}"
  final String? pic;
  // 歌单创建者昵称
  final String? listCreateUsername;
  // 是否私密歌单：0 = 否，1 = 是
  final int? isPri;
  // 是否自定义封面：1 = 是（他人歌单），0 = 否（系统 / 自建）
  final int? isCustomPic;
  // 歌单 / 专辑在当前用户收藏中的本地 ID
  final int? listid;
  // 发布类型：0 = 普通，2 = 他人原创歌单
  final int? pubType;
  // 歌单内歌曲数量
  final dynamic count; // 可能是int或String（专辑是String）
  // 收藏歌单特有：跳转 / 复制标识
  final int? jumpCopy;
  // 收藏歌单特有：原歌单 ID
  final int? fromListid;
  // 收藏歌单特有：原作者相关标识
  final int? cutd;
  // 专辑特有(创作者数组)
  final List<Author>? authors;
  // 专辑特有：原专辑在酷狗音乐库的 ID
  final int? musiclibId;

  SongListInfo({
    this.tags,
    this.status,
    this.createUserPic,
    this.perNum,
    this.pubNew,
    this.isDrop,
    this.listCreateUserid,
    this.isPublish,
    this.musiclibTags,
    this.pubTime,
    this.name,
    this.isFeatured,
    this.listVer,
    this.intro,
    this.type,
    this.listCreateListid,
    this.radioId,
    this.source,
    this.isDel,
    this.isMine,
    this.perCount,
    this.createTime,
    this.kqTalent,
    this.isEdit,
    this.updateTime,
    this.mCount,
    this.soundQuality,
    this.sort,
    this.transParam,
    this.isDef,
    this.listCreateGid,
    this.globalCollectionId,
    this.isPer,
    this.pic,
    this.listCreateUsername,
    this.isPri,
    this.isCustomPic,
    this.listid,
    this.pubType,
    this.count,
    this.jumpCopy,
    this.fromListid,
    this.cutd,
    this.authors,
    this.musiclibId,
  });

  factory SongListInfo.fromMap(Map<String, dynamic> map) {
    return SongListInfo(
      tags: map['tags'] as String?,
      status: map['status'] as int?,
      createUserPic: map['create_user_pic'] as String?,
      perNum: map['per_num'] as int?,
      pubNew: map['pub_new'] as int?,
      isDrop: map['is_drop'] as int?,
      listCreateUserid: map['list_create_userid'] as int?,
      isPublish: map['is_publish'] as int?,
      musiclibTags: map['musiclib_tags'] != null
          ? List<MusiclibTag>.from(
              (map['musiclib_tags'] as List).map(
                (x) => MusiclibTag.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      pubTime: map['pub_time'] as int?,
      name: map['name'] as String?,
      isFeatured: map['is_featured'] as int?,
      listVer: map['list_ver'] as int?,
      intro: map['intro'] as String?,
      type: map['type'] as int?,
      listCreateListid: map['list_create_listid'] as int?,
      radioId: map['radio_id'] as int?,
      source: map['source'] as int?,
      isDel: map['is_del'] as int?,
      isMine: map['is_mine'] as int?,
      perCount: map['per_count'] as int?,
      createTime: map['create_time'] as int?,
      kqTalent: map['kq_talent'] as int?,
      isEdit: map['is_edit'] as int?,
      updateTime: map['update_time'] as int?,
      mCount: map['m_count'] as int?,
      soundQuality: map['sound_quality'] as String?,
      sort: map['sort'] as int?,
      transParam: map['trans_param'] != null
          ? TransParam.fromMap(map['trans_param'] as Map<String, dynamic>)
          : null,
      isDef: map['is_def'] as int?,
      listCreateGid: map['list_create_gid'] as String?,
      globalCollectionId: map['global_collection_id'] as String?,
      isPer: map['is_per'] as int?,
      pic: map['pic'] as String?,
      listCreateUsername: map['list_create_username'] as String?,
      isPri: map['is_pri'] as int?,
      isCustomPic: map['is_custom_pic'] as int?,
      listid: map['listid'] as int?,
      pubType: map['pub_type'] as int?,
      count: map['count'], // 保留原始类型
      jumpCopy: map['jump_copy'] as int?,
      fromListid: map['from_listid'] as int?,
      cutd: map['cutd'] as int?,
      authors: map['authors'] != null
          ? List<Author>.from(
              (map['authors'] as List).map(
                (x) => Author.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      musiclibId: map['musiclib_id'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tags': tags,
      'status': status,
      'create_user_pic': createUserPic,
      'per_num': perNum,
      'pub_new': pubNew,
      'is_drop': isDrop,
      'list_create_userid': listCreateUserid,
      'is_publish': isPublish,
      'musiclib_tags': musiclibTags?.map((x) => x.toMap()).toList(),
      'pub_time': pubTime,
      'name': name,
      'is_featured': isFeatured,
      'list_ver': listVer,
      'intro': intro,
      'type': type,
      'list_create_listid': listCreateListid,
      'radio_id': radioId,
      'source': source,
      'is_del': isDel,
      'is_mine': isMine,
      'per_count': perCount,
      'create_time': createTime,
      'kq_talent': kqTalent,
      'is_edit': isEdit,
      'update_time': updateTime,
      'm_count': mCount,
      'sound_quality': soundQuality,
      'sort': sort,
      'trans_param': transParam?.toMap(),
      'is_def': isDef,
      'list_create_gid': listCreateGid,
      'global_collection_id': globalCollectionId,
      'is_per': isPer,
      'pic': pic,
      'list_create_username': listCreateUsername,
      'is_pri': isPri,
      'is_custom_pic': isCustomPic,
      'listid': listid,
      'pub_type': pubType,
      'count': count,
      'jump_copy': jumpCopy,
      'from_listid': fromListid,
      'cutd': cutd,
      'authors': authors?.map((x) => x.toMap()).toList(),
      'musiclib_id': musiclibId,
    };
  }

  factory SongListInfo.fromJson(String source) =>
      SongListInfo.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());

  /// 获取歌单封面url
  /// [size] 歌单图片大小
  String getCoverUrl({int size = 256}) {
    return pic!.replaceAll('{size}', size.toString());
  }
}

/// 顶层歌单数据模型（仅data部分）
class UserPlaylist {
  // 包含所有歌单 / 专辑详情
  final List<SongListInfo>? info;
  // 设备标识
  final int? phoneFlag;
  final int? totalVer;
  // 所属用户 ID
  final int? userid;
  // 收藏专辑数量
  final int? albumCount;
  // 歌单总数量
  final int? listCount;
  // 收藏类内容数量
  final int? collectCount;

  UserPlaylist({
    this.info,
    this.phoneFlag,
    this.totalVer,
    this.userid,
    this.albumCount,
    this.listCount,
    this.collectCount,
  });

  factory UserPlaylist.fromMap(Map<String, dynamic> map) {
    return UserPlaylist(
      info: map['info'] != null
          ? List<SongListInfo>.from(
              (map['info'] as List).map(
                (x) => SongListInfo.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      phoneFlag: map['phone_flag'] as int?,
      totalVer: map['total_ver'] as int?,
      userid: map['userid'] as int?,
      albumCount: map['album_count'] as int?,
      listCount: map['list_count'] as int?,
      collectCount: map['collect_count'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'info': info?.map((x) => x.toMap()).toList(),
      'phone_flag': phoneFlag,
      'total_ver': totalVer,
      'userid': userid,
      'album_count': albumCount,
      'list_count': listCount,
      'collect_count': collectCount,
    };
  }

  factory UserPlaylist.fromJson(String source) =>
      UserPlaylist.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}
