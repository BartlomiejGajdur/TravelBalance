import 'package:TravelBalance/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final String tokenKey = "Token";
  final String refreshTokenKey = "RefreshToken";
  final String tokenTypeKey = "TokenType";
  final String loginTypeKey = "LoginType";

  // Singleton
  static final SecureStorage _instance = SecureStorage._internal();

  factory SecureStorage() {
    return _instance;
  }

  late final FlutterSecureStorage _secureStorage;

  SecureStorage._internal() {
    _secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ),
    );
  }

  /// Save authentication data securely
  Future<void> saveAuthentication(Authentication newAuthentication) async {
    try {
      await Future.wait([
        _secureStorage.write(key: tokenKey, value: newAuthentication.token),
        _secureStorage.write(
            key: tokenTypeKey, value: newAuthentication.tokenType.name),
        _secureStorage.write(
            key: loginTypeKey, value: newAuthentication.loginType.name),
        if (newAuthentication.refreshToken != null)
          _secureStorage.write(
              key: refreshTokenKey, value: newAuthentication.refreshToken!),
      ]);
    } catch (e) {
      debugPrint('Error saving authentication: $e');
    }
  }

  /// Reset authentication data
  Future<void> resetAuthentication() async {
    try {
      await Future.wait([
        _secureStorage.delete(key: tokenKey),
        _secureStorage.delete(key: tokenTypeKey),
        _secureStorage.delete(key: loginTypeKey),
        _secureStorage.delete(key: refreshTokenKey),
      ]);
    } catch (e) {
      debugPrint('Error resetting authentication: $e');
    }
  }

  /// Retrieve authentication data
  Future<Authentication?> getAuthentication() async {
    try {
      final results = await Future.wait([
        _secureStorage.read(key: tokenKey),
        _secureStorage.read(key: tokenTypeKey),
        _secureStorage.read(key: loginTypeKey),
        _secureStorage.read(key: refreshTokenKey),
      ]);

      final token = results[0];
      final tokenType = results[1];
      final loginType = results[2];
      final refreshToken = results[3];

      if (token == null || tokenType == null || loginType == null) {
        return null;
      }

      return Authentication(
        token,
        refreshToken,
        BaseTokenType.fromString(tokenType),
        LoginType.fromString(loginType),
      );
    } catch (e) {
      debugPrint('Error retrieving authentication: $e');
      return null;
    }
  }
}
