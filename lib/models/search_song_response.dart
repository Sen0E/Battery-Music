class SearchSongResponse {
  final int? total;
  final int? page;
  final int? pageSize;
  final int? from; // 分页起始位置
  final List<SongItem>? lists;
  final String? correctionTip;
  final int? correctionType;

  final String? tab; // 当前标签页
  final int? allowErr; // 容错标识

  SearchSongResponse({
    this.total,
    this.page,
    this.pageSize,
    this.from,
    this.lists,
    this.correctionTip,
    this.correctionType,
    this.tab,
    this.allowErr,
  });

  factory SearchSongResponse.fromJson(Map<String, dynamic> json) {
    return SearchSongResponse(
      total: json['total'] as int?,
      page: json['page'] as int?,
      pageSize: json['pagesize'] as int?,
      from: json['from'] as int?,
      correctionTip: json['correctiontip'] as String?,
      correctionType: json['correctiontype'] as int?,
      tab: json['tab'] as String?,
      allowErr: json['allowerr'] as int?,
      lists: (json['lists'] as List<dynamic>?)
          ?.map((e) => SongItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'page': page,
    'pagesize': pageSize,
    'from': from,
    'correctiontip': correctionTip,
    'correctiontype': correctionType,
    'tab': tab,
    'allowerr': allowErr,
    'lists': lists?.map((e) => e.toJson()).toList(),
  };
}

/// 歌曲实体 (最核心的类)
class SongItem {
  // --- 基础信息 ---
  final String? singerName; // 显示的歌手名
  final String? songName; // 歌名
  final String? oriSongName; // 原始歌名
  final String? fileName; // 文件名 "歌手 - 歌名"
  final String? albumName;
  final String? albumId;
  final String? image; // 封面图 URL (包含 {size})

  // --- 标识 ID ---
  final String? fileHash; // 标准 hash
  final int? audioId;
  final int? scid;
  final int? mixSongId;
  final int? albumPrivilege;
  final int? privilege;
  final int? payType;

  // --- 文件属性 ---
  final int? fileSize;
  final int? bitrate;
  final int? duration; // 时长 (秒)
  final String? extName; // 后缀名 mp3/flac/dff
  final int? isOriginal;
  final int? publishAge; // 发布时效

  // --- 标签/辅助信息 ---
  final String? tagContent; // 简易标签 (如: "独家首发7天")
  final List<TagDetail>? tagDetails; // 详细标签
  final SongMatchNode? matchNode; // 搜索匹配度信息
  final String? publishDate; // 发布日期 (新字段: "2026-02-06")
  final int? accompany; // 是否伴奏 (新字段: 1)
  final int? heatLevel; // 热度等级 (新字段: 6)
  final int? rankId; // 排名ID (新字段: 8888)
  final int? ownerCount; // 拥有/收藏人数 (新字段: 551903)

  // --- 音质对象 ---
  final QualityInfo? sq; // 无损 (SQ)
  final QualityInfo? hq; // 高品质 (HQ)
  final QualityInfo? res; // Hi-Res (通常 24bit)
  final QualityInfo? superQ; // Super (母带/DSD)

  // --- 列表/嵌套 ---
  final List<SongItem>? grp; // 歌曲组 (折叠的同名歌曲/不同版本)
  final List<MvInfo>? mvData; // MV 列表
  final List<SingerInfo>? singers; // 结构化的歌手列表

  // --- 透传参数 ---
  final Map<String, dynamic>? transParam;

  SongItem({
    this.singerName,
    this.songName,
    this.oriSongName,
    this.fileName,
    this.albumName,
    this.albumId,
    this.image,
    this.fileHash,
    this.audioId,
    this.scid,
    this.mixSongId,
    this.albumPrivilege,
    this.privilege,
    this.payType,
    this.fileSize,
    this.bitrate,
    this.duration,
    this.extName,
    this.isOriginal,
    this.publishAge,
    this.tagContent,
    this.tagDetails,
    this.matchNode,
    this.publishDate,
    this.accompany,
    this.heatLevel,
    this.rankId,
    this.ownerCount,
    this.sq,
    this.hq,
    this.res,
    this.superQ,
    this.grp,
    this.mvData,
    this.singers,
    this.transParam,
  });

  factory SongItem.fromJson(Map<String, dynamic> json) {
    // 1. 图片字段兜底处理：优先 Image，没有则去 trans_param 里找 union_cover
    String? img = json['Image'] as String?;
    if ((img == null || img.isEmpty) && json['trans_param'] != null) {
      img = json['trans_param']['union_cover'] as String?;
    }

    // 2. 歌名处理逻辑：优先 SongName，其次 OriSongName
    String? finalSongName = json['SongName'] as String?;
    if (finalSongName == null || finalSongName.isEmpty) {
      finalSongName = json['OriSongName'] as String?;
    }

    return SongItem(
      singerName: json['SingerName'] as String?,
      songName: finalSongName,
      oriSongName: json['OriSongName'] as String?,
      fileName: json['FileName'] as String?,
      albumName: json['AlbumName'] as String?,
      albumId: json['AlbumID']?.toString(), // 兼容 int/string
      image: img,

      fileHash: json['FileHash'] as String?,
      audioId: json['Audioid'] as int?,
      scid: json['Scid'] as int?,
      mixSongId: int.tryParse(json['MixSongID']?.toString() ?? ''),
      albumPrivilege: json['AlbumPrivilege'] as int?,
      privilege: json['Privilege'] as int?,
      payType: json['PayType'] as int?,

      fileSize: json['FileSize'] as int?,
      bitrate: json['Bitrate'] as int?,
      // 兼容 Duration 和 TimeLength 字段
      duration: (json['Duration'] as int?) ?? (json['TimeLength'] as int?),
      extName: json['ExtName'] as String?,
      isOriginal: json['IsOriginal'] as int?,
      publishAge: json['PublishAge'] as int?,

      // 新增字段解析
      publishDate: json['PublishDate'] as String?,
      accompany: json['Accompany'] as int?,
      heatLevel: json['HeatLevel'] as int?,
      rankId: json['RankId'] as int?,
      ownerCount: json['OwnerCount'] as int?,

      // 标签解析
      tagContent: json['TagContent'] as String?,
      tagDetails: (json['TagDetails'] as List<dynamic>?)
          ?.map((e) => TagDetail.fromJson(e as Map<String, dynamic>))
          .toList(),

      // 搜索匹配信息
      matchNode: json['SongAccNode'] != null
          ? SongMatchNode.fromJson(json['SongAccNode'])
          : null,

      // 音质解析
      sq: json['SQ'] != null ? QualityInfo.fromJson(json['SQ']) : null,
      hq: json['HQ'] != null ? QualityInfo.fromJson(json['HQ']) : null,
      res: json['Res'] != null ? QualityInfo.fromJson(json['Res']) : null,
      superQ: json['Super'] != null
          ? QualityInfo.fromJson(json['Super'])
          : null,

      // 嵌套结构解析
      grp: (json['Grp'] as List<dynamic>?)
          ?.map((e) => SongItem.fromJson(e as Map<String, dynamic>))
          .toList(),

      mvData: (json['mvdata'] as List<dynamic>?)
          ?.map((e) => MvInfo.fromJson(e as Map<String, dynamic>))
          .toList(),

      singers: (json['Singers'] as List<dynamic>?)
          ?.map((e) => SingerInfo.fromJson(e as Map<String, dynamic>))
          .toList(),

      transParam: json['trans_param'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
    'SingerName': singerName,
    'SongName': songName,
    'OriSongName': oriSongName,
    'FileName': fileName,
    'AlbumName': albumName,
    'AlbumID': albumId,
    'Image': image,
    'FileHash': fileHash,
    'Audioid': audioId,
    'Duration': duration,
    'Privilege': privilege,
    'PublishDate': publishDate,
    'Accompany': accompany,
    'HeatLevel': heatLevel,
    'RankId': rankId,
    'OwnerCount': ownerCount,
    'TagContent': tagContent,
    'TagDetails': tagDetails?.map((e) => e.toJson()).toList(),
    'SQ': sq?.toJson(),
    'HQ': hq?.toJson(),
    'Res': res?.toJson(),
    'Super': superQ?.toJson(),
    'Grp': grp?.map((e) => e.toJson()).toList(),
    'mvdata': mvData?.map((e) => e.toJson()).toList(),
    'Singers': singers?.map((e) => e.toJson()).toList(),
  };

  /// 辅助方法：获取最高音质标签
  String get maxQualityTag {
    if (superQ != null) return "Super";
    if (res != null) return "Hi-Res";
    if (sq != null) return "SQ";
    if (hq != null) return "HQ";
    return "";
  }
}

// --- 以下是辅助类 ---

/// 标签详情 (如 {"content":"评论过万","version":1,"type":5})
class TagDetail {
  final String? content;
  final int? version;
  final int? type;

  TagDetail({this.content, this.version, this.type});

  factory TagDetail.fromJson(Map<String, dynamic> json) {
    return TagDetail(
      content: json['content'] as String?,
      version: json['version'] as int?,
      type: json['type'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'content': content,
    'version': version,
    'type': type,
  };
}

/// 搜索匹配信息 (SongAccNode)
class SongMatchNode {
  final int? round;
  final String? query;
  final int? recallIntent; // 1 通常代表完全匹配

  SongMatchNode({this.round, this.query, this.recallIntent});

  factory SongMatchNode.fromJson(Map<String, dynamic> json) {
    return SongMatchNode(
      round: json['round'] as int?,
      query: json['query'] as String?,
      recallIntent: json['recall_intent'] as int?,
    );
  }
}

/// 音质详情 (SQ, HQ, Res, Super 通用)
class QualityInfo {
  final int? fileSize;
  final String? hash;
  final int? privilege;
  final int? bitRate; // 码率
  final int? timeLength; // 时长
  final String? extName; // 格式

  QualityInfo({
    this.fileSize,
    this.hash,
    this.privilege,
    this.bitRate,
    this.timeLength,
    this.extName,
  });

  factory QualityInfo.fromJson(Map<String, dynamic> json) {
    return QualityInfo(
      fileSize: json['FileSize'] as int?,
      hash: json['Hash'] as String?,
      privilege: json['Privilege'] as int?,
      // 兼容 BitRate 和 Bitrate 大小写
      bitRate: (json['BitRate'] as int?) ?? (json['Bitrate'] as int?),
      timeLength: json['TimeLength'] as int?,
      extName: json['ExtName'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'FileSize': fileSize,
    'Hash': hash,
    'Privilege': privilege,
    'BitRate': bitRate,
    'TimeLength': timeLength,
    'ExtName': extName,
  };
}

/// 歌手信息 (用于 Singers 数组)
class SingerInfo {
  final int? id;
  final String? name;
  final int? ipId;

  SingerInfo({this.id, this.name, this.ipId});

  factory SingerInfo.fromJson(Map<String, dynamic> json) {
    return SingerInfo(
      id: json['id'] as int?,
      name: json['name'] as String?,
      ipId: json['ip_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'ip_id': ipId};
}

/// MV 信息
class MvInfo {
  final String? id;
  final String? hash;
  final String? trk;

  MvInfo({this.id, this.hash, this.trk});

  factory MvInfo.fromJson(Map<String, dynamic> json) {
    return MvInfo(
      id: json['id']?.toString(), // ID 有时是 int 有时是 String
      hash: json['hash'] as String?,
      trk: json['trk'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'hash': hash, 'trk': trk};
}
