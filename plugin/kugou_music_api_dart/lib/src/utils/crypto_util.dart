import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:archive/archive.dart';

class CryptoUtil {
  static final Random _random = Random();

  /// 随机字符串 (对应 randomString)
  static String randomString([int len = 16]) {
    const chars = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return String.fromCharCodes(
      Iterable.generate(
        len,
        (_) => chars.codeUnitAt(_random.nextInt(chars.length)),
      ),
    );
  }

  /// 随机数字 (对应 randomNumber)
  static String randomNumber([int len = 16]) {
    const chars = '1234567890';
    return String.fromCharCodes(
      Iterable.generate(
        len,
        (_) => chars.codeUnitAt(_random.nextInt(chars.length)),
      ),
    );
  }

  /// 格式化 cookie (对应 parseCookieString)
  static String parseCookieString(String cookie) {
    // 移除 Domain, path, expires 等属性
    String t = cookie.replaceAll(
      RegExp(r'\s*(Domain|domain|path|expires)=[^(;|$)]+;*'),
      '',
    );
    return t.replaceAll(';HttpOnly', '');
  }

  /// cookie 转 json (对应 cookieToJson)
  static Map<String, String> cookieToJson(String? cookie) {
    if (cookie == null || cookie.isEmpty) return {};
    final cookieArr = cookie.split(';');
    final Map<String, String> obj = {};
    for (var i in cookieArr) {
      if (i.trim().isEmpty) continue;
      final arr = i.split('=');
      if (arr.length >= 2) {
        obj[arr[0].trim()] = arr.sublist(1).join('=').trim();
      }
    }
    return obj;
  }

  /// KRC 歌词解码 (对应 decodeLyrics)
  /// 完美翻译了 XOR 解密 + Pako (Zlib) 解压的过程
  static String decodeLyrics(dynamic val) {
    Uint8List? bytes;

    // 兼容多种入参类型
    if (val is Uint8List) {
      bytes = val;
    } else if (val is List<int>) {
      bytes = Uint8List.fromList(val);
    } else if (val is String) {
      try {
        bytes = base64Decode(val);
      } catch (_) {
        return '';
      }
    }

    if (bytes == null || bytes.length <= 4) return '';

    // 固定的 XOR 密钥
    const enKey = [
      64,
      71,
      97,
      119,
      94,
      50,
      116,
      71,
      81,
      54,
      49,
      45,
      206,
      210,
      110,
      105,
    ];

    // 截取前 4 个字节后的实际数据
    final krcBytes = bytes.sublist(4);

    // 逐字节进行异或运算
    for (int i = 0; i < krcBytes.length; i++) {
      krcBytes[i] = krcBytes[i] ^ enKey[i % enKey.length];
    }

    try {
      // 对应 pako.inflate：解压 zlib 数据流
      final inflated = ZLibDecoder().decodeBytes(krcBytes);
      return utf8.decode(inflated);
    } catch (e) {
      return '';
    }
  }

  /// 计算 MID (对应 calculateMid)
  /// 降维打击：Dart 的 BigInt 原生支持直接解析 16 进制字符串，
  /// 所以 JS 里那一堆算次方的复杂循环，在 Dart 里只需要两句话！
  static String calculateMid(String str) {
    // 1. 计算 MD5 获取 32 位 Hex 字符串
    final digest = md5.convert(utf8.encode(str)).toString();

    // 2. 将 16 进制的 MD5 字符串当做超大整数解析，并转为 10 进制字符串
    final bigIntVal = BigInt.parse(digest, radix: 16);
    return bigIntVal.toString();
  }

  /// 生成伪 GUID (对应 getGuid)
  static String getGuid() {
    String e() {
      // 生成 4 位 16 进制字符串并补齐前导 0
      return _random.nextInt(65536).toRadixString(16).padLeft(4, '0');
    }

    return '${e()}${e()}-${e()}-${e()}-${e()}-${e()}${e()}${e()}';
  }
}
