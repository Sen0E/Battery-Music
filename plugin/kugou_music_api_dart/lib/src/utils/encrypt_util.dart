import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:pointycastle/export.dart' as pc;

class EncryptUtil {
  static final Random _random = Random();

  // ==========================================
  // 常量与公钥
  // ==========================================
  static const String publicRasKey =
      '-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDIAG7QOELSYoIJvTFJhMpe1s/gbjDJX51HBNnEl5HXqTW6lQ7LC8jr9fWZTwusknp+sVGzwd40MwP6U5yDE27M/X1+UR4tvOGOqp94TJtQ1EPnWGWXngpeIW5GxoQGao1rmYWAu6oi1z9XkChrsUdC6DJE5E221wf/4WLFxwAtRQIDAQAB\n-----END PUBLIC KEY-----';

  static const String publicLiteRasKey =
      '-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDECi0Np2UR87scwrvTr72L6oO01rBbbBPriSDFPxr3Z5syug0O24QyQO8bg27+0+4kBzTBTBOZ/WWU0WryL1JSXRTXLgFVxtzIY41Pe7lPOgsfTCn5kZcvKhYKJesKnnJDNr5/abvTGf+rHG3YRwsCHcQ08/q6ifSioBszvb3QiwIDAQAB\n-----END PUBLIC KEY-----';

  static String randomString([int len = 16]) {
    const chars = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return String.fromCharCodes(
      Iterable.generate(
        len,
        (_) => chars.codeUnitAt(_random.nextInt(chars.length)),
      ),
    );
  }

  // ==========================================
  // Hash 算法 (MD5, SHA1)
  // ==========================================

  static String cryptoMd5(dynamic data) {
    final str = data is Map || data is List
        ? jsonEncode(data)
        : data.toString();
    return md5.convert(utf8.encode(str)).toString();
  }

  static String cryptoSha1(dynamic data) {
    final str = data is Map || data is List
        ? jsonEncode(data)
        : data.toString();
    return sha1.convert(utf8.encode(str)).toString();
  }

  // ==========================================
  // AES 加解密模块 (支持 Hex)
  // ==========================================

  /// 返回类型为 Map，包含 str (加密结果) 和 key (临时生成的密码)
  static Map<String, String> cryptoAesEncrypt(
    dynamic data, {
    String? key,
    String? iv,
  }) {
    final str = data is Map || data is List
        ? jsonEncode(data)
        : data.toString();

    String tempKey = '';
    String finalKey;
    String finalIv;

    if (key != null && iv != null) {
      finalKey = key;
      finalIv = iv;
    } else {
      tempKey = key ?? randomString(16).toLowerCase();
      finalKey = cryptoMd5(tempKey).substring(0, 32);
      finalIv = finalKey.substring(finalKey.length - 16);
    }

    final aesKey = enc.Key.fromUtf8(finalKey);
    final aesIv = enc.IV.fromUtf8(finalIv);
    final encrypter = enc.Encrypter(
      enc.AES(aesKey, mode: enc.AESMode.cbc, padding: 'PKCS7'),
    );

    final encrypted = encrypter.encrypt(str, iv: aesIv);

    // JS 返回的是 Hex 字符串
    final hexStr = _bytesToHex(encrypted.bytes);

    return {'str': hexStr, 'key': tempKey.isNotEmpty ? tempKey : finalKey};
  }

  static dynamic cryptoAesDecrypt(String dataHex, String key, [String? iv]) {
    String finalKey = key;
    String finalIv;

    if (iv == null || iv.isEmpty) {
      finalKey = cryptoMd5(key).substring(0, 32);
      finalIv = finalKey.substring(finalKey.length - 16);
    } else {
      finalIv = iv;
    }

    final aesKey = enc.Key.fromUtf8(finalKey);
    final aesIv = enc.IV.fromUtf8(finalIv);
    final encrypter = enc.Encrypter(
      enc.AES(aesKey, mode: enc.AESMode.cbc, padding: 'PKCS7'),
    );

    try {
      // 从 Hex 转换回 Encrypted 对象
      final encryptedBytes = _hexToBytes(dataHex);
      final decrypted = encrypter.decrypt(
        enc.Encrypted(encryptedBytes),
        iv: aesIv,
      );

      try {
        return jsonDecode(decrypted);
      } catch (_) {
        return decrypted;
      }
    } catch (e) {
      return '';
    }
  }

  // ==========================================
  // AES 加解密 (播放列表专用，支持 Base64)
  // ==========================================

  static Map<String, String> playlistAesEncrypt(dynamic data) {
    final str = data is Map || data is List
        ? jsonEncode(data)
        : data.toString();
    final tempKey = randomString(6).toLowerCase();
    final md5Key = cryptoMd5(tempKey);

    final finalKey = md5Key.substring(0, 16);
    final finalIv = md5Key.substring(16, 32);

    final aesKey = enc.Key.fromUtf8(finalKey);
    final aesIv = enc.IV.fromUtf8(finalIv);
    final encrypter = enc.Encrypter(
      enc.AES(aesKey, mode: enc.AESMode.cbc, padding: 'PKCS7'),
    );

    final encrypted = encrypter.encrypt(str, iv: aesIv);

    // 这里 JS 返回的是 Base64，不是 Hex
    return {'key': tempKey, 'str': encrypted.base64};
  }

  static dynamic playlistAesDecrypt(String base64Str, String key) {
    final md5Key = cryptoMd5(key);
    final finalKey = md5Key.substring(0, 16);
    final finalIv = md5Key.substring(16, 32);

    final aesKey = enc.Key.fromUtf8(finalKey);
    final aesIv = enc.IV.fromUtf8(finalIv);
    final encrypter = enc.Encrypter(
      enc.AES(aesKey, mode: enc.AESMode.cbc, padding: 'PKCS7'),
    );

    try {
      final decrypted = encrypter.decrypt64(base64Str, iv: aesIv);
      try {
        return jsonDecode(decrypted);
      } catch (_) {
        return decrypted;
      }
    } catch (e) {
      return '';
    }
  }

  // ==========================================
  // RSA 加密模块
  // ==========================================

  /// Raw RSA 加密 (无填充，直接 ModPow)
  static String cryptoRSAEncrypt(
    dynamic data, {
    bool isLite = false,
    String? customPublicKey,
  }) {
    final str = data is Map || data is List
        ? jsonEncode(data)
        : data.toString();
    Uint8List buffer = Uint8List.fromList(utf8.encode(str));

    final pem = customPublicKey ?? (isLite ? publicLiteRasKey : publicRasKey);
    final parser = enc.RSAKeyParser();
    final pc.RSAPublicKey publicKey = parser.parse(pem) as pc.RSAPublicKey;

    final keyLength = (publicKey.modulus!.bitLength + 7) ~/ 8;

    if (buffer.length > keyLength) {
      throw Exception('Data length exceeds key size');
    }

    // 对应 JS: buffer.concat([buffer, alloc(keyLength - buffer.length)]) -> 右侧补零
    if (buffer.length < keyLength) {
      final padded = Uint8List(keyLength);
      padded.setAll(0, buffer);
      buffer = padded;
    }

    // 将 byte 数组转为 16 进制字符串，再解析为大整数 BigInt
    final hexString = _bytesToHex(buffer);
    final message = BigInt.parse(hexString, radix: 16);

    // 核心：无填充原始 RSA 算法 message^e mod n
    final encrypted = message.modPow(publicKey.exponent!, publicKey.modulus!);

    return encrypted.toRadixString(16).padLeft(keyLength * 2, '0');
  }

  /// 标准 PKCS1_v1_5 RSA 加密
  static String rsaEncrypt2(dynamic data, {bool isLite = false}) {
    final str = data is Map || data is List
        ? jsonEncode(data)
        : data.toString();
    final pem = isLite ? publicLiteRasKey : publicRasKey;

    final parser = enc.RSAKeyParser();
    final publicKey = parser.parse(pem) as pc.RSAPublicKey;

    final encrypter = enc.Encrypter(
      enc.RSA(publicKey: publicKey, encoding: enc.RSAEncoding.PKCS1),
    );
    final encrypted = encrypter.encrypt(str);

    return _bytesToHex(encrypted.bytes);
  }

  // ==========================================
  // 辅助工具方法
  // ==========================================

  static String _bytesToHex(List<int> bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join('');
  }

  static Uint8List _hexToBytes(String hex) {
    final bytes = <int>[];
    for (int i = 0; i < hex.length; i += 2) {
      bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return Uint8List.fromList(bytes);
  }
}
