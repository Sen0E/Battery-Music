import 'dart:convert';

// ===================== 嵌套子模型 =====================

/// 主题信息模型（当前无有效内容）
class Theme {
  /// 主题是否有效（false=无效）
  final bool? valid;

  Theme({this.valid});

  factory Theme.fromMap(Map<String, dynamic> map) {
    return Theme(valid: map['valid'] as bool?);
  }

  Map<String, dynamic> toMap() {
    return {'valid': valid};
  }

  factory Theme.fromJson(String source) => Theme.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 歌单透传参数模型
class PlaylistTransParam {
  /// 透传标识（1=开启透传）
  final int? transFlag;

  /// 身份标识（0/8=不同业务标识）
  final int? iden;

  /// 特殊标签标识（0=无特殊标签）
  final int? specialTag;

  PlaylistTransParam({this.transFlag, this.iden, this.specialTag});

  factory PlaylistTransParam.fromMap(Map<String, dynamic> map) {
    return PlaylistTransParam(
      transFlag: map['trans_flag'] as int?,
      iden: map['iden'] as int?,
      specialTag: map['special_tag'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {'trans_flag': transFlag, 'iden': iden, 'special_tag': specialTag};
  }

  factory PlaylistTransParam.fromJson(String source) =>
      PlaylistTransParam.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 歌单搜索结果条目模型
class SearchKeywordsSpecial {
  /// 歌单等级（0=默认）
  final int? grade;

  /// 质量标识（0=默认）
  final int? quality;

  /// 新版质量标识（0=默认）
  final int? qualityNew;

  /// 版本号（0=初始版本）
  final int? version;

  /// 高质量标识（1=高质量歌单）
  final int? highQuality;

  /// 是否用户生成内容（1=UGC歌单）
  final int? isugc;

  /// 是否发布（1=已发布）
  final int? ispublish;

  /// 是否VIP专属（0=普通歌单）
  final int? isvip;

  /// 是否期刊类歌单（0=非期刊）
  final int? isperiodical;

  /// 周期数（0=无）
  final int? nper;

  /// 是否自定义（0=非自定义）
  final int? iscustom;

  /// 歌单ID
  final int? specialid;

  /// 歌单内歌曲数量
  final int? songCount;

  /// 歌单名称
  final String? specialname;

  /// 歌单包含内容描述（关键词/特色）
  final String? contain;

  /// 歌单封面URL
  final String? img;

  /// 歌单简介
  final String? intro;

  /// 等级整数（0=无等级）
  final String? gradeInt;

  /// 等级浮点数（0=无等级）
  final String? gradeFloat;

  /// 发布时间
  final String? publishTime;

  /// 收藏数
  final String? collectCount;

  /// 创建者用户ID
  final String? suid;

  /// 创建者昵称
  final String? nickname;

  /// 电台ID（0=非电台）
  final String? srid;

  /// 播放数（近期）
  final String? playCount;

  /// 总播放数
  final String? totalPlayCount;

  /// 全局ID（收藏标识）
  final String? gid;

  /// 算法路径
  final String? algPath;

  /// 标签字符串（#睡觉）
  final String? tagStr;

  /// 是否互相关注（0=否）
  final int? isMutual;

  /// AB测试标签列表
  final List<dynamic>? abtags;

  /// 透传参数
  final PlaylistTransParam? transParam;

  SearchKeywordsSpecial({
    this.grade,
    this.quality,
    this.qualityNew,
    this.version,
    this.highQuality,
    this.isugc,
    this.ispublish,
    this.isvip,
    this.isperiodical,
    this.nper,
    this.iscustom,
    this.specialid,
    this.songCount,
    this.specialname,
    this.contain,
    this.img,
    this.intro,
    this.gradeInt,
    this.gradeFloat,
    this.publishTime,
    this.collectCount,
    this.suid,
    this.nickname,
    this.srid,
    this.playCount,
    this.totalPlayCount,
    this.gid,
    this.algPath,
    this.tagStr,
    this.isMutual,
    this.abtags,
    this.transParam,
  });

  factory SearchKeywordsSpecial.fromMap(Map<String, dynamic> map) {
    return SearchKeywordsSpecial(
      grade: map['grade'] as int?,
      quality: map['quality'] as int?,
      qualityNew: map['quality_new'] as int?,
      version: map['version'] as int?,
      highQuality: map['high_quality'] as int?,
      isugc: map['isugc'] as int?,
      ispublish: map['ispublish'] as int?,
      isvip: map['isvip'] as int?,
      isperiodical: map['isperiodical'] as int?,
      nper: map['nper'] as int?,
      iscustom: map['iscustom'] as int?,
      specialid: map['specialid'] as int?,
      songCount: map['song_count'] as int?,
      specialname: map['specialname'] as String?,
      contain: map['contain'] as String?,
      img: map['img'] as String?,
      intro: map['intro'] as String?,
      gradeInt: map['grade_int'] as String?,
      gradeFloat: map['grade_float'] as String?,
      publishTime: map['publish_time'] as String?,
      collectCount: map['collect_count'] as String?,
      suid: map['suid'] as String?,
      nickname: map['nickname'] as String?,
      srid: map['srid'] as String?,
      playCount: map['play_count'] as String?,
      totalPlayCount: map['total_play_count'] as String?,
      gid: map['gid'] as String?,
      algPath: map['alg_path'] as String?,
      tagStr: map['tag_str'] as String?,
      isMutual: map['is_mutual'] as int?,
      abtags: map['abtags'] as List<dynamic>?,
      transParam: map['trans_param'] != null
          ? PlaylistTransParam.fromMap(
              map['trans_param'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'grade': grade,
      'quality': quality,
      'quality_new': qualityNew,
      'version': version,
      'high_quality': highQuality,
      'isugc': isugc,
      'ispublish': ispublish,
      'isvip': isvip,
      'isperiodical': isperiodical,
      'nper': nper,
      'iscustom': iscustom,
      'specialid': specialid,
      'song_count': songCount,
      'specialname': specialname,
      'contain': contain,
      'img': img,
      'intro': intro,
      'grade_int': gradeInt,
      'grade_float': gradeFloat,
      'publish_time': publishTime,
      'collect_count': collectCount,
      'suid': suid,
      'nickname': nickname,
      'srid': srid,
      'play_count': playCount,
      'total_play_count': totalPlayCount,
      'gid': gid,
      'alg_path': algPath,
      'tag_str': tagStr,
      'is_mutual': isMutual,
      'abtags': abtags,
      'trans_param': transParam?.toMap(),
    };
  }

  factory SearchKeywordsSpecial.fromJson(String source) =>
      SearchKeywordsSpecial.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 顶层歌单搜索结果数据模型（仅data部分）
// class KugouPlaylistSearchData {
//   /// 每页大小
//   final int? pagesize;
//   /// 当前页码
//   final int? page;
//   /// 来源标识（0=默认）
//   final int? from;
//   /// 当前返回数量
//   final int? size;
//   /// 结果总数
//   final int? total;
//   /// 纠错类型（0=无需纠错）
//   final int? correctiontype;
//   /// 强制纠错标识（0=不强制）
//   final int? correctionforce;
//   /// 纠错提示
//   final String? correctiontip;
//   /// 主题信息
//   final Theme? theme;
//   /// 歌单列表
//   final List<PlaylistSearchItem>? lists;

//   KugouPlaylistSearchData({
//     this.pagesize,
//     this.page,
//     this.from,
//     this.size,
//     this.total,
//     this.correctiontype,
//     this.correctionforce,
//     this.correctiontip,
//     this.theme,
//     this.lists,
//   });

//   factory KugouPlaylistSearchData.fromMap(Map<String, dynamic> map) {
//     return KugouPlaylistSearchData(
//       pagesize: map['pagesize'] as int?,
//       page: map['page'] as int?,
//       from: map['from'] as int?,
//       size: map['size'] as int?,
//       total: map['total'] as int?,
//       correctiontype: map['correctiontype'] as int?,
//       correctionforce: map['correctionforce'] as int?,
//       correctiontip: map['correctiontip'] as String?,
//       theme: map['theme'] != null ? Theme.fromMap(map['theme'] as Map<String, dynamic>) : null,
//       lists: map['lists'] != null 
//           ? List<PlaylistSearchItem>.from((map['lists'] as List).map((x) => PlaylistSearchItem.fromMap(x as Map<String, dynamic>))) 
//           : null,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'pagesize': pagesize,
//       'page': page,
//       'from': from,
//       'size': size,
//       'total': total,
//       'correctiontype': correctiontype,
//       'correctionforce': correctionforce,
//       'correctiontip': correctiontip,
//       'theme': theme?.toMap(),
//       'lists': lists?.map((x) => x.toMap()).toList(),
//     };
//   }

//   /// 从完整接口JSON解析（自动提取data部分）
//   factory KugouPlaylistSearchData.fromFullJson(String fullJson) {
//     Map<String, dynamic> fullMap = json.decode(fullJson);
//     return KugouPlaylistSearchData.fromMap(fullMap['data'] as Map<String, dynamic>);
//   }

//   factory KugouPlaylistSearchData.fromJson(String source) => KugouPlaylistSearchData.fromMap(json.decode(source));
//   String toJson() => json.encode(toMap());
// }