import 'package:TravelBalance/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsStorage {
  final String token = "Token";
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

  void saveAuthentication(Authentication newAuthentication) async {
    await _prefs.setString(token, newAuthentication.token);
    await _prefs.setString(tokenType, newAuthentication.tokenType.name);
    await _prefs.setString(loginType, newAuthentication.loginType.name);
  }

  void resetAuthentication() async {
    await _prefs.remove(token);
    await _prefs.remove(tokenType);
    await _prefs.remove(loginType);
  }

  Future<Authentication?> getAuthentication() async {
    final String? l_token = await _prefs.getString(token);
    final String? l_tokenType = await _prefs.getString(tokenType);
    final String? l_loginType = await _prefs.getString(loginType);

    if (l_tokenType == null || l_token == null || l_loginType == null)
      return null;

    return Authentication(
        l_token,
        null,
        ApiService().getBaseTokenTypeFromString(l_tokenType),
        ApiService().getLoginTypeFromString(l_loginType));
  }
}
