import 'dart:convert';

class SearchHot {
  final int? timestamp;
  final List<SearchCategory>? list;

  const SearchHot({required this.timestamp, required this.list});

  factory SearchHot.fromMap(Map<String, dynamic> map) {
    return SearchHot(
      timestamp: map['timestamp'],
      list: map['list'] != null
          ? List<SearchCategory>.from(
              (map['list'] as List).map((x) => SearchCategory.fromMap(x)),
            )
          : null,
    );
  }

  factory SearchHot.fromJson(String str) => SearchHot.fromMap(json.decode(str));

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'list': list?.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}

class SearchCategory {
  final String? name;
  final List<Keywords>? keywords;

  const SearchCategory({required this.name, required this.keywords});

  factory SearchCategory.fromMap(Map<String, dynamic> map) {
    return SearchCategory(
      name: map['name'],
      keywords: map['keywords'] != null
          ? List<Keywords>.from(
              (map['keywords'] as List).map((x) => Keywords.fromMap(x)),
            )
          : null,
    );
  }

  factory SearchCategory.fromJson(String str) =>
      SearchCategory.fromMap(json.decode(str));

  Map<String, dynamic> toMap() {
    return {'name': name, 'keywords': keywords?.map((x) => x.toMap()).toList()};
  }

  String toJson() => json.encode(toMap());
}

class Keywords {
  final String? reason;
  final String? jsonUrl;
  final String? jumpurl;
  final String? keyword;
  final int? isCoverWord;
  final int? type;
  final int? icon;

  const Keywords({
    required this.reason,
    required this.jsonUrl,
    required this.jumpurl,
    required this.keyword,
    required this.isCoverWord,
    required this.type,
    required this.icon,
  });

  factory Keywords.fromMap(Map<String, dynamic> map) {
    return Keywords(
      reason: map['reason'],
      jsonUrl: map['json_url'],
      jumpurl: map['jumpurl'],
      keyword: map['keyword'],
      isCoverWord: map['is_cover_word'],
      type: map['type'],
      icon: map['icon'],
    );
  }

  factory Keywords.fromJson(String str) => Keywords.fromMap(json.decode(str));

  Map<String, dynamic> toMap() {
    return {
      'reason': reason,
      'json_url': jsonUrl,
      'jumpurl': jumpurl,
      'keyword': keyword,
      'is_cover_word': isCoverWord,
      'type': type,
      'icon': icon,
    };
  }

  String toJson() => json.encode(toMap());
}
