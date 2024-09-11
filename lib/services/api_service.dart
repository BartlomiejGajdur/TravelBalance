import 'package:flutter/foundation.dart';
import 'package:TravelBalance/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  ApiService._internal();
  static const String _baseToken = "Token ";
  String? _token;
  static const String _baseUrl =
      "http://wanderer-test-fe529f1fdf47.herokuapp.com/api/v1/";

  factory ApiService() {
    return _instance;
  }

  void setUserToken(String token) {
    _token = token;
  }

  Future<User?> fetchWholeUserData() async {
    try {
      var endpoint = 'trip/get_trips_with_expenses/';
      var response = await http.get(Uri.parse('$_baseUrl$endpoint'),
          headers: {'Authorization': '$_baseToken$_token'});

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        debugPrint('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint("Error in fetchWholeUserData: $e");
      return null;
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      Map<String, dynamic> body = {
        'username': username,  
        'password': password,
      };
      var endpoint = 'login/';
      var response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        setUserToken(responseBody['token']);
        debugPrint('Login successful: $responseBody');
        return true;
      } else {
        debugPrint('Request failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint("Error in login: $e");
      return false;
    }
  }

  Future<void> logout() async {
    try {
      var endpoint = 'logout/';
      var response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {'Authorization': '$_baseToken$_token'},
      );

      if (response.statusCode == 204) {
        setUserToken("");
        debugPrint('Logout successful');
      } else {
        debugPrint('Logout Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error in Logout: $e");
    }
  }

  Future<bool> signup(String username, String email, String password,
      String repeatedPassword) async {
    try {
      // Map<String, dynamic> body = {
      //   "username": "bartlo",
      //   "email": "afu62040@doolk.com",
      //   "password": "ZXCVBNM1!",
      //   "password2": "ZXCVBNM1!"
      // };

      Map<String, dynamic> body = {
        "username": username,
        "email": email,
        "password": password,
        "password2": repeatedPassword
      };

      var endpoint = 'user/';
      var response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        var responseBody = jsonDecode(response.body);
        debugPrint('Signup Response: $responseBody');
        return true;
      } else {
        debugPrint('Request failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint("Error in Signup: $e");
      return false;
    }
  }
}
