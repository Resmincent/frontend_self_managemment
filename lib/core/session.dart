import 'package:d_session/d_session.dart';
import 'package:self_management/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static const _keyLoginTime = 'login_time';
  static const _keyUserPin = 'user_pin';

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
    await prefs.remove(_keyUserPin);
    await DSession.removeUser();
    return true;
  }

  static Future<void> saveUserPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserPin, pin);
  }

  static Future<String?> getUserPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserPin);
  }

  static Future<bool> verifyPin(String inputPin) async {
    final storedPin = await getUserPin();
    return storedPin == inputPin;
  }

  static Future<bool> isSessionExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final loginTime = prefs.getInt(_keyLoginTime);
    if (loginTime == null) return true;

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final diff = currentTime - loginTime;
    const sessionDuration = 168 * 60 * 60 * 1000; // 7 hari dalam milidetik

    return diff > sessionDuration;
  }
}
