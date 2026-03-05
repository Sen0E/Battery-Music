import 'dart:convert';
import 'encrypt_util.dart'; // 引入上一回合写好的加密工具
import 'config.dart';

/// 对应 config.json 的配置参数
/// 这里我根据你之前代码里的 User-Agent 补充了默认值，如果有真实配置可以替换

class HelperUtil {
  /// web版本 signature 加密
  /// JS逻辑: 先拼接成 key=value 数组，再对数组进行字典排序，最后拼接
  static String signatureWebParams(Map<String, dynamic> params) {
    const String str = 'NVPh5oo715z5DIWAeQlhMDsWXXQV4hwt';

    // 把参数转为 key=value 的字符串列表
    final List<String> list = params.entries
        .map((e) => '${e.key}=${e.value}')
        .toList();

    // 排序
    list.sort();

    final String paramsString = list.join('');
    return EncryptUtil.cryptoMd5('$str$paramsString$str');
  }

  /// Android版本 signature 加密
  /// JS逻辑: 先对 keys 排序，然后按顺序拼接 key=value(对象转json)
  static String signatureAndroidParams(
    Map<String, dynamic> params, {
    String? data,
    bool isLite = false,
  }) {
    final String str = isLite
        ? 'LnT6xpN3khm36zse0QzvmgTZ3waWdRSA'
        : 'OIlwieks28dk2k092lksi2UIkp';

    // 获取所有的 key 并按字典序排序
    final List<String> keys = params.keys.toList()..sort();

    final String paramsString = keys
        .map((key) {
          final value = params[key];
          // 如果 value 是 Map 或 List，使用 jsonEncode 转换为字符串
          final String valStr = (value is Map || value is List)
              ? jsonEncode(value)
              : value.toString();
          return '$key=$valStr';
        })
        .join('');

    return EncryptUtil.cryptoMd5('$str$paramsString${data ?? ''}$str');
  }

  /// Register版本 signature 加密
  /// JS逻辑: 取出所有的 value，对 value 数组进行排序，再拼接
  static String signatureRegisterParams(Map<String, dynamic> params) {
    final List<String> values = params.values.map((v) => v.toString()).toList();

    // 对 values 进行排序
    values.sort();

    final String paramsString = values.join('');
    return EncryptUtil.cryptoMd5('1014${paramsString}1014');
  }

  /// sign 加密
  /// JS逻辑: 先对 key 排序，然后拼接 key 和 value (中间没有等号)
  static String signParams(Map<String, dynamic> params, {String? data}) {
    const String str = 'R6snCXJgbCaj9WFRJKefTMIFp0ey6Gza';

    final List<String> keys = params.keys.toList()..sort();

    final String paramsString = keys
        .map((key) => '$key${params[key]}')
        .join('');

    return EncryptUtil.cryptoMd5('$paramsString${data ?? ''}$str');
  }

  /// signKey 加密
  static String signKey(
    String hash,
    String mid, {
    dynamic userid,
    dynamic appid,
    bool isLite = false,
  }) {
    final String str = isLite
        ? '185672dd44712f60bb1736df5a377e82'
        : '57ae12eb6890223e355ccfcb74edf70d';
    // 使用真实的 KugouConfig.liteAppid 和 KugouConfig.appid
    final String finalAppid =
        (appid ?? (isLite ? KugouConfig.liteAppid : KugouConfig.appid))
            .toString();
    final String finalUserid = (userid ?? 0).toString();

    return EncryptUtil.cryptoMd5('$hash$str$finalAppid$mid$finalUserid');
  }

  /// signCloudKey 加密云盘key
  static String signCloudKey(String hash, String pid) {
    const String str = 'ebd1ac3134c880bda6a2194537843caa0162e2e7';
    return EncryptUtil.cryptoMd5('musicclound$hash$pid$str');
  }

  /// signParamsKey 加密
  static String signParamsKey(
    dynamic data, {
    dynamic appid,
    dynamic clientver,
    bool isLite = false,
  }) {
    final String str = isLite
        ? 'LnT6xpN3khm36zse0QzvmgTZ3waWdRSA'
        : 'OIlwieks28dk2k092lksi2UIkp';

    final String finalAppid =
        (appid ?? (isLite ? KugouConfig.liteAppid : KugouConfig.appid))
            .toString();
    final String finalClientver =
        (clientver ??
                (isLite ? KugouConfig.liteClientver : KugouConfig.clientver))
            .toString();

    return EncryptUtil.cryptoMd5(
      '$finalAppid$str$finalClientver${data.toString()}',
    );
  }
}
