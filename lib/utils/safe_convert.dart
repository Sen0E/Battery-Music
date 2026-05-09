class SafeConvert {
  static int toInt(dynamic val, [int defaultValue = 0]) {
    if (val == null) return defaultValue;
    if (val is int) return val;
    if (val is double) return val.toInt(); // 处理 1.0
    if (val is bool) return val ? 1 : 0; // 处理布尔值
    return int.tryParse(val.toString()) ?? defaultValue;
  }

  static double toDouble(dynamic val, [double defaultValue = 0.0]) {
    if (val == null) return defaultValue;
    if (val is double) return val;
    if (val is int) return val.toDouble(); // 处理整数
    if (val is bool) return val ? 1.0 : 0.0; // 处理布尔值
    return double.tryParse(val.toString()) ?? defaultValue;
  }

  static String toStringValue(dynamic val, [String defaultValue = '']) {
    if (val == null) return defaultValue;
    return val.toString();
  }

  static DateTime? toDateTime(dynamic val) {
    if (val == null) return null;
    if (val is DateTime) return val;
    return DateTime.tryParse(val.toString());
  }

  static Map<String, dynamic>? toMap(dynamic val) {
    if (val == null) return null;
    if (val is Map<String, dynamic>) return val;
    if (val is Map) return Map<String, dynamic>.from(val);
    return null;
  }

  static T enumValue<T>(Map<String, T> values, dynamic key, T defaultValue) {
    return values[toStringValue(key)] ?? defaultValue;
  }

  static List<T> toMappedList<T>(
    dynamic val,
    T Function(Map<String, dynamic> map) fromMap, {
    List<String> nestedKeys = const [
      'list',
      'lists',
      'items',
      'data',
      'songs',
      'song_list',
      'special_list',
    ],
  }) {
    final rawItems = _toIterable(val, nestedKeys);
    final items = <T>[];

    for (final rawItem in rawItems) {
      final itemMap = toMap(rawItem);
      if (itemMap != null) {
        items.add(fromMap(itemMap));
      }
    }

    return items;
  }

  static Iterable<dynamic> _toIterable(dynamic val, List<String> nestedKeys) {
    if (val == null) return const [];
    if (val is Iterable && val is! String) return val;

    final map = toMap(val);
    if (map == null) return const [];

    for (final key in nestedKeys) {
      final nestedValue = map[key];
      if (nestedValue is Iterable && nestedValue is! String) {
        return nestedValue;
      }
    }

    return const [];
  }
}
