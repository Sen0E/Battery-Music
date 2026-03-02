import 'dart:convert';
import 'dart:developer';

import 'package:battery_music/utils/safe_convert.dart';

/// 搜索建议条目模型（单条建议）
class RecordData {
  /// 搜索建议文案（核心展示内容）
  final String? hintInfo;

  /// 匹配计数（0=无精准匹配）
  final int? matchCount;

  /// 热度值（数值越大热度越高）
  final int? hot;

  /// 是否电台内容（0=非电台）
  final int? isRadio;

  /// 是否歌单内容（1=歌单类建议，0=非歌单）
  final int? isKlist;

  /// 内部使用标识
  final String? use;

  /// 评分（-1=无评分）
  final double? scores;

  /// 语言标识（0=默认）
  final int? la;

  /// 图标标识（0=无图标）
  final int? icon;

  /// 副标题/补充说明
  final String? subtitle;

  RecordData({
    this.hintInfo,
    this.matchCount,
    this.hot,
    this.isRadio,
    this.isKlist,
    this.use,
    this.scores,
    this.la,
    this.icon,
    this.subtitle,
  });

  factory RecordData.fromMap(Map<String, dynamic> map) {
    try {
      map['HintInfo'] as String?;
      // map['MatchCount'] as int?;
      // map['Hot'] as int?;
      // map['IsRadio'] as int?;
      // map['IsKlist'] as int?;
      map['Use'] as String?;
      // map['scores'] as double?;
      // map['la'] as int?;
      // map['icon'] as int?;
      // map['subtitle'] as String?;
    } catch (e) {
      log('[SearchSuggest] RecordData.fromMap: $e');
    }

    return RecordData(
      hintInfo: map['HintInfo'] as String?,
      matchCount: map['MatchCount'] as int?,
      hot: map['Hot'] as int?,
      isRadio: map['IsRadio'] as int?,
      isKlist: map['IsKlist'] as int?,
      use: map['Use'] as String?,
      scores: SafeConvert.toDouble(map['scores']),
      la: map['la'] as int?,
      icon: map['icon'] as int?,
      subtitle: map['subtitle'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'HintInfo': hintInfo,
      'MatchCount': matchCount,
      'Hot': hot,
      'IsRadio': isRadio,
      'IsKlist': isKlist,
      'Use': use,
      'scores': scores,
      'la': la,
      'icon': icon,
      'subtitle': subtitle,
    };
  }

  factory RecordData.fromJson(String source) =>
      RecordData.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 搜索建议分组模型（按类型分组）
class SearchSuggestGroup {
  /// 该分组下的建议条目列表
  final List<RecordData>? recordDatas;

  /// 该分组下的条目总数
  final int? recordCount;

  /// 分组标签名称
  final String? labelName;

  SearchSuggestGroup({this.recordDatas, this.recordCount, this.labelName});

  factory SearchSuggestGroup.fromMap(Map<String, dynamic> map) {
    return SearchSuggestGroup(
      recordDatas: map['RecordDatas'] != null
          ? List<RecordData>.from(
              (map['RecordDatas'] as List).map(
                (x) => RecordData.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      recordCount: map['RecordCount'] as int?,
      labelName: map['LableName'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'RecordDatas': recordDatas?.map((x) => x.toMap()).toList(),
      'RecordCount': recordCount,
      'LableName': labelName,
    };
  }

  factory SearchSuggestGroup.fromJson(String source) =>
      SearchSuggestGroup.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 歌手快捷信息模型（当前为空）
class SingerShortcut {
  /// 歌手ID
  final int? id;

  /// 歌手名称
  final String? name;

  /// 歌手头像
  final String? img;

  /// 歌曲数量
  final int? songCount;

  /// 专辑数量
  final int? albumCount;

  /// 粉丝数量
  final int? fansCount;

  SingerShortcut({
    this.id,
    this.name,
    this.img,
    this.songCount,
    this.albumCount,
    this.fansCount,
  });

  factory SingerShortcut.fromMap(Map<String, dynamic> map) {
    return SingerShortcut(
      id: map['id'] as int?,
      name: map['name'] as String?,
      img: map['img'] as String?,
      songCount: map['song_count'] as int?,
      albumCount: map['album_count'] as int?,
      fansCount: map['fans_count'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'img': img,
      'song_count': songCount,
      'album_count': albumCount,
      'fans_count': fansCount,
    };
  }

  factory SingerShortcut.fromJson(String source) =>
      SingerShortcut.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}

/// 顶层搜索建议全量数据模型（含所有字段）
class SearchSuggest {
  /// 搜索建议分组列表
  final List<SearchSuggestGroup>? data;

  /// 歌手快捷信息（当前为空）
  final SingerShortcut? singerShortcut;

  final int? status;

  SearchSuggest({this.data, this.singerShortcut, this.status});

  factory SearchSuggest.fromMap(Map<String, dynamic> map) {
    return SearchSuggest(
      data: map['data'] != null
          ? List<SearchSuggestGroup>.from(
              (map['data'] as List).map(
                (x) => SearchSuggestGroup.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      singerShortcut: map['SingerShortcut'] != null
          ? SingerShortcut.fromMap(
              map['SingerShortcut'] as Map<String, dynamic>,
            )
          : null,
      status: map['status'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data?.map((x) => x.toMap()).toList(),
      'SingerShortcut': singerShortcut?.toMap(),
      'status': status,
    };
  }

  /// 从完整接口JSON直接解析
  factory SearchSuggest.fromFullJson(String fullJson) {
    Map<String, dynamic> fullMap = json.decode(fullJson);
    return SearchSuggest.fromMap(fullMap);
  }

  factory SearchSuggest.fromJson(String source) =>
      SearchSuggest.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}
