import 'package:shared_preferences/shared_preferences.dart';

class UserLogin {
  bool? status;
  String? username;

  UserLogin({this.status, this.username});

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('status', status ?? false);
    await prefs.setString('username', username ?? '');
    print('[UserLogin] Disimpan: status=$status, username=$username');
  }

  Future<void> clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('[UserLogin] Data dihapus dari SharedPreferences');
  }

  static Future<UserLogin> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    var user = UserLogin(
      status: prefs.getBool('status') ?? false,
      username: prefs.getString('username') ?? '',
    );
    print('[UserLogin] Diambil: status=${user.status}, username=${user.username}');
    return user;
  }
}
