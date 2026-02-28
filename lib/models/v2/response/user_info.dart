import 'dart:convert';

/// 酷狗音乐用户信息 Model 类（仅 data 部分）
class UserInfo {
  /// 是否是VIP (1=是，0=否)
  final int isVip;

  /// 服务器当前时间
  final String serverTime;

  /// 漫游类型
  final int roamType;

  /// 加密会话凭证
  final String t1;

  /// 注册时间
  final String regTime;

  /// VIP类型（内部枚举值）
  final int vipType;

  /// 生日（月日，格式：0629）
  final String birthdayMmdd;

  /// 过期时间（旧字段）
  final String expireTime;

  /// 用户唯一ID
  final int userId;

  /// 收听权限结束时间
  final String listenEndTime;

  /// 超级VIP结束时间
  final String suVipEndTime;

  /// 年度超级VIP结束时间
  final String suVipYEndTime;

  /// 用户类型（账号类型）
  final int userType;

  /// 平台内部用户名
  final String userName;

  /// 是否绑定QQ (1=是，0=否)
  final int qq;

  /// 经验值
  final int exp;

  /// 付费音乐包结束时间
  final String mEndTime;

  /// 积分
  final int score;

  /// 听书会员是否有效 (1=是，0=否)
  final int bookVipValid;

  /// 听书会员结束时间
  final String bookVipEndTime;

  /// 虚拟形象头像
  final String arttoyAvatar;

  /// TOTP双因素认证服务器时间戳
  final int totpServerTimestamp;

  /// 漫游服务结束时间
  final String roamEndTime;

  /// 安全参数/签名
  final String secuParams;

  /// 超级VIP开始时间
  final String suVipBeginTime;

  /// TOTP双因素认证密钥
  final String totpKey;

  /// 漫游服务开始时间
  final String roamBeginTime;

  /// VIP结束时间
  final String vipEndTime;

  /// 性别 (1=男，2=女)
  final int sex;

  /// 收听类型/音质权限
  final int listenType;

  /// VIP专用校验令牌
  final String vipToken;

  /// 用户昵称
  final String nickname;

  /// 是否绑定手机 (1=是，0=否)
  final int mobile;

  /// 年度会员类型
  final int yType;

  /// 付费音乐包类型
  final int mType;

  /// 收听权限开始时间
  final String listenBeginTime;

  /// 邀请码/渠道码
  final String bcCode;

  /// 超级VIP清除天数
  final String suVipClearDay;

  /// 漫游列表（设备/歌单）
  final Map<String, dynamic> roamList;

  /// 用户年度会员类型
  final int userYType;

  /// 头像URL
  final String pic;

  /// 付费音乐包开始时间
  final String mBeginTime;

  /// 令牌过期时间戳
  final int tExpireTime;

  /// VIP开始时间
  final String vipBeginTime;

  /// 生日（完整格式：2006-06-29）
  final String birthday;

  /// 是否旧版付费包 (1=是，0=否)
  final int mIsOld;

  /// 是否绑定微信 (1=是，0=否)
  final int wechat;

  /// 登录态令牌
  final String token;

  /// 构造函数（带默认值，避免空值报错）
  UserInfo({
    required this.isVip,
    required this.serverTime,
    required this.roamType,
    required this.t1,
    required this.regTime,
    required this.vipType,
    required this.birthdayMmdd,
    required this.expireTime,
    required this.userId,
    required this.listenEndTime,
    required this.suVipEndTime,
    required this.suVipYEndTime,
    required this.userType,
    required this.userName,
    required this.qq,
    required this.exp,
    required this.mEndTime,
    required this.score,
    required this.bookVipValid,
    required this.bookVipEndTime,
    required this.arttoyAvatar,
    required this.totpServerTimestamp,
    required this.roamEndTime,
    required this.secuParams,
    required this.suVipBeginTime,
    required this.totpKey,
    required this.roamBeginTime,
    required this.vipEndTime,
    required this.sex,
    required this.listenType,
    required this.vipToken,
    required this.nickname,
    required this.mobile,
    required this.yType,
    required this.mType,
    required this.listenBeginTime,
    required this.bcCode,
    required this.suVipClearDay,
    required this.roamList,
    required this.userYType,
    required this.pic,
    required this.mBeginTime,
    required this.tExpireTime,
    required this.vipBeginTime,
    required this.birthday,
    required this.mIsOld,
    required this.wechat,
    required this.token,
  });

  /// 从JSON字符串解析为Model对象
  factory UserInfo.fromJson(String jsonStr) {
    return UserInfo.fromMap(json.decode(jsonStr));
  }

  /// 从Map解析为Model对象（核心方法）
  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      isVip: map['is_vip'] ?? 0,
      serverTime: map['servertime'] ?? '',
      roamType: map['roam_type'] ?? 0,
      t1: map['t1'] ?? '',
      regTime: map['reg_time'] ?? '',
      vipType: map['vip_type'] ?? 0,
      birthdayMmdd: map['birthday_mmdd'] ?? '',
      expireTime: map['expire_time'] ?? '',
      userId: map['userid'] ?? 0,
      listenEndTime: map['listen_end_time'] ?? '',
      suVipEndTime: map['su_vip_end_time'] ?? '',
      suVipYEndTime: map['su_vip_y_endtime'] ?? '',
      userType: map['user_type'] ?? 0,
      userName: map['username'] ?? '',
      qq: map['qq'] ?? 0,
      exp: map['exp'] ?? 0,
      mEndTime: map['m_end_time'] ?? '',
      score: map['score'] ?? 0,
      bookVipValid: map['bookvip_valid'] ?? 0,
      bookVipEndTime: map['bookvip_end_time'] ?? '',
      arttoyAvatar: map['arttoy_avatar'] ?? '',
      totpServerTimestamp: map['totp_server_timestamp'] ?? 0,
      roamEndTime: map['roam_end_time'] ?? '',
      secuParams: map['secu_params'] ?? '',
      suVipBeginTime: map['su_vip_begin_time'] ?? '',
      totpKey: map['totp_key'] ?? '',
      roamBeginTime: map['roam_begin_time'] ?? '',
      vipEndTime: map['vip_end_time'] ?? '',
      sex: map['sex'] ?? 0,
      listenType: map['listen_type'] ?? 0,
      vipToken: map['vip_token'] ?? '',
      nickname: map['nickname'] ?? '',
      mobile: map['mobile'] ?? 0,
      yType: map['y_type'] ?? 0,
      mType: map['m_type'] ?? 0,
      listenBeginTime: map['listen_begin_time'] ?? '',
      bcCode: map['bc_code'] ?? '',
      suVipClearDay: map['su_vip_clearday'] ?? '',
      roamList: map['roam_list'] ?? {},
      userYType: map['user_y_type'] ?? 0,
      pic: map['pic'] ?? '',
      mBeginTime: map['m_begin_time'] ?? '',
      tExpireTime: map['t_expire_time'] ?? 0,
      vipBeginTime: map['vip_begin_time'] ?? '',
      birthday: map['birthday'] ?? '',
      mIsOld: map['m_is_old'] ?? 0,
      wechat: map['wechat'] ?? 0,
      token: map['token'] ?? '',
    );
  }

  /// 将Model对象转为Map
  Map<String, dynamic> toMap() {
    return {
      'is_vip': isVip,
      'servertime': serverTime,
      'roam_type': roamType,
      't1': t1,
      'reg_time': regTime,
      'vip_type': vipType,
      'birthday_mmdd': birthdayMmdd,
      'expire_time': expireTime,
      'userid': userId,
      'listen_end_time': listenEndTime,
      'su_vip_end_time': suVipEndTime,
      'su_vip_y_endtime': suVipYEndTime,
      'user_type': userType,
      'username': userName,
      'qq': qq,
      'exp': exp,
      'm_end_time': mEndTime,
      'score': score,
      'bookvip_valid': bookVipValid,
      'bookvip_end_time': bookVipEndTime,
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
      'su_vip_clearday': suVipClearDay,
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

  /// 将Model对象转为JSON字符串
  String toJson() => json.encode(toMap());
}
