import 'package:TravelBalance/Utils/CustomScaffold.dart';
import 'package:TravelBalance/services/google_signin_api.dart';
import 'package:TravelBalance/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum BaseTokenType { Token, Bearer, None }

class ApiService {
  static final ApiService _instance = ApiService._internal();

  ApiService._internal();

  factory ApiService() => _instance;

  BaseTokenType _tokenType = BaseTokenType.Token;
  String _token = "";
  final String _baseUrl =
      "http://wanderer-test-fe529f1fdf47.herokuapp.com/api/v1/";

  void setToken(String token, BaseTokenType tokenType) {
    _token = token;
    _tokenType = tokenType;
  }

  void clearToken() {
    _token = "";
    _tokenType = BaseTokenType.None;
  }

  String _getTokenPrefix() {
    switch (_tokenType) {
      case BaseTokenType.Bearer:
        return 'Bearer ';
      case BaseTokenType.Token:
        return 'Token ';
      case BaseTokenType.None:
      default:
        return '';
    }
  }

  String _getAuthorizationHeader() {
    final tokenPrefix = _getTokenPrefix();
    return '$tokenPrefix$_token';
  }

  Future<User?> fetchUserData() async {
    try {
      const endPoint = 'trip/get_trips_with_expenses/';
      final response = await http.get(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {'Authorization': _getAuthorizationHeader()},
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        debugPrint('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      return null;
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      final body = {
        'username': username,
        'password': password,
      };
      const endPoint = 'login/';
      final response = await http.post(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        setToken(responseBody['token'], BaseTokenType.Token);
        debugPrint('Login successful: $responseBody');
        return true;
      } else {
        debugPrint('Login failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint("Error logging in: $e");
      return false;
    }
  }

  Future<bool> loginGoogle(BuildContext context) async {
    try {
      final user = await GoogleSignInApi.login(context);
      if (user == null) {
        showCustomSnackBar(
          context: context,
          message: '[GOOGLE] Login failed on googleSignIn part.',
          type: SnackBarType.error,
        );
        return false;
      }
      final GoogleSignInAuthentication googleAuth = await user.authentication;
      final body = {
        "grant_type": "convert_token",
        "client_id":
            "OoJlTyPxfFjtd4IxwioAE4Op2fWe2P7DkBBuMRim", // Must change before release!
        "backend": "google-oauth2",
        "token": googleAuth.accessToken.toString(),
      };
      const endPoint = 'auth/convert-token/';
      final response = await http.post(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        setToken(responseBody['access_token'], BaseTokenType.Bearer);
        showCustomSnackBar(
          context: context,
          message: 'Login successful: ${responseBody}',
          type: SnackBarType.correct,
        );
        return true;
      } else {
        showCustomSnackBar(
          context: context,
          message: 'Login failed with status: ${response.statusCode}',
          type: SnackBarType.error,
        );
        return false;
      }
    } catch (e) {
      showCustomSnackBar(
        context: context,
        message: "Error logging in: $e",
        type: SnackBarType.error,
      );
      return false;
    }
  }

  Future<void> logout() async {
    try {
      const endPoint = 'logout/';
      final response = await http.post(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {'Authorization': _getAuthorizationHeader()},
      );

      if (response.statusCode == 204) {
        clearToken();
        debugPrint('Logout successful');
      } else {
        debugPrint('Logout failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error logging out: $e");
    }
  }

  Future<bool> signup(String username, String email, String password,
      String repeatedPassword) async {
    try {
      final body = {
        "username": username,
        "email": email,
        "password": password,
        "password2": repeatedPassword
      };
      const endPoint = 'user/';
      final response = await http.post(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        debugPrint('Signup successful: $responseBody');
        return true;
      } else {
        debugPrint('Signup failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint("Error signing up: $e");
      return false;
    }
  }
}
