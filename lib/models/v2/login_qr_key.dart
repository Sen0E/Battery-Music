import 'dart:convert';
import 'dart:typed_data';

class LoginQrKey {
  final String? qrcode;
  final String? qrcodeImg;
  const LoginQrKey({required this.qrcode, required this.qrcodeImg});

  factory LoginQrKey.fromMap(Map<String, dynamic> map) {
    return LoginQrKey(qrcode: map['qrcode'], qrcodeImg: map['qrcode_img']);
  }
  factory LoginQrKey.fromJson(String str) =>
      LoginQrKey.fromMap(json.decode(str));

  Map toMap() {
    return {'qrcode': qrcode, 'qrcode_img': qrcodeImg};
  }

  String toJson() => json.encode(toMap());

  Uint8List? get qrImage {
    final parts = qrcodeImg?.split(',');
    return base64Decode(parts?[1] ?? '');
  }
}
