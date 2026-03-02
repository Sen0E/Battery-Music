import 'dart:convert';

class LoginQrCheck {
  final int? status;

  final String? nickname;
  final String? pic;
  final String? token;
  final int? userId;
  LoginQrCheck({
    required this.status,
    required this.nickname,
    required this.pic,
    required this.token,
    required this.userId,
  });
  factory LoginQrCheck.fromMap(Map<String, dynamic> json) {
    return LoginQrCheck(
      status: json['status'],

      /// 0： 已过期 1: 等待扫码 2: 待确认 4: 授权登录成功
      nickname: json['nickname'],
      pic: json['pic'],
      token: json['token'],
      userId: json['userId'],
    );
  }
  factory LoginQrCheck.fromJson(String str) =>
      LoginQrCheck.fromMap(json.decode(str));

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'nickname': nickname,
      'pic': pic,
      'token': token,
      'userId': userId,
    };
  }

  String toJson() => json.encode(toMap());

  bool get isExpired => status == 0;
  bool get isWaitingScan => status == 1;
  bool get isWaitingConfirm => status == 2;
  bool get isSuccess => status == 4;
}
