import 'dart:io';

import 'package:TravelBalance/Utils/country_picker.dart';
import 'package:TravelBalance/Utils/custom_snack_bar.dart';
import 'package:TravelBalance/models/custom_image.dart';
import 'package:TravelBalance/models/expense.dart';
import 'package:TravelBalance/services/apple_sign_in_service.dart';
import 'package:TravelBalance/services/google_signin_api.dart';
import 'package:TravelBalance/models/user.dart';
import 'package:TravelBalance/services/shared_prefs_storage.dart';
import 'package:country_picker/country_picker.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum BaseTokenType { Token, Bearer, None }

enum LoginType { Google, Apple, Email, None }

class SecretKeys {
  final String GOOGLE_CLIENT_ID;
  final String APPLE_CLIENT_SECRET;
  final String APPLE_CLIENT_ID;

  SecretKeys({
    required this.GOOGLE_CLIENT_ID,
    required this.APPLE_CLIENT_SECRET,
    required this.APPLE_CLIENT_ID,
  });
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  ApiService._internal();

  factory ApiService() => _instance;

  BaseTokenType _tokenType = BaseTokenType.Token;
  LoginType _loginType = LoginType.None;
  String _token = "";
  final String _baseUrl = "https://travelbalance.pl/api/v1/";
  late final SecretKeys _secrets;

  void initializeSecrets(SecretKeys secrets) {
    this._secrets = secrets;
  }

  BaseTokenType getToken() {
    return _tokenType;
  }

  LoginType getLoginType() {
    return _loginType;
  }

  void setToken(String token, BaseTokenType tokenType, LoginType loginType) {
    _token = token;
    _tokenType = tokenType;
    _loginType = loginType;
    SharedPrefsStorage().saveToken(token, tokenType, loginType);
  }

  void clearToken() {
    _token = "";
    _tokenType = BaseTokenType.None;
    _loginType = LoginType.None;
  }

  BaseTokenType getBaseTokenTypeFromString(String tokenType) {
    switch (tokenType) {
      case 'Bearer':
        return BaseTokenType.Bearer;
      case 'Token':
        return BaseTokenType.Token;
      case '':
      default:
        return BaseTokenType.None;
    }
  }

  LoginType getLoginTypeFromString(String loginType) {
    switch (loginType) {
      case 'Google':
        return LoginType.Google;
      case 'Apple':
        return LoginType.Apple;
      case 'Email':
        return LoginType.Email;
      default:
        return LoginType.None;
    }
  }

  String _getAuthorizationHeader() {
    final tokenPrefix = _tokenType.name;
    return '$tokenPrefix $_token';
  }

  Future<User?> fetchUserData() async {
    try {
      const fetchTripsEndPoint = 'trip/';
      const userDataEndPoint = 'user/me/';
      final tripsRequest = http.get(
        Uri.parse('$_baseUrl$fetchTripsEndPoint'),
        headers: {'Authorization': _getAuthorizationHeader()},
      );

      final userDataRequest = http.get(
        Uri.parse('$_baseUrl$userDataEndPoint'),
        headers: {'Authorization': _getAuthorizationHeader()},
      );

      final responses = await Future.wait([tripsRequest, userDataRequest]);

      final tripsResponse = responses[0];
      final userDataResponse = responses[1];

      if (tripsResponse.statusCode == 200 &&
          userDataResponse.statusCode == 200) {
        debugPrint('Fetch trips and user data successful');
        final tripsData = jsonDecode(tripsResponse.body);
        final userData = jsonDecode(userDataResponse.body);
        return User.fromJson(tripsData, userData);
      } else {
        debugPrint(
            'Failed to fetch data. Trips status: ${tripsResponse.statusCode}, User data status: ${userDataResponse.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
      return null;
    }
  }

  Future<bool> login(String username, String password) async {
    final body = {
      'username': username,
      'password': password,
    };
    const endPoint = 'login/';
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        setToken(responseBody['token'], BaseTokenType.Token, LoginType.Email);
        debugPrint('Login successful: $responseBody');
        return true;
      } else {
        final responseBody = jsonDecode(response.body);
        debugPrint('Login failed with status: ${response.statusCode}');
        throw (responseBody['non_field_errors'].toString());
      }
    } on SocketException catch (e) {
      debugPrint('No internet connection: $e');
      throw ("No internet connection!");
    } catch (e) {
      debugPrint('Unexpected error: $e');
      rethrow;
    }
  }

  Future<bool> loginGoogle() async {
    try {
      final user = await GoogleSignInApi().login();
      if (user == null) {
        debugPrint("User null po logowaniu google");
        return false;
      }
      final GoogleSignInAuthentication googleAuth = await user.authentication;
      final body = {
        "grant_type": "convert_token",
        "client_id": _secrets.GOOGLE_CLIENT_ID,
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
        setToken(responseBody['access_token'], BaseTokenType.Bearer,
            LoginType.Google);
        debugPrint('Login successful: bearer: $responseBody');
        return true;
      } else {
        debugPrint("'Login Google failed with status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("Error Google logging in: $e");
      return false;
    }
  }

  Future<bool> loginApple(BuildContext context) async {
    try {
      final user = await AppleSignInButton.signInWithApple();
      assert(user.identityToken != null);

      final body = {
        "client_id": _secrets.APPLE_CLIENT_ID,
        "backend": "apple-id",
        "grant_type": "convert_token",
        "token": user.identityToken,
      };
      const endPoint = 'auth/convert-token/';
      final response = await http.post(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        setToken(responseBody['access_token'], BaseTokenType.Bearer,
            LoginType.Apple);
        debugPrint('Login APPLE successful: bearer: $responseBody');
        return true;
      } else {
        debugPrint("'Login APPLE failed with status: ${response.statusCode}");
        showCustomSnackBar(
            context: context, message: jsonDecode(response.body).toString());
        return false;
      }
    } catch (e) {
      debugPrint("Error APPLE logging in: $e");
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
        final responseBody = jsonDecode(response.body);
        String errorString = [
          responseBody['non_field_errors'],
          responseBody['username'],
          responseBody['email'],
          responseBody['password']
        ].where((error) => error != null).map((error) {
          if (error is List) {
            return error.join(" ");
          }
          return error.toString();
        }).join(" ");

        throw errorString;
      }
    } on SocketException catch (e) {
      debugPrint('No internet connection: $e');
      throw ("No internet connection!");
    } catch (e) {
      debugPrint('Unexpected error: $e');
      rethrow;
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
    } on SocketException catch (e) {
      debugPrint('No internet connection: $e');
      throw ("No internet connection!");
    } catch (e) {
      throw 'Unexpected error: $e';
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword,
      String newPasswordRepeated) async {
    try {
      final body = {
        'old_password': oldPassword,
        'password': newPassword,
        'password2': newPasswordRepeated
      };
      const endPoint = 'user/change_password/';
      final response = await http.post(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {
          'Authorization': _getAuthorizationHeader(),
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 204) {
        debugPrint('Change Password successful');
        return true;
      } else {
        final responseBody = jsonDecode(response.body);
        if (responseBody.containsKey('old_password')) {
          throw responseBody['old_password'];
        } else {
          throw "Change Password failed with status: ${response.statusCode}";
        }
      }
    } on SocketException catch (e) {
      debugPrint('No internet connection: $e');
      throw ("No internet connection!");
    } catch (e) {
      debugPrint('Unexpected error: $e');
      throw 'Unexpected error: $e';
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

  Future<int?> addTrip(
      String tripName, CustomImage customImage, List<Country> countries) async {
    try {
      final body = {
        'name': tripName,
        'image_id': customImage.index,
        'countries': countries
            .map((country) => CountryPicker.getIdByCountry(country))
            .toList(),
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
        final responseData = jsonDecode(response.body);
        print(responseData.toString());
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

  Future<bool> editTrip(int id, String tripName, CustomImage customImage,
      List<Country> countries) async {
    try {
      final body = {
        'name': tripName,
        'image_id': customImage.index,
        'countries': countries
            .map((country) => CountryPicker.getIdByCountry(country))
            .toList(),
      };

      print(body.toString());

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
      Currency newCurrency,
      Category newCategory,
      DateTime newDate) async {
    try {
      final body = {
        'cost': newCost,
        'category': newCategory.index,
        'date': newDate.toIso8601String(),
        'currency': newCurrency.code
      };

      if (newTitle.isNotEmpty) {
        body['title'] = newTitle;
      }

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

  Future<int?> addExpense(int tripId, String title, double cost,
      Currency currency, Category category, DateTime dateTime) async {
    try {
      var body = {
        'cost': cost,
        'category': category.index,
        'date': dateTime.toIso8601String(),
        'currency': currency.code
      };

      if (title.isNotEmpty) {
        body['title'] = title;
      }

      debugPrint(body.toString());
      final endPoint = 'trip/$tripId/expense/';

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

  Future<bool> sendFeedback(String message, String type) async {
    try {
      final body = {'message': message, 'type': type};

      const endPoint = 'user/feedback/';

      final response = await http.post(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {
          'Authorization': _getAuthorizationHeader(),
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        debugPrint('Feedback send successful');
        return true;
      } else {
        throw 'Feedback failed with status: ${response.statusCode}';
      }
    } catch (e) {
      debugPrint("Feedback failed in: $e");
      rethrow;
    }
  }

  Future<bool> updateBaseCurrency(Currency baseCurrency) async {
    try {
      final body = {
        'base_currency': baseCurrency.code,
      };

      const endPoint = 'user/me/';

      final response = await http.patch(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {
          'Authorization': _getAuthorizationHeader(),
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        debugPrint('Update Base Currency successful');
        return true;
      } else {
        debugPrint(
            'Update Base Currency failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint("Update Base Currency in: $e");
      return false;
    }
  }
}
