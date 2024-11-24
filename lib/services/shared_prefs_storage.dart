import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsStorage {
  final String token = "Token";
  final String refreshToken = "RefreshToken";
  final String tokenType = "TokenType";
  final String loginType = "LoginType";
  //Singleton
  static final SharedPrefsStorage _instance = SharedPrefsStorage._internal();

  SharedPrefsStorage._internal();

  factory SharedPrefsStorage() {
    return _instance;
  }
  //Singleton

  //Shared Prefs Init
  late SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }
  //Shared Prefs Init

  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  bool getBool(String key) {
    return _prefs.getBool(key) ?? false;
  }
}
