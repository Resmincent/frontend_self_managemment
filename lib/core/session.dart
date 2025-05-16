import 'package:d_session/d_session.dart';
import 'package:self_management/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static const _keyLoginTime = 'login_time';

  static Future<bool> saveUser(Map<String, dynamic> data) async {
    await DSession.setUser(data);
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt(_keyLoginTime, now);
    return true;
  }

  static Future<UserModel?> getUser() async {
    final data = await DSession.getUser();
    if (data == null) return null;
    return UserModel.fromJson(data);
  }

  static Future<bool> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoginTime);
    await DSession.removeUser();
    return true;
  }

  static Future<bool> isSessionExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final loginTime = prefs.getInt(_keyLoginTime);
    if (loginTime == null) return true;

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final diff = currentTime - loginTime;
    const sessionDuration = 3 * 60 * 60 * 1000; // 3 jam dalam milidetik

    return diff > sessionDuration;
  }
}
