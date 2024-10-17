import 'package:TravelBalance/Utils/custom_snack_bar.dart';
import 'package:TravelBalance/models/expense.dart';
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
  final String _baseUrl = "http://travelbalance.pl/api/v1/";
  //final String _baseUrl =
  //    "http://wanderer-test-fe529f1fdf47.herokuapp.com/api/v1/";

  BaseTokenType getToken() {
    return _tokenType;
  }

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
      const endPoint = 'trip/';
      final response = await http.get(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {'Authorization': _getAuthorizationHeader()},
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        debugPrint(
            'Request FetchUserData failed with status: ${response.statusCode}');
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
      final user = await GoogleSignInApi().login(context);
      if (user == null) {
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
        return true;
      } else {
        showCustomSnackBar(
          context: context,
          message: 'Login Google failed with status: ${response.statusCode}',
          type: SnackBarType.error,
        );
        return false;
      }
    } catch (e) {
      showCustomSnackBar(
        context: context,
        message: "Error Google logging in: $e",
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

  Future<bool> signUp(String username, String email, String password,
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

  Future<bool> forgotPassword(String email) async {
    try {
      final body = {
        'email': email,
      };
      const endPoint = 'user/forgot_password/';
      final response = await http.post(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 204) {
        debugPrint('Forgot Password successful');
        return true;
      } else {
        debugPrint(
            'Forgot Password failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint("Error Forgot Password in: $e");
      return false;
    }
  }

  Future<bool> validateVerificationCode(
      String email, String verificationCode) async {
    try {
      final body = {'email': email, 'token': verificationCode};
      const endPoint = 'user/forgot_password_check_token/';
      final response = await http.post(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 204) {
        debugPrint('Validate Verification Code successful');
        return true;
      } else {
        debugPrint(
            'Validate Verification Code failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint("Error Validate Verification Code in: $e");
      return false;
    }
  }

  Future<bool> changeForgottenPassword(String email, String verificationCode,
      String password, String repeatedPassword) async {
    try {
      final body = {
        'email': email,
        'token': verificationCode,
        'password': password,
        'password2': repeatedPassword
      };
      const endPoint = 'user/forgot_password_confirm/';
      final response = await http.post(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 204) {
        debugPrint('Change Forgotten Password successful');
        return true;
      } else {
        debugPrint(
            'Change Forgotten Password failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint("Error Change Forgotten Password in: $e");
      return false;
    }
  }

  Future<int?> addTrip(String tripName) async {
    try {
      final body = {
        'name': tripName,
      };
      const endPoint = 'trip/';
      final response = await http.post(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {
          'Authorization': _getAuthorizationHeader(),
          'Content-Type': 'application/json'
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        debugPrint('Add Trip successful');
        final responseData = jsonDecode(response.body);
        return responseData["id"];
      } else {
        debugPrint('Add Trip failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint("Error Add Trip in: $e");
      return null;
    }
  }

  Future<bool> deleteTrip(int id) async {
    try {
      final endPoint = 'trip/$id/';
      final response = await http.delete(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {
          'Authorization': _getAuthorizationHeader(),
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 204) {
        debugPrint('Delete Trip successful');
        return true;
      } else {
        debugPrint('Delete Trip failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint("Delete Trip in: $e");
      return false;
    }
  }

  Future<bool> editTrip(int id, String tripName) async {
    try {
      final body = {
        'name': tripName,
      };

      final endPoint = 'trip/$id/';
      final response = await http.put(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {
          'Authorization': _getAuthorizationHeader(),
          'Content-Type': 'application/json'
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        debugPrint('Edit Trip successful');
        return true;
      } else {
        debugPrint('Edit Trip failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint("Edit Trip in: $e");
      return false;
    }
  }

  Future<bool> editExpense(
      final int tripId,
      final int expenseId,
      String newTitle,
      double newCost,
      Category newCategory,
      DateTime newDate) async {
    try {
      final body = {
        'title': newTitle,
        'cost': newCost,
        'category': newCategory.index,
        'date': newDate.toIso8601String(),
      };

      final endPoint = 'trip/$tripId/expense/$expenseId/';

      debugPrint(body.toString());
      debugPrint(endPoint);
      final response = await http.put(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {
          'Authorization': _getAuthorizationHeader(),
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        debugPrint('Edit Expense successful');
        return true;
      } else {
        debugPrint('Edit Expense failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint("Edit Expense in: $e");
      return false;
    }
  }

  Future<bool> deleteExpense(int tripId, int expenseId) async {
    try {
      final endPoint = 'trip/$tripId/expense/$expenseId/';
      final response = await http.delete(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {
          'Authorization': _getAuthorizationHeader(),
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 204) {
        debugPrint('Delete Expense successful');
        return true;
      } else {
        debugPrint('Delete Expense failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint("Delete Expense in: $e");
      return false;
    }
  }

  Future<int?> addExpense(Expense expense) async {
    try {
      final body = {
        'title': expense.title,
        'cost': expense.cost,
        'category': expense.category.index,
        'date': expense.dateTime.toIso8601String(),
      };

      final endPoint = 'trip/${expense.tripId}/expense/';

      debugPrint(body.toString());
      debugPrint(endPoint);
      final response = await http.post(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {
          'Authorization': _getAuthorizationHeader(),
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        debugPrint('Add Expense successful');
        final responseData = jsonDecode(response.body);
        return responseData["id"];
      } else {
        debugPrint('Add Expense failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint("Error Expense Trip in: $e");
      return null;
    }
  }
}
