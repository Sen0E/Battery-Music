class LoginQrCheck {
  final int? status;

  // --- 授权成功时返回的用户信息 ---
  final String? nickname;
  final String? pic;
  final String? token;
  final int? userId;

  LoginQrCheck({this.status, this.nickname, this.pic, this.token, this.userId});

  factory LoginQrCheck.fromJson(Map<String, dynamic> json) {
    return LoginQrCheck(
      status: json['status'] as int?,
      nickname: json['nickname'] as String?,
      pic: json['pic'] as String?,
      token: json['token'] as String?,
      // 兼容可能为 String 或 int 的 userId
      userId: int.tryParse(json['userid']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'nickname': nickname,
    'pic': pic,
    'token': token,
    'userid': userId,
  };

  // --- 状态辅助判断方法 ---

  /// 二维码已过期
  bool get isExpired => status == 0;

  /// 等待扫码
  bool get isWaitingScan => status == 1;

  /// 待确认 (已扫码，等待手机端点击确认)
  bool get isWaitingConfirm => status == 2;

  /// 授权登录成功
  bool get isSuccess => status == 4;
}
