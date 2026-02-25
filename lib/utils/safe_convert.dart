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
}
