import 'dart:convert';

/// 歌曲匹配节点模型（搜索推荐相关）
class SongAccNode {
  /// 推荐轮次
  final int? round;

  /// 搜索关键词
  final String? query;

  /// 重写类型
  final int? rewriteType;

  /// 来源标识
  final int? source;

  /// 召回类型
  final int? recallType;

  /// 匹配等级
  final int? matchLevel;

  /// 召回意图
  final int? recallIntent;

  SongAccNode({
    this.round,
    this.query,
    this.rewriteType,
    this.source,
    this.recallType,
    this.matchLevel,
    this.recallIntent,
  });

  factory SongAccNode.fromMap(Map<String, dynamic> map) {
    return SongAccNode(
      round: map['round'] as int?,
      query: map['query'] as String?,
      rewriteType: map['rewrite_type'] as int?,
      source: map['source'] as int?,
      recallType: map['recall_type'] as int?,
      matchLevel: map['match_level'] as int?,
      recallIntent: map['recall_intent'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'round': round,
      'query': query,
      'rewrite_type': rewriteType,
      'source': source,
      'recall_type': recallType,
      'match_level': matchLevel,
      'recall_intent': recallIntent,
    };
  }

  factory SongAccNode.fromJson(String source) =>
      SongAccNode.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 无损音质（SQ）信息模型
class SQ {
  /// 文件大小（字节）
  final int? fileSize;

  /// 对应音质的哈希值
  final String? hash;

  /// 权限标识（0=无特殊权限）
  final int? privilege;

  SQ({this.fileSize, this.hash, this.privilege});

  factory SQ.fromMap(Map<String, dynamic> map) {
    return SQ(
      fileSize: map['FileSize'] as int?,
      hash: map['Hash'] as String?,
      privilege: map['Privilege'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {'FileSize': fileSize, 'Hash': hash, 'Privilege': privilege};
  }

  factory SQ.fromJson(String source) => SQ.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 高清音质（HQ）信息模型
class HQ {
  /// 文件大小（字节）
  final int? fileSize;

  /// 对应音质的哈希值
  final String? hash;

  /// 权限标识（0=无特殊权限）
  final int? privilege;

  HQ({this.fileSize, this.hash, this.privilege});

  factory HQ.fromMap(Map<String, dynamic> map) {
    return HQ(
      fileSize: map['FileSize'] as int?,
      hash: map['Hash'] as String?,
      privilege: map['Privilege'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {'FileSize': fileSize, 'Hash': hash, 'Privilege': privilege};
  }

  factory HQ.fromJson(String source) => HQ.fromMap(json.decode(source));
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

/// 搜索结果透传参数模型
class SearchTransParam {
  /// 版权等级
  final int? cpyGrade;

  /// 联合封面URL
  final String? unionCover;

  /// 全音质免费标识（1=免费）
  final int? allQualityFree;

  /// 歌曲语言
  final String? language;

  /// 版权属性值
  final int? cpyAttr0;

  /// 音乐包权限（0=无需音乐包）
  final int? musicpackAdvance;

  /// OGG格式128kbps文件大小
  final int? ogg128Filesize;

  /// 展示比例（0=默认）
  final int? displayRate;

  /// 版权层级
  final int? cpyLevel;

  /// 付费模块模板
  final int? payBlockTpl;

  /// 音质映射
  final Qualitymap? qualitymap;

  /// 多轨音频哈希值
  final String? hashMultitrack;

  /// 提供商标识
  final int? provider;

  /// 内容ID
  final int? cid;

  /// IP映射
  final Ipmap? ipmap;

  /// 展示控制（0=默认）
  final int? display;

  /// OGG格式320kbps哈希值
  final String? ogg320Hash;

  /// APPID限制
  final String? appidBlock;

  /// OGG格式128kbps哈希值
  final String? ogg128Hash;

  /// 分类映射
  final Classmap? classmap;

  /// OGG格式320kbps文件大小
  final int? ogg320Filesize;

  /// 歌曲名后缀
  final String? songnameSuffix;

  SearchTransParam({
    this.cpyGrade,
    this.unionCover,
    this.allQualityFree,
    this.language,
    this.cpyAttr0,
    this.musicpackAdvance,
    this.ogg128Filesize,
    this.displayRate,
    this.cpyLevel,
    this.payBlockTpl,
    this.qualitymap,
    this.hashMultitrack,
    this.provider,
    this.cid,
    this.ipmap,
    this.display,
    this.ogg320Hash,
    this.appidBlock,
    this.ogg128Hash,
    this.classmap,
    this.ogg320Filesize,
    this.songnameSuffix,
  });

  factory SearchTransParam.fromMap(Map<String, dynamic> map) {
    return SearchTransParam(
      cpyGrade: map['cpy_grade'] as int?,
      unionCover: map['union_cover'] as String?,
      allQualityFree: map['all_quality_free'] as int?,
      language: map['language'] as String?,
      cpyAttr0: map['cpy_attr0'] as int?,
      musicpackAdvance: map['musicpack_advance'] as int?,
      ogg128Filesize: map['ogg_128_filesize'] as int?,
      displayRate: map['display_rate'] as int?,
      cpyLevel: map['cpy_level'] as int?,
      payBlockTpl: map['pay_block_tpl'] as int?,
      qualitymap: map['qualitymap'] != null
          ? Qualitymap.fromMap(map['qualitymap'] as Map<String, dynamic>)
          : null,
      hashMultitrack: map['hash_multitrack'] as String?,
      provider: map['provider'] as int?,
      cid: map['cid'] as int?,
      ipmap: map['ipmap'] != null
          ? Ipmap.fromMap(map['ipmap'] as Map<String, dynamic>)
          : null,
      display: map['display'] as int?,
      ogg320Hash: map['ogg_320_hash'] as String?,
      appidBlock: map['appid_block'] as String?,
      ogg128Hash: map['ogg_128_hash'] as String?,
      classmap: map['classmap'] != null
          ? Classmap.fromMap(map['classmap'] as Map<String, dynamic>)
          : null,
      ogg320Filesize: map['ogg_320_filesize'] as int?,
      songnameSuffix: map['songname_suffix'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cpy_grade': cpyGrade,
      'union_cover': unionCover,
      'all_quality_free': allQualityFree,
      'language': language,
      'cpy_attr0': cpyAttr0,
      'musicpack_advance': musicpackAdvance,
      'ogg_128_filesize': ogg128Filesize,
      'display_rate': displayRate,
      'cpy_level': cpyLevel,
      'pay_block_tpl': payBlockTpl,
      'qualitymap': qualitymap?.toMap(),
      'hash_multitrack': hashMultitrack,
      'provider': provider,
      'cid': cid,
      'ipmap': ipmap?.toMap(),
      'display': display,
      'ogg_320_hash': ogg320Hash,
      'appid_block': appidBlock,
      'ogg_128_hash': ogg128Hash,
      'classmap': classmap?.toMap(),
      'ogg_320_filesize': ogg320Filesize,
      'songname_suffix': songnameSuffix,
    };
  }

  factory SearchTransParam.fromJson(String source) =>
      SearchTransParam.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// MV数据模型
class Mvdata {
  /// MV类型标识（0=普通MV）
  final int? typ;

  /// MV轨道
  final String? trk;

  /// MV哈希值
  final String? hash;

  /// MV ID
  final String? id;

  Mvdata({this.typ, this.trk, this.hash, this.id});

  factory Mvdata.fromMap(Map<String, dynamic> map) {
    return Mvdata(
      typ: map['typ'] as int?,
      trk: map['trk'] as String?,
      hash: map['hash'] as String?,
      id: map['id'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {'typ': typ, 'trk': trk, 'hash': hash, 'id': id};
  }

  factory Mvdata.fromJson(String source) => Mvdata.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 无损/超清音质（Res）信息模型
class Res {
  /// 文件大小（字节）
  final int? fileSize;

  /// 权限标识（0=无特殊权限）
  final int? privilege;

  /// 对应音质的哈希值
  final String? hash;

  /// 码率（kbps）
  final int? bitRate;

  /// 时长（秒）
  final int? timeLength;

  Res({
    this.fileSize,
    this.privilege,
    this.hash,
    this.bitRate,
    this.timeLength,
  });

  factory Res.fromMap(Map<String, dynamic> map) {
    return Res(
      fileSize: map['FileSize'] as int?,
      privilege: map['Privilege'] as int?,
      hash: map['Hash'] as String?,
      bitRate: map['BitRate'] as int?,
      timeLength: map['TimeLength'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'FileSize': fileSize,
      'Privilege': privilege,
      'Hash': hash,
      'BitRate': bitRate,
      'TimeLength': timeLength,
    };
  }

  factory Res.fromJson(String source) => Res.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 歌手信息模型
class Singers {
  /// 歌手名称
  final String? name;

  /// IP ID（地域相关）
  final int? ipId;

  /// 歌手ID
  final int? id;

  Singers({this.name, this.ipId, this.id});

  factory Singers.fromMap(Map<String, dynamic> map) {
    return Singers(
      name: map['name'] as String?,
      ipId: map['ip_id'] as int?,
      id: map['id'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'ip_id': ipId, 'id': id};
  }

  factory Singers.fromJson(String source) =>
      Singers.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 标签详情模型
class TagDetails {
  /// 标签内容（如“评论过万”）
  final String? content;

  /// 版本号
  final int? version;

  /// 类型（5=热度标签）
  final int? type;

  TagDetails({this.content, this.version, this.type});

  factory TagDetails.fromMap(Map<String, dynamic> map) {
    return TagDetails(
      content: map['content'] as String?,
      version: map['version'] as int?,
      type: map['type'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {'content': content, 'version': version, 'type': type};
  }

  factory TagDetails.fromJson(String source) =>
      TagDetails.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 预发布信息模型
class PrepublishInfo {
  /// 预约数
  final int? reserveCount;

  /// 展示时间
  final String? displayTime;

  /// ID
  final int? id;

  /// 发布时间
  final String? publishTime;

  PrepublishInfo({
    this.reserveCount,
    this.displayTime,
    this.id,
    this.publishTime,
  });

  factory PrepublishInfo.fromMap(Map<String, dynamic> map) {
    return PrepublishInfo(
      reserveCount: map['ReserveCount'] as int?,
      displayTime: map['DisplayTime'] as String?,
      id: map['Id'] as int?,
      publishTime: map['PublishTime'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ReserveCount': reserveCount,
      'DisplayTime': displayTime,
      'Id': id,
      'PublishTime': publishTime,
    };
  }

  factory PrepublishInfo.fromJson(String source) =>
      PrepublishInfo.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 搜索结果单首歌曲模型
class SearchKeywordsSong {
  /// 发布时间
  final String? publishTime;

  /// 音频ID
  final int? audioId;

  /// 旧版版权标识（1=旧版）
  final int? oldCpy;

  /// 发布时长（天）
  final int? publishAge;

  /// 付费类型（0=免费）
  final int? payType;

  /// 歌曲匹配节点（搜索推荐）
  final SongAccNode? songAccNode;

  /// 伴奏标识（1=有伴奏）
  final int? accompany;

  /// 歌手名称（拼接字符串）
  final String? singerName;

  /// 展示标识（0=正常展示）
  final int? showingFlag;

  /// 来源
  final String? source;

  /// 无损音质（SQ）信息
  final SQ? sq;

  /// 专辑辅助信息
  final String? albumAux;

  /// 歌曲封面URL
  final String? image;

  /// 高清音质（HQ）信息
  final HQ? hq;

  /// M4A格式文件大小
  final int? m4aSize;

  /// 热度等级（6=高热度）
  final int? heatLevel;

  /// 透传参数
  final SearchTransParam? transParam;

  /// 上传者内容
  final String? uploaderContent;

  /// 标准音质文件大小（字节）
  final int? fileSize;

  /// 是否原创（1=原创）
  final int? isOriginal;

  /// 标准音质哈希值
  final String? fileHash;

  /// 折叠类型（0=不折叠）
  final int? foldType;

  /// 分组信息
  final List<dynamic>? grp;

  /// 是否预发布（0=已发布）
  final int? isPrepublish;

  /// 媒体类型（audio=音频）
  final String? type;

  /// 码率（128=128kbps）
  final int? bitrate;

  /// 文件扩展名（mp3）
  final String? extName;

  /// 榜单ID（0=非榜单）
  final int? topID;

  /// 专辑权限
  final int? albumPrivilege;

  /// 专辑ID
  final String? albumID;

  /// 专辑名称
  final String? albumName;

  /// MV数据列表
  final List<Mvdata>? mvdata;

  /// 别名
  final String? otherName;

  /// 超清音质（Res）信息
  final Res? res;

  /// 来源ID
  final int? sourceID;

  /// 混合歌曲ID
  final String? mixSongID;

  /// 失败处理策略
  final int? failProcess;

  /// 歌曲名后缀
  final String? suffix;

  /// 匹配标识
  final int? matchFlag;

  /// 内容ID
  final int? scid;

  /// 歌手信息列表
  final List<Singers>? singers;

  /// 辅助信息（如歌曲用途）
  final String? auxiliary;

  /// 排名ID
  final int? rankId;

  /// 发布日期
  final String? publishDate;

  /// 标签详情列表
  final List<TagDetails>? tagDetails;

  /// 标签内容（拼接字符串）
  final String? tagContent;

  /// 预发布信息
  final PrepublishInfo? prepublishInfo;

  /// 拥有者数量（播放/收藏数）
  final int? ownerCount;

  /// 上传者
  final String? uploader;

  /// 歌曲时长（秒）
  final int? duration;

  /// 原始歌曲名称
  final String? oriSongName;

  /// 文件名称（含歌手+歌名）
  final String? fileName;

  /// 推荐类型
  final int? recommendType;

  SearchKeywordsSong({
    this.publishTime,
    this.audioId,
    this.oldCpy,
    this.publishAge,
    this.payType,
    this.songAccNode,
    this.accompany,
    this.singerName,
    this.showingFlag,
    this.source,
    this.sq,
    this.albumAux,
    this.image,
    this.hq,
    this.m4aSize,
    this.heatLevel,
    this.transParam,
    this.uploaderContent,
    this.fileSize,
    this.isOriginal,
    this.fileHash,
    this.foldType,
    this.grp,
    this.isPrepublish,
    this.type,
    this.bitrate,
    this.extName,
    this.topID,
    this.albumPrivilege,
    this.albumID,
    this.albumName,
    this.mvdata,
    this.otherName,
    this.res,
    this.sourceID,
    this.mixSongID,
    this.failProcess,
    this.suffix,
    this.matchFlag,
    this.scid,
    this.singers,
    this.auxiliary,
    this.rankId,
    this.publishDate,
    this.tagDetails,
    this.tagContent,
    this.prepublishInfo,
    this.ownerCount,
    this.uploader,
    this.duration,
    this.oriSongName,
    this.fileName,
    this.recommendType,
  });

  factory SearchKeywordsSong.fromMap(Map<String, dynamic> map) {
    return SearchKeywordsSong(
      publishTime: map['PublishTime'] as String?,
      audioId: map['Audioid'] as int?,
      oldCpy: map['OldCpy'] as int?,
      publishAge: map['PublishAge'] as int?,
      payType: map['PayType'] as int?,
      songAccNode: map['SongAccNode'] != null
          ? SongAccNode.fromMap(map['SongAccNode'] as Map<String, dynamic>)
          : null,
      accompany: map['Accompany'] as int?,
      singerName: map['SingerName'] as String?,
      showingFlag: map['ShowingFlag'] as int?,
      source: map['Source'] as String?,
      sq: map['SQ'] != null
          ? SQ.fromMap(map['SQ'] as Map<String, dynamic>)
          : null,
      albumAux: map['AlbumAux'] as String?,
      image: map['Image'] as String?,
      hq: map['HQ'] != null
          ? HQ.fromMap(map['HQ'] as Map<String, dynamic>)
          : null,
      m4aSize: map['M4aSize'] as int?,
      heatLevel: map['HeatLevel'] as int?,
      transParam: map['trans_param'] != null
          ? SearchTransParam.fromMap(map['trans_param'] as Map<String, dynamic>)
          : null,
      uploaderContent: map['UploaderContent'] as String?,
      fileSize: map['FileSize'] as int?,
      isOriginal: map['IsOriginal'] as int?,
      fileHash: map['FileHash'] as String?,
      foldType: map['FoldType'] as int?,
      grp: map['Grp'] as List<dynamic>?,
      isPrepublish: map['isPrepublish'] as int?,
      type: map['Type'] as String?,
      bitrate: map['Bitrate'] as int?,
      extName: map['ExtName'] as String?,
      topID: map['TopID'] as int?,
      albumPrivilege: map['AlbumPrivilege'] as int?,
      albumID: map['AlbumID'] as String?,
      albumName: map['AlbumName'] as String?,
      mvdata: map['mvdata'] != null
          ? List<Mvdata>.from(
              (map['mvdata'] as List).map(
                (x) => Mvdata.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      otherName: map['OtherName'] as String?,
      res: map['Res'] != null
          ? Res.fromMap(map['Res'] as Map<String, dynamic>)
          : null,
      sourceID: map['SourceID'] as int?,
      mixSongID: map['MixSongID'] as String?,
      failProcess: map['FailProcess'] as int?,
      suffix: map['Suffix'] as String?,
      matchFlag: map['MatchFlag'] as int?,
      scid: map['Scid'] as int?,
      singers: map['Singers'] != null
          ? List<Singers>.from(
              (map['Singers'] as List).map(
                (x) => Singers.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      auxiliary: map['Auxiliary'] as String?,
      rankId: map['RankId'] as int?,
      publishDate: map['PublishDate'] as String?,
      tagDetails: map['TagDetails'] != null
          ? List<TagDetails>.from(
              (map['TagDetails'] as List).map(
                (x) => TagDetails.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      tagContent: map['TagContent'] as String?,
      prepublishInfo: map['PrepublishInfo'] != null
          ? PrepublishInfo.fromMap(
              map['PrepublishInfo'] as Map<String, dynamic>,
            )
          : null,
      ownerCount: map['OwnerCount'] as int?,
      uploader: map['Uploader'] as String?,
      duration: map['Duration'] as int?,
      oriSongName: map['OriSongName'] as String?,
      fileName: map['FileName'] as String?,
      recommendType: map['recommend_type'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'PublishTime': publishTime,
      'Audioid': audioId,
      'OldCpy': oldCpy,
      'PublishAge': publishAge,
      'PayType': payType,
      'SongAccNode': songAccNode?.toMap(),
      'Accompany': accompany,
      'SingerName': singerName,
      'ShowingFlag': showingFlag,
      'Source': source,
      'SQ': sq?.toMap(),
      'AlbumAux': albumAux,
      'Image': image,
      'HQ': hq?.toMap(),
      'M4aSize': m4aSize,
      'HeatLevel': heatLevel,
      'trans_param': transParam?.toMap(),
      'UploaderContent': uploaderContent,
      'FileSize': fileSize,
      'IsOriginal': isOriginal,
      'FileHash': fileHash,
      'FoldType': foldType,
      'Grp': grp,
      'isPrepublish': isPrepublish,
      'Type': type,
      'Bitrate': bitrate,
      'ExtName': extName,
      'TopID': topID,
      'AlbumPrivilege': albumPrivilege,
      'AlbumID': albumID,
      'AlbumName': albumName,
      'mvdata': mvdata?.map((x) => x.toMap()).toList(),
      'OtherName': otherName,
      'Res': res?.toMap(),
      'SourceID': sourceID,
      'MixSongID': mixSongID,
      'FailProcess': failProcess,
      'Suffix': suffix,
      'MatchFlag': matchFlag,
      'Scid': scid,
      'Singers': singers?.map((x) => x.toMap()).toList(),
      'Auxiliary': auxiliary,
      'RankId': rankId,
      'PublishDate': publishDate,
      'TagDetails': tagDetails?.map((x) => x.toMap()).toList(),
      'TagContent': tagContent,
      'PrepublishInfo': prepublishInfo?.toMap(),
      'OwnerCount': ownerCount,
      'Uploader': uploader,
      'Duration': duration,
      'OriSongName': oriSongName,
      'FileName': fileName,
      'recommend_type': recommendType,
    };
  }

  factory SearchKeywordsSong.fromJson(String source) =>
      SearchKeywordsSong.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());

  /// 获取音乐封面URL
  String getImageUrl({int? size = 256}) {
    return image!.replaceAll('{size}', size.toString());
  }
}
