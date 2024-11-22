import 'package:TravelBalance/services/api_service.dart';
import 'package:flutter/material.dart';
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

  void saveAuthentication(Authentication newAuthentication) async {
    try {
      await Future.wait([
        _prefs.setString(token, newAuthentication.token),
        _prefs.setString(tokenType, newAuthentication.tokenType.name),
        _prefs.setString(loginType, newAuthentication.loginType.name),
        if (newAuthentication.refreshToken != null)
          _prefs.setString(refreshToken, newAuthentication.refreshToken!),
      ]);
    } catch (e) {
      debugPrint('Error saving authentication: $e');
    }
  }

  void resetAuthentication() async {
    await _prefs.remove(token);
    await _prefs.remove(tokenType);
    await _prefs.remove(loginType);
    await _prefs.remove(refreshToken);
  }

  Authentication? getAuthentication() {
    final String? l_token = _prefs.getString(token);
    final String? l_tokenType = _prefs.getString(tokenType);
    final String? l_loginType = _prefs.getString(loginType);
    final String? l_refreshToken = _prefs.getString(refreshToken);

    if (l_tokenType == null || l_token == null || l_loginType == null)
      return null;

    return Authentication(
        l_token,
        l_refreshToken,
        ApiService().getBaseTokenTypeFromString(l_tokenType),
        ApiService().getLoginTypeFromString(l_loginType));
  }
}
