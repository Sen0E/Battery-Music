import 'dart:convert';
import 'dart:developer';

import 'package:battery_music/models/response/login_qr_check.dart';
import 'package:battery_music/models/response/register_dev.dart';
import 'package:battery_music/models/response/user_info.dart';
import 'package:kugou_music_api_dart/kugou_music_api_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 用户服务类
/// 负责管理用户登录状态和持久化UI所需的用户信息
class UserService {
  static final UserService _userService = UserService._internal();
  factory UserService() => _userService;

  static SharedPreferences? _prefs;

  static int userId = 0;
  static String nickname = '';
  static String avatarUrl = '';
  static int vipType = 0;
  static String vipBeginTime = ''; // 月会员结束时间(yyyy-mm-dd hh:mm:ss)
  static String vipEndTime = ''; // 月会员开始时间(yyyy-mm-dd hh:mm:ss)
  static String birthday = ''; // 生日(yyyy-mm-dd)
  static String dfid = '';
  static Map<String, String> cookies = {};

  static int get getUserId => userId;
  static String get getNickname => nickname;
  static String get getAvatarUrl => avatarUrl;
  static int get getVipType => vipType;
  static String get getVipBeginTime => vipBeginTime;
  static String get getVipEndTime => vipEndTime;
  static String get getBirthday => birthday;
  static String get getDfid => dfid;
  static Map<String, String> get getCookies => cookies;

  static bool get hasLogin => userId != 0 && cookies.isNotEmpty;

  UserService._internal();

  /// 异步初始化方法，必须在使用UserService前调用
  static Future<void> initialize(bool isLiteVersion) async {
    _prefs = await SharedPreferences.getInstance();
    userId = _prefs!.getInt('userId') ?? 0;
    nickname = _prefs!.getString('nickname') ?? '';
    avatarUrl = _prefs!.getString('avatarUrl') ?? '';
    vipType = _prefs!.getInt('vipType') ?? 0;
    vipBeginTime = _prefs!.getString('vipBeginTime') ?? '';
    vipEndTime = _prefs!.getString('vipEndTime') ?? '';
    birthday = _prefs!.getString('birthday') ?? '';
    dfid = _prefs!.getString('dfid') ?? '';

    final String cookieStr = _prefs!.getString('cookie') ?? '{}';
    cookies = Map<String, String>.from(jsonDecode(cookieStr));

    ApiClient().init(isLiteVersion: isLiteVersion, savedCookies: cookies);

    // 监听cookie并保存
    ApiClient().onCookieUpdated = (cookie) async {
      log('🍪 ApiClient 触发更新，正在保存新 Cookie...');
      log('Cookie: $cookie');
      await _prefs!.setString('cookie', jsonEncode(cookie));
    };
    // 显示所有信息
    log('用户信息:');
    log('userId: $userId');
    log('nickname: $nickname');
    log('avatarUrl: $avatarUrl');
    log('vipType: $vipType');
    log('vipBeginTime: $vipBeginTime');
    log('vipEndTime: $vipEndTime');
    log('birthday: $birthday');
    log('dfid: $dfid');
    log('Cookie:$cookies');
  }

  Future<void> saveUserInfo({
    UserInfo? userInfo,
    LoginQrCheck? loginQrCheck,
    RegisterDev? registerDev,
  }) async {
    if (userInfo != null) {
      userId = userInfo.userId;
      nickname = userInfo.nickname;
      avatarUrl = userInfo.pic;
      vipType = userInfo.vipType;
      vipBeginTime = userInfo.vipBeginTime;
      vipEndTime = userInfo.vipEndTime;
      birthday = userInfo.birthday;
      await _prefs!.setInt('userId', userId);
      await _prefs!.setString('nickname', nickname);
      await _prefs!.setString('avatarUrl', avatarUrl);
      await _prefs!.setInt('vipType', vipType);
      await _prefs!.setString('vipBeginTime', vipBeginTime);
      await _prefs!.setString('vipEndTime', vipEndTime);
      await _prefs!.setString('birthday', birthday);
    }
    if (loginQrCheck != null) {
      nickname = loginQrCheck.nickname!;
      avatarUrl = loginQrCheck.pic!;
      userId = loginQrCheck.userId!;
      await _prefs!.setString('nickname', nickname);
      await _prefs!.setString('avatarUrl', avatarUrl);
      await _prefs!.setInt('userId', userId);
    }
    if (registerDev != null) {
      dfid = registerDev.dfid;
      await _prefs!.setString('dfid', dfid);
      log("添加设备成功: $dfid");
    }
  }

  /// 退出登录
  Future<void> logOut() async {
    await _prefs!.remove('cookie');
    await _prefs!.remove('userId');
    await _prefs!.remove('nickname');
    await _prefs!.remove('avatarUrl');
    await _prefs!.remove('vipType');
    await _prefs!.remove('token');
    await _prefs!.remove('vipBeginTime');
    await _prefs!.remove('vipEndTime');
    await _prefs!.remove('birthday');
  }
}
