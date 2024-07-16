import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static const tokenKey = 'TOKEN';

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(tokenKey) != null;
  }

  //login
  Future<String> get token async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(tokenKey) ?? '';
  }

  Future<bool> setToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(tokenKey, token);
    return true;
  }

  Future<bool> logout() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove(tokenKey);
    return true;
  }
}
