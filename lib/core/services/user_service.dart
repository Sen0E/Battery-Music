import 'package:battery_music/core/services/node_api_client.dart';
import 'package:battery_music/models/user_detial_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 用户服务类
/// 负责管理用户登录状态和持久化UI所需的用户信息
class UserService {
  static final UserService instance = UserService._();
  factory UserService() => instance;
  UserService._();

  // SharedPreferences keys
  static const String _kUserId = 'user_id'; // 使用 'iden' 字段
  static const String _kNickname = 'nickname';
  static const String _kAvatar = 'avatar_pic'; // 存储 'pic' 字段
  static const String _kVipType = 'vip_type';
  static const String _kSvipLevel = 'svip_level';
  static const String _kSvipEndTime = 'svip_end_time';

  /// 保存用户信息 (基于 UserDetial 模型)
  /// 仅存储UI展示所需的关键信息
  Future<void> saveUserInfo(UserDetial user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kUserId, user.iden ?? 0);
    await prefs.setString(_kNickname, user.nickname ?? '');
    await prefs.setString(_kAvatar, user.pic ?? ''); // 存储头像URL模板
    await prefs.setInt(_kVipType, user.vipType ?? 0);
    await prefs.setInt(_kSvipLevel, user.svipLevel ?? 0);
    await prefs.setString(_kSvipEndTime, user.suVipEndTime ?? '');
  }

  /// 检查用户是否已登录
  /// 通过检查是否存在用户ID来判断
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    // 如果 userId 存在且不为0，则视为已登录
    return prefs.containsKey(_kUserId) && (prefs.getInt(_kUserId) ?? 0) != 0;
  }

  /// 退出登录
  /// 清除所有本地用户信息和网络请求的 Cookies
  Future<void> logout() async {
    // 1. 清除网络 Cookies
    await NodeApiClient.instance.clearCookies();

    // 2. 清除 SharedPreferences 中的用户信息
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kUserId);
    await prefs.remove(_kNickname);
    await prefs.remove(_kAvatar);
    await prefs.remove(_kVipType);
    await prefs.remove(_kSvipLevel);
    await prefs.remove(_kSvipEndTime);
  }

  // --- Getters for UI ---

  /// 获取用户ID
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kUserId);
  }

  /// 获取用户昵称
  Future<String?> getNickname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kNickname);
  }

  /// 获取用户头像URL
  /// [size] - 期望的图片尺寸
  Future<String> getAvatarUrl({int size = 200}) async {
    final prefs = await SharedPreferences.getInstance();
    final picTemplate = prefs.getString(_kAvatar);
    if (picTemplate == null || picTemplate.isEmpty) {
      // 可以返回一个默认头像URL
      return '';
    }
    return picTemplate.replaceAll('{size}', size.toString());
  }

  /// 获取VIP类型
  Future<int> getVipType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kVipType) ?? 0;
  }

  /// 获取超级VIP等级
  Future<int> getSvipLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kSvipLevel) ?? 0;
  }

  /// 判断是否是VIP（普通或超级）
  Future<bool> isVip() async {
    final vipType = await getVipType();
    final svipLevel = await getSvipLevel();
    return vipType > 0 || svipLevel > 0;
  }

  /// 获取VIP到期时间
  Future<String?> getVipEndTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kSvipEndTime);
  }
}
