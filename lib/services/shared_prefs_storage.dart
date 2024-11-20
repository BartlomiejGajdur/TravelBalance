import 'package:TravelBalance/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  String token;
  BaseTokenType tokenType;
  LoginType loginType;

  Authentication(this.token, this.tokenType, this.loginType);
}

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

  void saveToken(
      String currentToken, BaseTokenType type, LoginType login) async {
    await _prefs.setString(token, currentToken);
    await _prefs.setString(tokenType, type.name);
    await _prefs.setString(loginType, login.name);
  }

  void clearToken() async {
    await _prefs.remove(token);
    await _prefs.remove(tokenType);
  }

  Future<Authentication?> getToken() async {
    final String? l_token = await _prefs.getString(token);
    final String? l_tokenType = await _prefs.getString(tokenType);
    final String? l_loginType = await _prefs.getString(loginType);

    if (l_tokenType == null || l_token == null || l_loginType == null)
      return null;

    return Authentication(
        l_token,
        ApiService().getBaseTokenTypeFromString(l_tokenType),
        ApiService().getLoginTypeFromString(l_loginType));
  }
}
