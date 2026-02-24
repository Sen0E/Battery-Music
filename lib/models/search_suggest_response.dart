class SearchSuggestResponse {
  final List<SearchSugges>? recordDatas;

  SearchSuggestResponse({this.recordDatas});

  factory SearchSuggestResponse.fromJson(Map<String, dynamic> json) {
    return SearchSuggestResponse(
      recordDatas: (json['RecordDatas'] as List<dynamic>?)
          ?.map((e) => SearchSugges.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'RecordDatas': recordDatas?.map((e) => e.toJson()).toList(),
  };
}

/// 具体的搜索建议词实体
class SearchSugges {
  final String? hintInfo; // 建议关键词
  final int? matchCount; // 匹配数量
  final int? hot; // 热度值
  final int? isRadio; // 是否电台
  final int? isKlist; // 是否歌单
  final String? use; // 用途标识
  final double? scores; // 分数
  final int? la;
  final int? icon; // 图标标识
  final String? subtitle; // 副标题

  SearchSugges({
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

  factory SearchSugges.fromJson(Map<String, dynamic> json) {
    return SearchSugges(
      hintInfo: json['HintInfo'] as String?,
      matchCount: json['MatchCount'] as int?,
      hot: json['Hot'] as int?,
      isRadio: json['IsRadio'] as int?,
      isKlist: json['IsKlist'] as int?,
      use: json['Use'] as String?,
      scores: (json['scores'] as num?)?.toDouble(),
      la: json['la'] as int?,
      icon: json['icon'] as int?,
      subtitle: json['subtitle'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
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
