class SearchHotResponse {
  final int? timestamp;
  final List<SearchCategory>? list;

  SearchHotResponse({this.timestamp, this.list});

  factory SearchHotResponse.fromJson(Map<String, dynamic> json) {
    return SearchHotResponse(
      timestamp: json['timestamp'] as int?,
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => SearchCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'list': list?.map((e) => e.toJson()).toList(),
    };
  }
}

/// 榜单分类 (如：热搜榜、DJ榜)
class SearchCategory {
  final String? name;
  final List<SearchKeyword>? keywords;

  SearchCategory({this.name, this.keywords});

  factory SearchCategory.fromJson(Map<String, dynamic> json) {
    return SearchCategory(
      name: json['name'] as String?,
      keywords: (json['keywords'] as List<dynamic>?)
          ?.map((e) => SearchKeyword.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'keywords': keywords?.map((e) => e.toJson()).toList(),
    };
  }
}

/// 具体的搜索关键词
class SearchKeyword {
  final String? reason;
  final String? jsonUrl; // 对应 json_url
  final String? jumpUrl; // 对应 jumpurl
  final String? keyword;
  final int? isCoverWord; // 对应 is_cover_word
  final int? type;
  final int? icon;

  SearchKeyword({
    this.reason,
    this.jsonUrl,
    this.jumpUrl,
    this.keyword,
    this.isCoverWord,
    this.type,
    this.icon,
  });

  factory SearchKeyword.fromJson(Map<String, dynamic> json) {
    return SearchKeyword(
      reason: json['reason'] as String?,
      jsonUrl: json['json_url'] as String?,
      jumpUrl: json['jumpurl'] as String?,
      keyword: json['keyword'] as String?,
      isCoverWord: json['is_cover_word'] as int?,
      type: json['type'] as int?,
      icon: json['icon'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reason': reason,
      'json_url': jsonUrl,
      'jumpurl': jumpUrl,
      'keyword': keyword,
      'is_cover_word': isCoverWord,
      'type': type,
      'icon': icon,
    };
  }
}
