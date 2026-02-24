class LoginResponse {
  final int? isVip;
  final String? servertime;
  final int? roamType;
  final String? t1;
  final String? regTime;
  final int? vipType;
  final String? birthdayMmdd;
  final int? userid;
  final String? listenEndTime;
  final String? suVipEndTime;
  final String? suVipYEndtime;
  final int? userType;
  final String? username;
  final int? qq;
  final int? exp;
  final String? mEndTime;
  final int? score;
  final int? bookvipValid;
  final String? bookvipEndTime;
  final String? arttoyAvatar;
  final int? totpServerTimestamp;
  final String? roamEndTime;
  final String? secuParams;
  final String? suVipBeginTime;
  final String? totpKey;
  final String? roamBeginTime;
  final String? vipEndTime;
  final int? sex;
  final int? listenType;
  final String? vipToken;
  final String? nickname;
  final int? mobile;
  final int? yType;
  final int? mType;
  final String? listenBeginTime;
  final String? bcCode;
  final String? suVipClearday;
  final Map<String, dynamic>? roamList; // JSON中是 {}，对应 Map
  final int? userYType;
  final String? pic;
  final String? mBeginTime;
  final int? tExpireTime;
  final String? vipBeginTime;
  final String? birthday;
  final int? mIsOld;
  final int? wechat;
  final String? token;

  LoginResponse({
    this.isVip,
    this.servertime,
    this.roamType,
    this.t1,
    this.regTime,
    this.vipType,
    this.birthdayMmdd,
    this.userid,
    this.listenEndTime,
    this.suVipEndTime,
    this.suVipYEndtime,
    this.userType,
    this.username,
    this.qq,
    this.exp,
    this.mEndTime,
    this.score,
    this.bookvipValid,
    this.bookvipEndTime,
    this.arttoyAvatar,
    this.totpServerTimestamp,
    this.roamEndTime,
    this.secuParams,
    this.suVipBeginTime,
    this.totpKey,
    this.roamBeginTime,
    this.vipEndTime,
    this.sex,
    this.listenType,
    this.vipToken,
    this.nickname,
    this.mobile,
    this.yType,
    this.mType,
    this.listenBeginTime,
    this.bcCode,
    this.suVipClearday,
    this.roamList,
    this.userYType,
    this.pic,
    this.mBeginTime,
    this.tExpireTime,
    this.vipBeginTime,
    this.birthday,
    this.mIsOld,
    this.wechat,
    this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      isVip: json['is_vip'],
      servertime: json['servertime'],
      roamType: json['roam_type'],
      t1: json['t1'],
      regTime: json['reg_time'],
      vipType: json['vip_type'],
      birthdayMmdd: json['birthday_mmdd'],
      userid: json['userid'],
      listenEndTime: json['listen_end_time'],
      suVipEndTime: json['su_vip_end_time'],
      suVipYEndtime: json['su_vip_y_endtime'],
      userType: json['user_type'],
      username: json['username'],
      qq: json['qq'],
      exp: json['exp'],
      mEndTime: json['m_end_time'],
      score: json['score'],
      bookvipValid: json['bookvip_valid'],
      bookvipEndTime: json['bookvip_end_time'],
      arttoyAvatar: json['arttoy_avatar'],
      totpServerTimestamp: json['totp_server_timestamp'],
      roamEndTime: json['roam_end_time'],
      secuParams: json['secu_params'],
      suVipBeginTime: json['su_vip_begin_time'],
      totpKey: json['totp_key'],
      roamBeginTime: json['roam_begin_time'],
      vipEndTime: json['vip_end_time'],
      sex: json['sex'],
      listenType: json['listen_type'],
      vipToken: json['vip_token'],
      nickname: json['nickname'],
      mobile: json['mobile'],
      yType: json['y_type'],
      mType: json['m_type'],
      listenBeginTime: json['listen_begin_time'],
      bcCode: json['bc_code'],
      suVipClearday: json['su_vip_clearday'],
      roamList: json['roam_list'] != null
          ? Map<String, dynamic>.from(json['roam_list'])
          : null,
      userYType: json['user_y_type'],
      pic: json['pic'],
      mBeginTime: json['m_begin_time'],
      tExpireTime: json['t_expire_time'],
      vipBeginTime: json['vip_begin_time'],
      birthday: json['birthday'],
      mIsOld: json['m_is_old'],
      wechat: json['wechat'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_vip': isVip,
      'servertime': servertime,
      'roam_type': roamType,
      't1': t1,
      'reg_time': regTime,
      'vip_type': vipType,
      'birthday_mmdd': birthdayMmdd,
      'userid': userid,
      'listen_end_time': listenEndTime,
      'su_vip_end_time': suVipEndTime,
      'su_vip_y_endtime': suVipYEndtime,
      'user_type': userType,
      'username': username,
      'qq': qq,
      'exp': exp,
      'm_end_time': mEndTime,
      'score': score,
      'bookvip_valid': bookvipValid,
      'bookvip_end_time': bookvipEndTime,
      'arttoy_avatar': arttoyAvatar,
      'totp_server_timestamp': totpServerTimestamp,
      'roam_end_time': roamEndTime,
      'secu_params': secuParams,
      'su_vip_begin_time': suVipBeginTime,
      'totp_key': totpKey,
      'roam_begin_time': roamBeginTime,
      'vip_end_time': vipEndTime,
      'sex': sex,
      'listen_type': listenType,
      'vip_token': vipToken,
      'nickname': nickname,
      'mobile': mobile,
      'y_type': yType,
      'm_type': mType,
      'listen_begin_time': listenBeginTime,
      'bc_code': bcCode,
      'su_vip_clearday': suVipClearday,
      'roam_list': roamList,
      'user_y_type': userYType,
      'pic': pic,
      'm_begin_time': mBeginTime,
      't_expire_time': tExpireTime,
      'vip_begin_time': vipBeginTime,
      'birthday': birthday,
      'm_is_old': mIsOld,
      'wechat': wechat,
      'token': token,
    };
  }
}
