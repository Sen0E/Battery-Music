import 'dart:convert';
import 'dart:developer';

import 'package:battery_music/models/v2/response/search_keywords_song.dart';
import 'package:battery_music/models/v2/response/search_keywords_special.dart';

/// 顶层搜索结果数据模型（仅data部分）
class SearchKeywords<T> {
  /// 搜索纠错提示
  final String? correctiontip;

  /// 每页大小
  final int? pagesize;

  /// 当前页码
  final int? page;

  /// 纠错类型（0=无需纠错）
  final int? correctiontype;

  /// 纠错关联词
  final String? correctionrelate;

  /// 结果总数
  final int? total;

  /// 歌曲列表
  final List<T>? lists;

  /// 当前返回数量
  final int? size;

  /// 允许错误标识（0=不允许）
  final int? allowerr;

  /// 标签页（全部）
  final String? tab;

  /// 算法路径
  final String? algPath;

  /// 安全聚合信息
  final List<dynamic>? secAggreV2;

  /// 强制纠错标识（0=不强制）
  final int? correctionforce;

  /// 标签标识（0=无）
  final int? istag;

  /// 来源标识
  final int? from;

  /// 标签结果标识（1=有标签结果）
  final int? istagresult;

  /// 分享结果标识（0=无）
  final int? isshareresult;

  SearchKeywords({
    this.correctiontip,
    this.pagesize,
    this.page,
    this.correctiontype,
    this.correctionrelate,
    this.total,
    this.lists,
    this.size,
    this.allowerr,
    this.tab,
    this.algPath,
    this.secAggreV2,
    this.correctionforce,
    this.istag,
    this.from,
    this.istagresult,
    this.isshareresult,
  });

  factory SearchKeywords.fromMap(Map<String, dynamic> map) {
    return SearchKeywords(
      correctiontip: map['correctiontip'] as String?,
      pagesize: map['pagesize'] as int?,
      page: map['page'] as int?,
      correctiontype: map['correctiontype'] as int?,
      correctionrelate: map['correctionrelate'] as String?,
      total: map['total'] as int?,
      // 这个字段是动态的（歌单、音乐model）
      // 由于Dart泛型限制，无法直接调用T.fromMap，改为特定类型的处理
      lists: map['lists'] != null ? _parseLists<T>(map['lists'] as List) : null,
      size: map['size'] as int?,
      allowerr: map['allowerr'] as int?,
      tab: map['tab'] as String?,
      algPath: map['AlgPath'] as String?,
      secAggreV2: map['sec_aggre_v2'] as List<dynamic>?,
      correctionforce: map['correctionforce'] as int?,
      istag: map['istag'] as int?,
      from: map['from'] as int?,
      istagresult: map['istagresult'] as int?,
      isshareresult: map['isshareresult'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'correctiontip': correctiontip,
      'pagesize': pagesize,
      'page': page,
      'correctiontype': correctiontype,
      'correctionrelate': correctionrelate,
      'total': total,
      'lists': lists?.map((x) {
        if (x is SearchKeywordsSong) {
          return x.toMap();
        }
        if (x is SearchKeywordsSpecial) {
          return x.toMap();
        }
        // 如果有其他类型可以继续 else if
        return (x as dynamic)?.toMap();
      }).toList(),
      'size': size,
      'allowerr': allowerr,
      'tab': tab,
      'AlgPath': algPath,
      'sec_aggre_v2': secAggreV2,
      'correctionforce': correctionforce,
      'istag': istag,
      'from': from,
      'istagresult': istagresult,
      'isshareresult': isshareresult,
    };
  }

  factory SearchKeywords.fromJson(String source) =>
      SearchKeywords.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());

  /// 根据泛型类型T解析lists字段
  /// 由于Dart运行时类型擦除的限制，需要通过类型名称字符串进行判断
  /// 该函数根据传入的类型参数T，将List<Map>数据转换为对应的对象列表
  /// 使用示例：SearchKeywords<SearchKeywordsSong>.fromMap(mapData);
  static List<T>? _parseLists<T>(List list) {
    log(T.toString());
    if (T.toString() == 'SearchKeywordsSong') {
      return List<T>.from(
        list.map(
          (x) => SearchKeywordsSong.fromMap(x as Map<String, dynamic>) as T,
        ),
      );
    }
    if (T.toString() == 'SearchKeywordsSpecial') {
      return List<T>.from(
        list.map(
          (x) => SearchKeywordsSpecial.fromMap(x as Map<String, dynamic>) as T,
        ),
      );
    }
    // 可以为其他类型添加更多条件
    // else if (T.toString() == 'OtherType') { ... }

    // 如果无法确定具体类型，则抛出异常
    throw Exception('Unknown type $T for parsing lists');
  }
}
