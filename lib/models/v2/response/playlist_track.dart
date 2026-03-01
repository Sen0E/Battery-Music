import 'dart:convert';

/// 歌曲MV数据模型
class Mvdata {
  /// MV类型标识（0=普通MV）
  final int? typ;

  Mvdata({this.typ});

  factory Mvdata.fromMap(Map<String, dynamic> map) {
    return Mvdata(typ: map['typ'] as int?);
  }

  Map<String, dynamic> toMap() {
    return {'typ': typ};
  }

  factory Mvdata.fromJson(String source) => Mvdata.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 歌曲标签映射模型
class Tagmap {
  /// 曲风标签ID（526336/524288等，酷狗内部曲风枚举）
  final int? genre0;

  Tagmap({this.genre0});

  factory Tagmap.fromMap(Map<String, dynamic> map) {
    return Tagmap(genre0: map['genre0'] as int?);
  }

  Map<String, dynamic> toMap() {
    return {'genre0': genre0};
  }

  factory Tagmap.fromJson(String source) => Tagmap.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 歌曲音质/大小关联模型
class RelateGoods {
  /// 音频文件大小（字节）
  final int? size;

  /// 对应音质的音频哈希值
  final String? hash;

  /// 音质等级（2=128kbps，4=320kbps，5=无损，6=超清）
  final int? level;

  /// 权限标识（10=可播放/下载）
  final int? privilege;

  /// 码率（128/320/958等，单位kbps）
  final int? bitrate;

  RelateGoods({this.size, this.hash, this.level, this.privilege, this.bitrate});

  factory RelateGoods.fromMap(Map<String, dynamic> map) {
    return RelateGoods(
      size: map['size'] as int?,
      hash: map['hash'] as String?,
      level: map['level'] as int?,
      privilege: map['privilege'] as int?,
      bitrate: map['bitrate'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'size': size,
      'hash': hash,
      'level': level,
      'privilege': privilege,
      'bitrate': bitrate,
    };
  }

  factory RelateGoods.fromJson(String source) =>
      RelateGoods.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 歌曲下载权限模型
class Download {
  /// 下载状态（0=不可下载，1=可下载）
  final int? status;

  /// 音频哈希值
  final String? hash;

  /// 下载失败处理策略（4=默认策略）
  final int? failProcess;

  /// 付费类型（3=需要会员/付费）
  final int? payType;

  Download({this.status, this.hash, this.failProcess, this.payType});

  factory Download.fromMap(Map<String, dynamic> map) {
    return Download(
      status: map['status'] as int?,
      hash: map['hash'] as String?,
      failProcess: map['fail_process'] as int?,
      payType: map['pay_type'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'hash': hash,
      'fail_process': failProcess,
      'pay_type': payType,
    };
  }

  factory Download.fromJson(String source) =>
      Download.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 哈希偏移量模型（试听片段用）
class HashOffset {
  /// 片段哈希值
  final String? clipHash;

  /// 起始字节位置
  final int? startByte;

  /// 文件类型（0=音频）
  final int? fileType;

  /// 结束字节位置
  final int? endByte;

  /// 结束毫秒数
  final int? endMs;

  /// 起始毫秒数
  final int? startMs;

  /// 偏移哈希值
  final String? offsetHash;

  HashOffset({
    this.clipHash,
    this.startByte,
    this.fileType,
    this.endByte,
    this.endMs,
    this.startMs,
    this.offsetHash,
  });

  factory HashOffset.fromMap(Map<String, dynamic> map) {
    return HashOffset(
      clipHash: map['clip_hash'] as String?,
      startByte: map['start_byte'] as int?,
      fileType: map['file_type'] as int?,
      endByte: map['end_byte'] as int?,
      endMs: map['end_ms'] as int?,
      startMs: map['start_ms'] as int?,
      offsetHash: map['offset_hash'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clip_hash': clipHash,
      'start_byte': startByte,
      'file_type': fileType,
      'end_byte': endByte,
      'end_ms': endMs,
      'start_ms': startMs,
      'offset_hash': offsetHash,
    };
  }

  factory HashOffset.fromJson(String source) =>
      HashOffset.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 分类映射模型
class Classmap {
  /// 分类属性值（234881032=音频默认分类）
  final int? attr0;

  Classmap({this.attr0});

  factory Classmap.fromMap(Map<String, dynamic> map) {
    return Classmap(attr0: map['attr0'] as int?);
  }

  Map<String, dynamic> toMap() {
    return {'attr0': attr0};
  }

  factory Classmap.fromJson(String source) =>
      Classmap.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 音质映射模型
class Qualitymap {
  /// 音质二进制标识
  final String? bits;

  /// 音质属性0
  final int? attr0;

  /// 音质属性1
  final int? attr1;

  Qualitymap({this.bits, this.attr0, this.attr1});

  factory Qualitymap.fromMap(Map<String, dynamic> map) {
    return Qualitymap(
      bits: map['bits'] as String?,
      attr0: map['attr0'] as int?,
      attr1: map['attr1'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {'bits': bits, 'attr0': attr0, 'attr1': attr1};
  }

  factory Qualitymap.fromJson(String source) =>
      Qualitymap.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// IP映射模型
class Ipmap {
  /// IP地域限制属性值
  final int? attr0;

  Ipmap({this.attr0});

  factory Ipmap.fromMap(Map<String, dynamic> map) {
    return Ipmap(attr0: map['attr0'] as int?);
  }

  Map<String, dynamic> toMap() {
    return {'attr0': attr0};
  }

  factory Ipmap.fromJson(String source) => Ipmap.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 歌曲透传参数模型
class SongTransParam {
  /// OGG格式128kbps哈希值
  final String? ogg128Hash;

  /// 分类映射
  final Classmap? classmap;

  /// 歌曲语言（国语/英语等）
  final String? language;

  /// 版权属性值
  final int? cpyAttr0;

  /// 音乐包权限（1=需要音乐包）
  final int? musicpackAdvance;

  /// 展示控制（0=默认）
  final int? display;

  /// 展示比例（0=默认）
  final int? displayRate;

  /// OGG格式320kbps文件大小
  final int? ogg320Filesize;

  /// 多轨音频哈希值
  final String? hashMultitrack;

  /// 音质映射
  final Qualitymap? qualitymap;

  /// 版权等级
  final int? cpyGrade;

  /// 哈希偏移量（试听片段）
  final HashOffset? hashOffset;

  /// 内容ID
  final int? cid;

  /// OGG格式128kbps文件大小
  final int? ogg128Filesize;

  /// OGG格式320kbps哈希值
  final String? ogg320Hash;

  /// IP映射
  final Ipmap? ipmap;

  /// APPID限制
  final String? appidBlock;

  /// 付费模块模板
  final int? payBlockTpl;

  /// 联合封面URL
  final String? unionCover;

  /// 版权层级
  final int? cpyLevel;

  SongTransParam({
    this.ogg128Hash,
    this.classmap,
    this.language,
    this.cpyAttr0,
    this.musicpackAdvance,
    this.display,
    this.displayRate,
    this.ogg320Filesize,
    this.hashMultitrack,
    this.qualitymap,
    this.cpyGrade,
    this.hashOffset,
    this.cid,
    this.ogg128Filesize,
    this.ogg320Hash,
    this.ipmap,
    this.appidBlock,
    this.payBlockTpl,
    this.unionCover,
    this.cpyLevel,
  });

  factory SongTransParam.fromMap(Map<String, dynamic> map) {
    return SongTransParam(
      ogg128Hash: map['ogg_128_hash'] as String?,
      classmap: map['classmap'] != null
          ? Classmap.fromMap(map['classmap'] as Map<String, dynamic>)
          : null,
      language: map['language'] as String?,
      cpyAttr0: map['cpy_attr0'] as int?,
      musicpackAdvance: map['musicpack_advance'] as int?,
      display: map['display'] as int?,
      displayRate: map['display_rate'] as int?,
      ogg320Filesize: map['ogg_320_filesize'] as int?,
      hashMultitrack: map['hash_multitrack'] as String?,
      qualitymap: map['qualitymap'] != null
          ? Qualitymap.fromMap(map['qualitymap'] as Map<String, dynamic>)
          : null,
      cpyGrade: map['cpy_grade'] as int?,
      hashOffset: map['hash_offset'] != null
          ? HashOffset.fromMap(map['hash_offset'] as Map<String, dynamic>)
          : null,
      cid: map['cid'] as int?,
      ogg128Filesize: map['ogg_128_filesize'] as int?,
      ogg320Hash: map['ogg_320_hash'] as String?,
      ipmap: map['ipmap'] != null
          ? Ipmap.fromMap(map['ipmap'] as Map<String, dynamic>)
          : null,
      appidBlock: map['appid_block'] as String?,
      payBlockTpl: map['pay_block_tpl'] as int?,
      unionCover: map['union_cover'] as String?,
      cpyLevel: map['cpy_level'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ogg_128_hash': ogg128Hash,
      'classmap': classmap?.toMap(),
      'language': language,
      'cpy_attr0': cpyAttr0,
      'musicpack_advance': musicpackAdvance,
      'display': display,
      'display_rate': displayRate,
      'ogg_320_filesize': ogg320Filesize,
      'hash_multitrack': hashMultitrack,
      'qualitymap': qualitymap?.toMap(),
      'cpy_grade': cpyGrade,
      'hash_offset': hashOffset?.toMap(),
      'cid': cid,
      'ogg_128_filesize': ogg128Filesize,
      'ogg_320_hash': ogg320Hash,
      'ipmap': ipmap?.toMap(),
      'appid_block': appidBlock,
      'pay_block_tpl': payBlockTpl,
      'union_cover': unionCover,
      'cpy_level': cpyLevel,
    };
  }

  factory SongTransParam.fromJson(String source) =>
      SongTransParam.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());

  String getUnionCoverUrl({int size = 100}) {
    return unionCover!.replaceAll('{size}', size.toString());
  }
}

/// 专辑信息模型
class Albuminfo {
  /// 专辑名称
  final String? name;

  /// 专辑ID
  final int? id;

  /// 发布状态（1=已发布）
  final int? publish;

  Albuminfo({this.name, this.id, this.publish});

  factory Albuminfo.fromMap(Map<String, dynamic> map) {
    return Albuminfo(
      name: map['name'] as String?,
      id: map['id'] as int?,
      publish: map['publish'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'id': id, 'publish': publish};
  }

  factory Albuminfo.fromJson(String source) =>
      Albuminfo.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 歌手信息模型
class Singerinfo {
  /// 歌手ID
  final int? id;

  /// 发布状态（1=已发布）
  final int? publish;

  /// 歌手名称
  final String? name;

  /// 歌手头像URL
  final String? avatar;

  /// 歌手类型（0=普通歌手，2=组合）
  final int? type;

  Singerinfo({this.id, this.publish, this.name, this.avatar, this.type});

  factory Singerinfo.fromMap(Map<String, dynamic> map) {
    return Singerinfo(
      id: map['id'] as int?,
      publish: map['publish'] as int?,
      name: map['name'] as String?,
      avatar: map['avatar'] as String?,
      type: map['type'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'publish': publish,
      'name': name,
      'avatar': avatar,
      'type': type,
    };
  }

  factory Singerinfo.fromJson(String source) =>
      Singerinfo.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 单首歌曲信息模型
class SongItem {
  /// MV数据列表
  final List<Mvdata>? mvdata;

  /// 歌曲核心哈希值
  final String? hash;

  /// 歌曲简介
  final String? brief;

  /// 音频ID
  final int? audioId;

  /// MV类型（1=有MV）
  final int? mvtype;

  /// 音频文件大小（字节）
  final int? size;

  /// 发布日期
  final String? publishDate;

  /// 歌曲名称（含歌手）
  final String? name;

  /// MV轨道
  final int? mvtrack;

  /// BPM类型
  final String? bpmType;

  /// 混合歌曲ID
  final int? addMixsongid;

  /// 专辑ID
  final String? albumId;

  /// 歌曲BPM（节拍数）
  final int? bpm;

  /// MV哈希值
  final String? mvhash;

  /// 文件扩展名（mp3）
  final String? extname;

  /// 歌曲语言
  final String? language;

  /// 收藏时间戳
  final int? collecttime;

  /// 合唱标识（0=非合唱）
  final int? csong;

  /// 歌曲备注（如影视剧插曲）
  final String? remark;

  /// 音质等级（1=默认）
  final int? level;

  /// 标签映射
  final Tagmap? tagmap;

  /// 旧版版权标识（0=新版）
  final int? mediaOldCpy;

  /// 音质/大小关联列表
  final List<RelateGoods>? relateGoods;

  /// 下载权限列表
  final List<Download>? download;

  /// 版权标识
  final int? rcflag;

  /// 费用类型（0=免费播放）
  final int? feetype;

  /// 伴奏标识（1=有伴奏）
  final int? hasObbligato;

  /// 歌曲时长（毫秒）
  final int? timelen;

  /// 排序权重
  final int? sort;

  /// 透传参数
  final SongTransParam? transParam;

  /// 媒体类型（audio=音频）
  final String? medistype;

  /// 用户ID（0=系统）
  final int? userId;

  /// 专辑信息
  final Albuminfo? albuminfo;

  /// 码率（128=128kbps）
  final int? bitrate;

  /// 音频组ID
  final String? audioGroupId;

  /// 权限标识
  final int? privilege;

  /// 歌曲封面URL
  final String? cover;

  /// 混合歌曲ID
  final int? mixsongid;

  /// 文件ID
  final int? fileid;

  /// 热度值
  final int? heat;

  /// 歌手信息列表
  final List<Singerinfo>? singerinfo;

  SongItem({
    this.mvdata,
    this.hash,
    this.brief,
    this.audioId,
    this.mvtype,
    this.size,
    this.publishDate,
    this.name,
    this.mvtrack,
    this.bpmType,
    this.addMixsongid,
    this.albumId,
    this.bpm,
    this.mvhash,
    this.extname,
    this.language,
    this.collecttime,
    this.csong,
    this.remark,
    this.level,
    this.tagmap,
    this.mediaOldCpy,
    this.relateGoods,
    this.download,
    this.rcflag,
    this.feetype,
    this.hasObbligato,
    this.timelen,
    this.sort,
    this.transParam,
    this.medistype,
    this.userId,
    this.albuminfo,
    this.bitrate,
    this.audioGroupId,
    this.privilege,
    this.cover,
    this.mixsongid,
    this.fileid,
    this.heat,
    this.singerinfo,
  });

  factory SongItem.fromMap(Map<String, dynamic> map) {
    return SongItem(
      mvdata: map['mvdata'] != null
          ? List<Mvdata>.from(
              (map['mvdata'] as List).map(
                (x) => Mvdata.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      hash: map['hash'] as String?,
      brief: map['brief'] as String?,
      audioId: map['audio_id'] as int?,
      mvtype: map['mvtype'] as int?,
      size: map['size'] as int?,
      publishDate: map['publish_date'] as String?,
      name: map['name'] as String?,
      mvtrack: map['mvtrack'] as int?,
      bpmType: map['bpm_type'] as String?,
      addMixsongid: map['add_mixsongid'] as int?,
      albumId: map['album_id'] as String?,
      bpm: map['bpm'] as int?,
      mvhash: map['mvhash'] as String?,
      extname: map['extname'] as String?,
      language: map['language'] as String?,
      collecttime: map['collecttime'] as int?,
      csong: map['csong'] as int?,
      remark: map['remark'] as String?,
      level: map['level'] as int?,
      tagmap: map['tagmap'] != null
          ? Tagmap.fromMap(map['tagmap'] as Map<String, dynamic>)
          : null,
      mediaOldCpy: map['media_old_cpy'] as int?,
      relateGoods: map['relate_goods'] != null
          ? List<RelateGoods>.from(
              (map['relate_goods'] as List).map(
                (x) => RelateGoods.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      download: map['download'] != null
          ? List<Download>.from(
              (map['download'] as List).map(
                (x) => Download.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      rcflag: map['rcflag'] as int?,
      feetype: map['feetype'] as int?,
      hasObbligato: map['has_obbligato'] as int?,
      timelen: map['timelen'] as int?,
      sort: map['sort'] as int?,
      transParam: map['trans_param'] != null
          ? SongTransParam.fromMap(map['trans_param'] as Map<String, dynamic>)
          : null,
      medistype: map['medistype'] as String?,
      userId: map['user_id'] as int?,
      albuminfo: map['albuminfo'] != null
          ? Albuminfo.fromMap(map['albuminfo'] as Map<String, dynamic>)
          : null,
      bitrate: map['bitrate'] as int?,
      audioGroupId: map['audio_group_id'] as String?,
      privilege: map['privilege'] as int?,
      cover: map['cover'] as String?,
      mixsongid: map['mixsongid'] as int?,
      fileid: map['fileid'] as int?,
      heat: map['heat'] as int?,
      singerinfo: map['singerinfo'] != null
          ? List<Singerinfo>.from(
              (map['singerinfo'] as List).map(
                (x) => Singerinfo.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mvdata': mvdata?.map((x) => x.toMap()).toList(),
      'hash': hash,
      'brief': brief,
      'audio_id': audioId,
      'mvtype': mvtype,
      'size': size,
      'publish_date': publishDate,
      'name': name,
      'mvtrack': mvtrack,
      'bpm_type': bpmType,
      'add_mixsongid': addMixsongid,
      'album_id': albumId,
      'bpm': bpm,
      'mvhash': mvhash,
      'extname': extname,
      'language': language,
      'collecttime': collecttime,
      'csong': csong,
      'remark': remark,
      'level': level,
      'tagmap': tagmap?.toMap(),
      'media_old_cpy': mediaOldCpy,
      'relate_goods': relateGoods?.map((x) => x.toMap()).toList(),
      'download': download?.map((x) => x.toMap()).toList(),
      'rcflag': rcflag,
      'feetype': feetype,
      'has_obbligato': hasObbligato,
      'timelen': timelen,
      'sort': sort,
      'trans_param': transParam?.toMap(),
      'medistype': medistype,
      'user_id': userId,
      'albuminfo': albuminfo?.toMap(),
      'bitrate': bitrate,
      'audio_group_id': audioGroupId,
      'privilege': privilege,
      'cover': cover,
      'mixsongid': mixsongid,
      'fileid': fileid,
      'heat': heat,
      'singerinfo': singerinfo?.map((x) => x.toMap()).toList(),
    };
  }

  factory SongItem.fromJson(String source) =>
      SongItem.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());

  /// 获取歌曲封面图片
  /// [size] 封面大小，默认256
  String getCoverUrl({int size = 256}) {
    return cover!.replaceAll('{size}', size.toString());
  }
}

/// 歌单标签模型
class MusiclibTag {
  /// 标签ID
  final int? tagId;

  /// 父标签ID
  final int? parentId;

  /// 标签名称
  final String? tagName;

  MusiclibTag({this.tagId, this.parentId, this.tagName});

  factory MusiclibTag.fromMap(Map<String, dynamic> map) {
    return MusiclibTag(
      tagId: map['tag_id'] as int?,
      parentId: map['parent_id'] as int?,
      tagName: map['tag_name'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {'tag_id': tagId, 'parent_id': parentId, 'tag_name': tagName};
  }

  factory MusiclibTag.fromJson(String source) =>
      MusiclibTag.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 歌单透传参数模型
class ListTransParam {
  /// 身份标识
  final int? iden;

  ListTransParam({this.iden});

  factory ListTransParam.fromMap(Map<String, dynamic> map) {
    return ListTransParam(iden: map['iden'] as int?);
  }

  Map<String, dynamic> toMap() {
    return {'iden': iden};
  }

  factory ListTransParam.fromJson(String source) =>
      ListTransParam.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 歌单基础信息模型
class ListInfo {
  /// AB标签列表
  final List<dynamic>? abtags;

  /// 歌单标签（逗号分隔）
  final String? tags;

  /// 歌单状态（1=正常）
  final int? status;

  /// 创建者头像URL
  final String? createUserPic;

  /// 是否私密（0=公开）
  final int? isPri;

  /// 新品标识（0=非新品）
  final int? pubNew;

  /// 是否下架（0=正常）
  final int? isDrop;

  /// 创建者用户ID
  final int? listCreateUserid;

  /// 是否发布（1=已发布）
  final int? isPublish;

  /// 音乐库标签列表
  final List<MusiclibTag>? musiclibTags;

  /// 发布类型（0=普通）
  final int? pubType;

  /// 是否精选（0=非精选）
  final int? isFeatured;

  /// 发布日期
  final String? publishDate;

  /// 总收藏数
  final int? collectTotal;

  /// 歌单版本号
  final int? listVer;

  /// 歌单简介
  final String? intro;

  /// 歌单类型（1=收藏的他人歌单）
  final int? type;

  /// 创建者歌单ID
  final int? listCreateListid;

  /// 电台ID（0=非电台）
  final int? radioId;

  /// 来源（1=歌单）
  final int? source;

  /// 透传参数
  final ListTransParam? transParam;

  /// 状态码（1=成功）
  final int? code;

  /// 是否默认歌单（0=否）
  final int? isDef;

  /// 父级全局收藏ID
  final String? parentGlobalCollectionId;

  /// 音质标识
  final String? soundQuality;

  /// 每人可添加数量
  final int? perCount;

  /// 播放列表
  final List<dynamic>? plist;

  /// 创建时间戳
  final int? createTime;

  /// 是否付费（0=免费）
  final int? isPer;

  /// 是否可编辑（2=不可编辑）
  final int? isEdit;

  /// 更新时间戳
  final int? updateTime;

  /// 每人数量
  final int? perNum;

  /// 歌曲总数
  final int? count;

  /// 排序权重
  final int? sort;

  /// 是否自己创建（0=否）
  final int? isMine;

  /// 歌单本地ID
  final int? listid;

  /// 音乐库ID
  final int? musiclibId;

  /// K歌才艺标识
  final int? kqTalent;

  /// 创建者性别（0=未知）
  final int? createUserGender;

  /// 歌单封面URL
  final String? pic;

  /// 创建者昵称
  final String? listCreateUsername;

  /// 歌单名称
  final String? name;

  /// 是否自定义封面（1=是）
  final int? isCustomPic;

  /// 全局收藏ID
  final String? globalCollectionId;

  /// 热度值
  final int? heat;

  /// 创建者全局ID
  final String? listCreateGid;

  ListInfo({
    this.abtags,
    this.tags,
    this.status,
    this.createUserPic,
    this.isPri,
    this.pubNew,
    this.isDrop,
    this.listCreateUserid,
    this.isPublish,
    this.musiclibTags,
    this.pubType,
    this.isFeatured,
    this.publishDate,
    this.collectTotal,
    this.listVer,
    this.intro,
    this.type,
    this.listCreateListid,
    this.radioId,
    this.source,
    this.transParam,
    this.code,
    this.isDef,
    this.parentGlobalCollectionId,
    this.soundQuality,
    this.perCount,
    this.plist,
    this.createTime,
    this.isPer,
    this.isEdit,
    this.updateTime,
    this.perNum,
    this.count,
    this.sort,
    this.isMine,
    this.listid,
    this.musiclibId,
    this.kqTalent,
    this.createUserGender,
    this.pic,
    this.listCreateUsername,
    this.name,
    this.isCustomPic,
    this.globalCollectionId,
    this.heat,
    this.listCreateGid,
  });

  factory ListInfo.fromMap(Map<String, dynamic> map) {
    return ListInfo(
      abtags: map['abtags'] as List<dynamic>?,
      tags: map['tags'] as String?,
      status: map['status'] as int?,
      createUserPic: map['create_user_pic'] as String?,
      isPri: map['is_pri'] as int?,
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
      pubType: map['pub_type'] as int?,
      isFeatured: map['is_featured'] as int?,
      publishDate: map['publish_date'] as String?,
      collectTotal: map['collect_total'] as int?,
      listVer: map['list_ver'] as int?,
      intro: map['intro'] as String?,
      type: map['type'] as int?,
      listCreateListid: map['list_create_listid'] as int?,
      radioId: map['radio_id'] as int?,
      source: map['source'] as int?,
      transParam: map['trans_param'] != null
          ? ListTransParam.fromMap(map['trans_param'] as Map<String, dynamic>)
          : null,
      code: map['code'] as int?,
      isDef: map['is_def'] as int?,
      parentGlobalCollectionId: map['parent_global_collection_id'] as String?,
      soundQuality: map['sound_quality'] as String?,
      perCount: map['per_count'] as int?,
      plist: map['plist'] as List<dynamic>?,
      createTime: map['create_time'] as int?,
      isPer: map['is_per'] as int?,
      isEdit: map['is_edit'] as int?,
      updateTime: map['update_time'] as int?,
      perNum: map['per_num'] as int?,
      count: map['count'] as int?,
      sort: map['sort'] as int?,
      isMine: map['is_mine'] as int?,
      listid: map['listid'] as int?,
      musiclibId: map['musiclib_id'] as int?,
      kqTalent: map['kq_talent'] as int?,
      createUserGender: map['create_user_gender'] as int?,
      pic: map['pic'] as String?,
      listCreateUsername: map['list_create_username'] as String?,
      name: map['name'] as String?,
      isCustomPic: map['is_custom_pic'] as int?,
      globalCollectionId: map['global_collection_id'] as String?,
      heat: map['heat'] as int?,
      listCreateGid: map['list_create_gid'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'abtags': abtags,
      'tags': tags,
      'status': status,
      'create_user_pic': createUserPic,
      'is_pri': isPri,
      'pub_new': pubNew,
      'is_drop': isDrop,
      'list_create_userid': listCreateUserid,
      'is_publish': isPublish,
      'musiclib_tags': musiclibTags?.map((x) => x.toMap()).toList(),
      'pub_type': pubType,
      'is_featured': isFeatured,
      'publish_date': publishDate,
      'collect_total': collectTotal,
      'list_ver': listVer,
      'intro': intro,
      'type': type,
      'list_create_listid': listCreateListid,
      'radio_id': radioId,
      'source': source,
      'trans_param': transParam?.toMap(),
      'code': code,
      'is_def': isDef,
      'parent_global_collection_id': parentGlobalCollectionId,
      'sound_quality': soundQuality,
      'per_count': perCount,
      'plist': plist,
      'create_time': createTime,
      'is_per': isPer,
      'is_edit': isEdit,
      'update_time': updateTime,
      'per_num': perNum,
      'count': count,
      'sort': sort,
      'is_mine': isMine,
      'listid': listid,
      'musiclib_id': musiclibId,
      'kq_talent': kqTalent,
      'create_user_gender': createUserGender,
      'pic': pic,
      'list_create_username': listCreateUsername,
      'name': name,
      'is_custom_pic': isCustomPic,
      'global_collection_id': globalCollectionId,
      'heat': heat,
      'list_create_gid': listCreateGid,
    };
  }

  factory ListInfo.fromJson(String source) =>
      ListInfo.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 顶层歌单详情数据模型（仅data部分）
class PlaylistTrack {
  /// 分页起始索引
  final int? beginIdx;

  /// 每页大小
  final int? pagesize;

  /// 歌曲总数
  final int? count;

  /// 推广信息（空）
  final Map<String, dynamic>? popularization;

  /// 所属用户ID
  final int? userid;

  /// 歌曲列表
  final List<SongItem>? songs;

  /// 歌单基础信息
  final ListInfo? listInfo;

  PlaylistTrack({
    this.beginIdx,
    this.pagesize,
    this.count,
    this.popularization,
    this.userid,
    this.songs,
    this.listInfo,
  });

  factory PlaylistTrack.fromMap(Map<String, dynamic> map) {
    return PlaylistTrack(
      beginIdx: map['begin_idx'] as int?,
      pagesize: map['pagesize'] as int?,
      count: map['count'] as int?,
      popularization: map['popularization'] as Map<String, dynamic>?,
      userid: map['userid'] as int?,
      songs: map['songs'] != null
          ? List<SongItem>.from(
              (map['songs'] as List).map(
                (x) => SongItem.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      listInfo: map['list_info'] != null
          ? ListInfo.fromMap(map['list_info'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'begin_idx': beginIdx,
      'pagesize': pagesize,
      'count': count,
      'popularization': popularization,
      'userid': userid,
      'songs': songs?.map((x) => x.toMap()).toList(),
      'list_info': listInfo?.toMap(),
    };
  }

  /// 从完整接口JSON解析（自动提取data部分）
  factory PlaylistTrack.fromFullJson(String fullJson) {
    Map<String, dynamic> fullMap = json.decode(fullJson);
    return PlaylistTrack.fromMap(fullMap['data'] as Map<String, dynamic>);
  }

  factory PlaylistTrack.fromJson(String source) =>
      PlaylistTrack.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}
