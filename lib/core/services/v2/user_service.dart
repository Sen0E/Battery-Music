import 'package:battery_music/core/services/node_api_client.dart';
import 'package:battery_music/models/v2/response/register_dev.dart';
import 'package:battery_music/models/v2/response/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 用户服务类
/// 负责管理用户登录状态和持久化UI所需的用户信息
class UserService {
  static final UserService _userService = UserService._internal();
  factory UserService() => _userService;

  late SharedPreferences _prefs;
  NodeApiClient _nodeApiClient = NodeApiClient();

  static int userId = 0;
  static String nickname = '';
  static String avatarUrl = '';
  static int vipType = 0;
  static String token = '';
  static String vipBeginTime = ''; // 月会员结束时间(yyyy-mm-dd hh:mm:ss)
  static String vipEndTime = ''; // 月会员开始时间(yyyy-mm-dd hh:mm:ss)
  static String birthday = ''; // 生日(yyyy-mm-dd)
  static String dfid = '';

  static int get getUserId => userId;
  static String get getNickname => nickname;
  static String get getAvatarUrl => avatarUrl;
  static int get getVipType => vipType;
  static String get getToken => token;
  static String get getVipBeginTime => vipBeginTime;
  static String get getVipEndTime => vipEndTime;
  static String get getBirthday => birthday;
  static String get getDfid => dfid;

  static bool get hasLogin => userId != '' && token != '';

  UserService._internal() {
    _initUserService();
  }

  Future<void> _initUserService() async {
    _prefs = await SharedPreferences.getInstance();
    userId = _prefs.getInt('userId') ?? 0;
    nickname = _prefs.getString('nickname') ?? '';
    avatarUrl = _prefs.getString('avatarUrl') ?? '';
    vipType = _prefs.getInt('vipType') ?? 0;
    token = _prefs.getString('token') ?? '';
    vipBeginTime = _prefs.getString('vipBeginTime') ?? '';
    vipEndTime = _prefs.getString('vipEndTime') ?? '';
    birthday = _prefs.getString('birthday') ?? '';
    dfid = _prefs.getString('dfid') ?? '';
  }

  Future<void> saveUserInfo({UserInfo? user, RegisterDev? registerDev}) async {
    if (user != null) {
      userId = user.userId;
      nickname = user.nickname;
      avatarUrl = user.pic;
      vipType = user.vipType;
      token = user.token;
      vipBeginTime = user.vipBeginTime;
      vipEndTime = user.vipEndTime;
      birthday = user.birthday;
      await _prefs.setInt('userId', userId);
      await _prefs.setString('nickname', nickname);
      await _prefs.setString('avatarUrl', avatarUrl);
      await _prefs.setInt('vipType', vipType);
      await _prefs.setString('token', token);
      await _prefs.setString('vipBeginTime', vipBeginTime);
      await _prefs.setString('vipEndTime', vipEndTime);
      await _prefs.setString('birthday', birthday);
    }
    if (registerDev != null) {
      dfid = registerDev.dfid;
      await _prefs.setString('dfid', dfid);
    }
  }

  /// 退出登录
  Future<void> logOut() async {
    await _nodeApiClient.clearCookies();
    await _prefs.remove('userId');
    await _prefs.remove('nickname');
    await _prefs.remove('avatarUrl');
    await _prefs.remove('vipType');
    await _prefs.remove('token');
    await _prefs.remove('vipBeginTime');
    await _prefs.remove('vipEndTime');
    await _prefs.remove('birthday');
  }
}
