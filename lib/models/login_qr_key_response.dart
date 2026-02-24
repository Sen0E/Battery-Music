import 'dart:convert';
import 'dart:typed_data';

class LoginQrKey {
  final String? qrcode;
  final String? qrcodeImg;

  LoginQrKey({this.qrcode, this.qrcodeImg});

  factory LoginQrKey.fromJson(Map<String, dynamic> json) {
    return LoginQrKey(
      qrcode: json['qrcode'] as String?,
      qrcodeImg: json['qrcode_img'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'qrcode': qrcode, 'qrcode_img': qrcodeImg};

  /// 辅助方法：将带有前缀的 base64 字符串转换为 Flutter 可用的字节数组
  /// 用于在 UI 中直接使用 Image.memory() 进行渲染
  Uint8List? get imageBytes {
    if (qrcodeImg == null || qrcodeImg!.isEmpty) return null;

    // 分离 "data:image/png;base64," 前缀和实际的 base64 内容
    final parts = qrcodeImg!.split(',');
    if (parts.length == 2) {
      // 解码实际的 base64 字符串
      return base64Decode(parts[1]);
    }
    return null;
  }
}
