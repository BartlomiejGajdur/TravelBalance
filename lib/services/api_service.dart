import 'dart:io';

import 'package:TravelBalance/Utils/country_picker.dart';
import 'package:TravelBalance/Utils/custom_snack_bar.dart';
import 'package:TravelBalance/models/custom_image.dart';
import 'package:TravelBalance/models/expense.dart';
import 'package:TravelBalance/services/apple_sign_in_service.dart';
import 'package:TravelBalance/services/google_signin_service.dart';
import 'package:TravelBalance/models/user.dart';
import 'package:TravelBalance/services/secure_storage_service.dart';
import 'package:country_picker/country_picker.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

enum BaseTokenType {
  Token,
  Bearer,
  None;

  static BaseTokenType fromString(String baseTokenType) {
    switch (baseTokenType) {
      case 'Bearer':
        return BaseTokenType.Bearer;
      case 'Token':
        return BaseTokenType.Token;
      default:
        return BaseTokenType.None;
    }
  }
}

enum LoginType {
  Google,
  Apple,
  Email,
  None;

  static LoginType fromString(String loginType) {
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
}

class Authentication {
  String token;
  String? refreshToken;
  BaseTokenType tokenType;
  LoginType loginType;

  Authentication(
    this.token,
    this.refreshToken,
    this.tokenType,
    this.loginType,
  );

  void reset() {
    token = "";
    refreshToken = null;
    tokenType = BaseTokenType.None;
    loginType = LoginType.None;
  }
}

class SecretKeys {
  final String GOOGLE_CLIENT_ID;
  final String GOOGLE_CLIENT_SECRET;
  final String APPLE_CLIENT_SECRET;
  final String APPLE_CLIENT_ID;

  SecretKeys({
    required this.GOOGLE_CLIENT_ID,
    required this.GOOGLE_CLIENT_SECRET,
    required this.APPLE_CLIENT_SECRET,
    required this.APPLE_CLIENT_ID,
  });
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  ApiService._internal();
  factory ApiService() => _instance;

  late final SecretKeys _secrets;
  late Authentication _authentication;
  final String _baseUrl = "https://travelbalance.pl/api/v1/";

  void initializeSecrets(SecretKeys secrets) {
    this._secrets = secrets;
  }

  LoginType get loginType => _authentication.loginType;

  Future<bool> refreshToken() async {
    if (loginType != LoginType.Google && loginType != LoginType.Apple)
      return false;

    if (_authentication.refreshToken == null) {
      debugPrint('No refresh token available.');
      return false;
    }
    try {
      late final String CLIENT_ID, CLIENT_SECRET;
      if (loginType == LoginType.Google) {
        CLIENT_ID = _secrets.GOOGLE_CLIENT_ID;
        CLIENT_SECRET = _secrets.GOOGLE_CLIENT_SECRET;
      }
      if (loginType == LoginType.Apple) {
        CLIENT_ID = _secrets.APPLE_CLIENT_ID;
        CLIENT_SECRET = _secrets.APPLE_CLIENT_SECRET;
      }

      final body = {
        "client_id": CLIENT_ID,
        "client_secret": CLIENT_SECRET,
        "grant_type": "refresh_token",
        "refresh_token": _authentication.refreshToken!,
      };

      const endPoint = 'auth/token/';
      final response = await http.post(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      handleResponseProblems(response, 200, true, "RefreshToken");

      final responseBody = jsonDecode(response.body);
      setAuthentication(Authentication(
        responseBody['access_token'],
        responseBody['refresh_token'],
        BaseTokenType.Bearer,
        loginType,
      ));

      return true;
    } catch (e) {
      debugPrint('Refresh Token Apple/Google failed: $e');
      return false;
    }
  }

  void setAuthentication(Authentication newAuthentication) {
    _authentication = newAuthentication;
    SecureStorage().saveAuthentication(newAuthentication);
  }

  void resetAuthentication() {
    _authentication.reset();
  }

  String _getAuthorizationHeader() {
    final tokenPrefix = _authentication.tokenType.name;
    return '$tokenPrefix ${_authentication.token}';
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

      handleResponseProblems(tripsResponse, 200, "FetchUserData_Trips");
      handleResponseProblems(userDataResponse, 200, "FetchUserData_User");

      final tripsData = jsonDecode(tripsResponse.body);
      final userData = jsonDecode(userDataResponse.body);
      return User.fromJson(tripsData, userData);
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
        setAuthentication(Authentication(
            responseBody['token'], null, BaseTokenType.Token, LoginType.Email));
        debugPrint('Login successful: $responseBody');
        return true;
      } else if (response.statusCode >= 500) {
        throw "Internal Server Error. Please try again later.";
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
      final user = await GoogleSignInButton.login();
      if (user == null) {
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
        setAuthentication(Authentication(
            responseBody['access_token'],
            responseBody['refresh_token'],
            BaseTokenType.Bearer,
            LoginType.Google));
        debugPrint('Login Google successful');
        return true;
      } else {
        debugPrint("Login Google failed with status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      throw "Error Google logging in: $e";
    }
  }

  Future<bool> loginApple(BuildContext context) async {
    try {
      final user = await AppleSignInButton.signInWithApple();

      if (user.identityToken == null) {
        debugPrint('Identity token is null.');
        showCustomSnackBar(
            context: context,
            message: 'Apple sign-in failed. Please try again.',
            type: SnackBarType.error);
        return false;
      }

      final body = {
        "client_id": _secrets.APPLE_CLIENT_ID,
        "backend": "apple-id",
        "grant_type": "convert_token",
        "token": user.identityToken!,
      };

      final encodedBody = body.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');

      const endPoint = 'auth/convert-token/';
      final response = await http.post(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: encodedBody,
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setAuthentication(Authentication(
          responseBody['access_token'],
          responseBody['refresh_token'],
          BaseTokenType.Bearer,
          LoginType.Apple,
        ));
        debugPrint('Login apple successful');
        return true;
      } else {
        debugPrint('Login apple failed: $responseBody');
        return false;
      }
    } catch (e, stacktrace) {
      debugPrint("Error apple logging in: $e");
      debugPrint("Stacktrace: $stacktrace");
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
      } else if (response.statusCode >= 500) {
        throw "Internal Server Error. Please try again later.";
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

/*


PATCH DONE


*/

  Future<bool> updateBaseCurrency(Currency baseCurrency) async {
    final body = {
      'base_currency': baseCurrency.code,
    };
    final apiRequestName = "Update Base Currency";
    final response = await patchApiRequest('user/me/', body, apiRequestName);
    handleResponseProblems(response, 200, true, apiRequestName);
    return true;
  }

  Future<Response> patchApiRequest(
      String endPoint, Map<String, String> body, String apiRequestName) async {
    late final Response response;

    try {
      response = await http.patch(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {
          'Authorization': _getAuthorizationHeader(),
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
    } on SocketException {
      throw 'Error $apiRequestName: No Internet connection.';
    } on FormatException {
      throw 'Error $apiRequestName: Bad response format.';
    } catch (e) {
      throw 'Error $apiRequestName: Unexpected error occurred: $e';
    }

    return response;
  }

/*


Delete DONE


*/

  Future<bool> deleteUser() async {
    final apiRequestName = "Delete Account";
    final response = await deleteApiRequest('user/me/', apiRequestName);
    handleResponseProblems(response, 204, true, apiRequestName);
    return true;
  }

  Future<bool> deleteTrip(int id) async {
    final apiRequestName = "Delete Trip";
    final response = await deleteApiRequest('trip/$id/', apiRequestName);
    handleResponseProblems(response, 204, true, apiRequestName);
    return true;
  }

  Future<bool> deleteExpense(int tripId, int expenseId) async {
    final apiRequestName = "Delete Expense";
    final response = await deleteApiRequest(
        'trip/$tripId/expense/$expenseId/', apiRequestName);
    handleResponseProblems(response, 204, true, apiRequestName);
    return true;
  }

  Future<Response> deleteApiRequest(
      String endPoint, String apiRequestName) async {
    late final Response response;

    try {
      response = await http.delete(
        Uri.parse('$_baseUrl$endPoint'),
        headers: {
          'Authorization': _getAuthorizationHeader(),
          'Content-Type': 'application/json',
        },
      );
    } on SocketException {
      throw 'Error $apiRequestName: No Internet connection.';
    } on FormatException {
      throw 'Error $apiRequestName: Bad response format.';
    } catch (e) {
      throw 'Error $apiRequestName: Unexpected error occurred: $e';
    }

    debugPrint("API SERVICE $apiRequestName Correct");
    return response;
  }

  void handleResponseProblems(Response response, int expectedResponseCode,
      bool throwable, String apiRequestType) {
    if (response.statusCode == expectedResponseCode) {
      debugPrint("API SERVICE CODE: $apiRequestType Correct");
      return;
    }

    if (!throwable) {
      debugPrint(
          "API SERVICE CODE NO THROW: $apiRequestType -  response (${response.statusCode}).");
      return;
    }

    switch (response.statusCode) {
      case 400:
        throw Exception(
            "API SERVICE CODE: $apiRequestType - Bad Request (400). The server could not understand the request due to invalid syntax.");
      case 401:
        throw Exception(
            "API SERVICE CODE: $apiRequestType - Unauthorized (401). Authentication is required and has failed or not provided.");
      case 403:
        throw Exception(
            "API SERVICE CODE: $apiRequestType - Forbidden (403). You do not have the necessary permissions.");
      case 404:
        throw Exception(
            "API SERVICE CODE: $apiRequestType - Not Found (404). The requested resource could not be found.");
      case 409:
        throw Exception(
            "API SERVICE CODE: $apiRequestType - Conflict (409). The request conflicts with the current state of the server.");
      case 500:
        throw Exception(
            "API SERVICE CODE: $apiRequestType - Internal Server Error (500). The server encountered an unexpected condition.");
      case 502:
        throw Exception(
            "API SERVICE CODE: $apiRequestType - Bad Gateway (502). The server received an invalid response from the upstream server.");
      case 503:
        throw Exception(
            "API SERVICE CODE: $apiRequestType - Service Unavailable (503). The server is not ready to handle the request.");
      case 504:
        throw Exception(
            "API SERVICE CODE: $apiRequestType - Gateway Timeout (504). The server took too long to respond.");
      default:
        throw Exception(
            "API SERVICE CODE: $apiRequestType - Unexpected response (${response.statusCode}).");
    }
  }
}
