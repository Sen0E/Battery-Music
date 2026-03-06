import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:kugou_music_api_dart/src/utils/config.dart';
import '../core/api_client.dart';
import '../utils/encrypt_util.dart';
import '../utils/helper_util.dart';

class Device {
  static String get _token => ApiClient().currentCookies['token'] ?? '';
  static int get _userid =>
      int.tryParse(ApiClient().currentCookies['userid'] ?? '0') ?? 0;
  static String get _guid => ApiClient().currentCookies['KUGOU_API_GUID'] ?? '';

  /// 注册设备硬件信息，换取核心风控凭证 (dfid)
  /// 这些参数默认伪装成了一台运行正常的红米 (Redmi) 手机
  static Future<Map<String, dynamic>> registerDev({
    int availableRamSize = 4983533568,
    int availableRomSize = 48114719,
    int availableSDSize = 48114717,
    String basebandVer = '',
    int batteryLevel = 100,
    int batteryStatus = 3,
    String brand = 'Redmi',
    String buildSerial = 'unknown',
    String device = 'marble',
    String? imei,
    String imsi = '',
    String manufacturer = 'Xiaomi',
    String? uuid,
    bool accelerometer = false,
    String accelerometerValue = '',
    bool gravity = false,
    String gravityValue = '',
    bool gyroscope = false,
    String gyroscopeValue = '',
    bool light = false,
    String lightValue = '',
    bool magnetic = false,
    String magneticValue = '',
    bool orientation = false,
    String orientationValue = '',
    bool pressure = false,
    String pressureValue = '',
    bool stepCounter = false,
    String stepCounterValue = '',
    bool temperature = false,
    String temperatureValue = '',
  }) async {
    // 组装极其详细的硬件探针数据
    final Map<String, dynamic> dataMap = {
      'availableRamSize': availableRamSize,
      'availableRomSize': availableRomSize,
      'availableSDSize': availableSDSize,
      'basebandVer': basebandVer,
      'batteryLevel': batteryLevel,
      'batteryStatus': batteryStatus,
      'brand': brand,
      'buildSerial': buildSerial,
      'device': device,
      'imei': imei ?? _guid, // 默认借用 GUID 充当 IMEI
      'imsi': imsi,
      'manufacturer': manufacturer,
      'uuid': uuid ?? _guid,
      'accelerometer': accelerometer,
      'accelerometerValue': accelerometerValue,
      'gravity': gravity,
      'gravityValue': gravityValue,
      'gyroscope': gyroscope,
      'gyroscopeValue': gyroscopeValue,
      'light': light,
      'lightValue': lightValue,
      'magnetic': magnetic,
      'magneticValue': magneticValue,
      'orientation': orientation,
      'orientationValue': orientationValue,
      'pressure': pressure,
      'pressureValue': pressureValue,
      'step_counter': stepCounter,
      'step_counterValue': stepCounterValue,
      'temperature': temperature,
      'temperatureValue': temperatureValue,
    };

    // 核心：使用播放列表级别的 AES 加密业务数据
    final Map<String, String> aesEncrypt = EncryptUtil.playlistAesEncrypt(
      dataMap,
    );

    // 使用标准 PKCS1_v1_5 RSA 加密包含动态 AES Key 的防伪信息
    final String p = EncryptUtil.rsaEncrypt2({
      'aes': aesEncrypt['key'],
      'uid': _userid,
      'token': _token,
    }); // ⚠️ 注意：原 JS 这里没有 .toUpperCase()
    try {
      final dio = Dio();
      final int clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final String cookieStr = ApiClient().currentCookies.entries
          .map((e) => '${e.key}=${e.value}')
          .join('; ');

      // 1. 手动拼装底层缺失的公共查询参数
      final Map<String, dynamic> queryParams = {
        'part': 1,
        'platid': 1,
        'p': p,
        'dfid': ApiClient().currentCookies['dfid'] ?? '-',
        'mid': ApiClient().currentCookies['KUGOU_API_MID'] ?? '-',
        'uuid': '-',
        'appid': ApiClient().isLite ? Config.liteAppid : Config.appid,
        'clientver': ApiClient().isLite
            ? Config.liteClientver
            : Config.clientver,
        'clienttime': clienttime,
      };

      // 2. ⚡️ 手动调用工具类生成安卓防伪签名 (连同加密的 body 字符串一起签名)
      queryParams['signature'] = HelperUtil.signatureAndroidParams(
        queryParams,
        data: aesEncrypt['str'] ?? '',
        isLite: ApiClient().isLite,
      );

      // 3. 发送补全后的合法请求
      final response = await dio.post(
        'https://userservice.kugou.com/risk/v2/r_register_dev',
        queryParameters: queryParams,
        data: aesEncrypt['str'],
        options: Options(
          headers: {
            'Cookie': cookieStr,
            'User-Agent':
                'Android15-1070-11083-46-0-DiscoveryDRADProtocol-wifi',
            'dfid': queryParams['dfid'],
            'clienttime': clienttime,
            'mid': queryParams['mid'],
          },
          // ⚠️ 接收强加密的二进制流
          responseType: ResponseType.bytes,
        ),
      );

      // 4. 将二进制流转为 Base64 并解密
      final List<int> responseBytes = response.data as List<int>;
      final String base64Resp = base64Encode(responseBytes);
      final dynamic decryptedBody = EncryptUtil.playlistAesDecrypt(
        base64Resp,
        aesEncrypt['key']!,
      );

      // ✨ 灵魂注入：拦截 dfid 并更新到全局引擎
      if (decryptedBody is Map &&
          decryptedBody['status'] == 1 &&
          decryptedBody['data'] != null) {
        final String? newDfid = decryptedBody['data']['dfid'];

        if (newDfid != null && newDfid.isNotEmpty) {
          // 只需调用 updateCookies，底层单例会自动触发 UserService 落盘，极度优雅！
          ApiClient().updateCookies({'dfid': newDfid});
          print('🛡️ 成功突破风控！获取并注入设备硬件指纹 dfid: $newDfid');
        }
      }

      return {'status': 200, 'body': decryptedBody};
    } catch (e) {
      return {
        'status': 502,
        'body': {'status': 0, 'msg': e.toString()},
      };
    }
  }
}
