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

// Post Requests

  Future<bool> refreshToken() async {
    if (loginType != LoginType.Google && loginType != LoginType.Apple)
      return false;

    if (_authentication.refreshToken == null) {
      debugPrint('No refresh token available.');
      return false;
    }

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
    final apiRequestName = "Refresh Token";
    final response = await _postApiRequest(
        'auth/token/', body, false, false, apiRequestName);
    handleResponseProblems(response, 200, true, apiRequestName);

    final responseBody = jsonDecode(response.body);
    setAuthentication(Authentication(
      responseBody['access_token'],
      responseBody['refresh_token'],
      BaseTokenType.Bearer,
      loginType,
    ));

    return true;
  }

  Future<User?> fetchUserData() async {
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

    handleResponseProblems(tripsResponse, 200, true, "FetchUserData_Trips");
    handleResponseProblems(userDataResponse, 200, true, "FetchUserData_User");

    final tripsData = json.decode(utf8.decode(tripsResponse.bodyBytes)); // CHECK ON PROD
    final userData = jsonDecode(userDataResponse.body);
    return User.fromJson(tripsData, userData);
  }

  Future<bool> login(String username, String password) async {
    final body = {
      'username': username,
      'password': password,
    };
    final apiRequestName = "Login";
    String errorMsg = "$apiRequestName Undefined Error";
    final response =
        await _postApiRequest('login/', body, false, false, apiRequestName);

    try {
      handleResponseProblems(response, 200, true, apiRequestName);
    } catch (e) {
      errorMsg = e.toString();
    }

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setAuthentication(Authentication(
          responseBody['token'], null, BaseTokenType.Token, LoginType.Email));
      return true;
    }

    if (responseBody.containsKey('non_field_errors'))
      throw responseBody['non_field_errors'].toString();

    throw errorMsg;
  }

  Future<bool> loginGoogle(BuildContext context) async {
    final user = await GoogleSignInButton.login();
    if (user == null) {
      showCustomSnackBar(
          context: context,
          message: 'Google sign-in failed. Please try again.',
          type: SnackBarType.error);
      return false;
    }
    final GoogleSignInAuthentication googleAuth = await user.authentication;
    final body = {
      "grant_type": "convert_token",
      "client_id": _secrets.GOOGLE_CLIENT_ID,
      "backend": "google-oauth2",
      "token": googleAuth.accessToken.toString(),
    };

    final apiRequestName = "Login Google";
    final response = await _postApiRequest(
        'auth/convert-token/', body, false, false, apiRequestName);
    handleResponseProblems(response, 200, true, apiRequestName);
    final responseBody = jsonDecode(response.body);

    setAuthentication(Authentication(responseBody['access_token'],
        responseBody['refresh_token'], BaseTokenType.Bearer, LoginType.Google));

    return true;
  }

  Future<bool> loginApple(BuildContext context) async {
    final user = await AppleSignInButton.signInWithApple();
    if (user.identityToken == null) {
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

    final apiRequestName = "Login Apple";
    final response = await _postApiRequest(
        'auth/convert-token/', body, false, true, apiRequestName);
    handleResponseProblems(response, 200, true, apiRequestName);
    final responseBody = jsonDecode(response.body);

    setAuthentication(Authentication(
      responseBody['access_token'],
      responseBody['refresh_token'],
      BaseTokenType.Bearer,
      LoginType.Apple,
    ));

    return true;
  }

  Future<void> logout() async {
    final apiRequestName = "Logout";
    final response =
        await _postApiRequest('logout/', {}, true, false, apiRequestName);
    handleResponseProblems(response, 204, true, apiRequestName);
  }

  Future<bool> signUp(String username, String email, String password,
      String repeatedPassword) async {
    final body = {
      "username": username,
      "email": email,
      "password": password,
      "password2": repeatedPassword
    };

    final apiRequestName = "Sign Up";
    String errorMsg = "$apiRequestName Undefined Error";
    final response =
        await _postApiRequest('user/', body, false, false, apiRequestName);

    try {
      handleResponseProblems(response, 201, true, apiRequestName);
    } catch (e) {
      errorMsg = e.toString();
    }

    if (response.statusCode == 201) return true;

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

    if (errorString.isNotEmpty) throw errorString;

    throw errorMsg;
  }

  Future<bool> forgotPassword(String email) async {
    final body = {
      'email': email,
    };
    final apiRequestName = "Forgot Password";
    final response = await _postApiRequest(
        'user/forgot_password/', body, false, false, apiRequestName);
    handleResponseProblems(response, 204, true, apiRequestName);
    return true;
  }

  Future<bool> changePassword(String oldPassword, String newPassword,
      String newPasswordRepeated) async {
    final body = {
      'old_password': oldPassword,
      'password': newPassword,
      'password2': newPasswordRepeated
    };
    final apiRequestName = "Change Password";
    String errorMsg = "$apiRequestName Undefined Error";
    final response = await _postApiRequest(
        'user/change_password/', body, true, false, apiRequestName);

    try {
      handleResponseProblems(response, 204, true, apiRequestName);
    } catch (e) {
      errorMsg = e.toString();
    }

    if (response.statusCode == 204) return true;

    final responseBody = jsonDecode(response.body);
    if (responseBody.containsKey('old_password'))
      throw responseBody['old_password'];

    throw errorMsg;
  }

  Future<bool> validateVerificationCode(
      String email, String verificationCode) async {
    final body = {'email': email, 'token': verificationCode};
    final apiRequestName = "Validate Verification Code";
    final response = await _postApiRequest('user/forgot_password_check_token/',
        body, false, false, apiRequestName);
    handleResponseProblems(response, 204, true, apiRequestName);
    return true;
  }

  Future<bool> changeForgottenPassword(String email, String verificationCode,
      String password, String repeatedPassword) async {
    final body = {
      'email': email,
      'token': verificationCode,
      'password': password,
      'password2': repeatedPassword
    };

    final apiRequestName = "Change Forgotten Password";
    final response = await _postApiRequest(
        'user/forgot_password_confirm/', body, false, false, apiRequestName);
    handleResponseProblems(response, 204, true, apiRequestName);
    return true;
  }

  Future<int?> addTrip(
      String tripName, CustomImage customImage, List<Country> countries) async {
    final body = {
      'name': tripName,
      'image_id': customImage.index,
      'countries': countries
          .map((country) => CountryPicker.getIdByCountry(country))
          .toList(),
    };

    final apiRequestName = "Add Trip";
    final response =
        await _postApiRequest('trip/', body, true, false, apiRequestName);
    handleResponseProblems(response, 201, true, apiRequestName);

    final responseData = jsonDecode(response.body);
    return responseData["id"];
  }

  Future<int?> addExpense(int tripId, String title, double cost,
      Currency currency, Category category, DateTime dateTime) async {
    final body = {
      'cost': cost,
      'category': category.index,
      'date': dateTime.toIso8601String(),
      'currency': currency.code
    };

    if (title.isNotEmpty) {
      body['title'] = title;
    }

    final apiRequestName = "Add Expense";
    final response = await _postApiRequest(
        'trip/$tripId/expense/', body, true, false, apiRequestName);
    handleResponseProblems(response, 201, true, apiRequestName);

    final responseData = jsonDecode(response.body);
    return responseData["id"];
  }

  Future<bool> sendFeedback(String message, String type) async {
    final body = {'message': message, 'type': type};
    final apiRequestName = "Send Feedback";
    final response = await _postApiRequest(
        'user/feedback/', body, true, false, apiRequestName);
    handleResponseProblems(response, 201, true, apiRequestName);
    return true;
  }

  Future<bool> sendIAP(String transactionId) async {
    final body = {'transaction_id': transactionId};
    final apiRequestName = "In App Purchase";
    final response = await _postApiRequest(
        'subscription/', body, true, false, apiRequestName);

    return handleResponseProblems(response, 200, true, apiRequestName);
  }

  Future<bool> sendIAPWithRetry(String transactionId,
      {int maxRetries = 4,
      Duration delayBetweenRetries = const Duration(seconds: 10)}) async {
    int attempt = 0;

    while (attempt < maxRetries) {
      try {
        if (await sendIAP(transactionId)) {
          return true;
        } else {
          attempt++;
        }
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) {
          return false;
        }
        await Future.delayed(delayBetweenRetries);
      }
    }

    return false;
  }

// Put Requests

  Future<bool> editTrip(int id, String tripName, CustomImage customImage,
      List<Country> countries) async {
    final body = {
      'name': tripName,
      'image_id': customImage.index,
      'countries': countries
          .map((country) => CountryPicker.getIdByCountry(country))
          .toList(),
    };

    final apiRequestName = "Edit Trip";
    final response = await _putApiRequest('trip/$id/', body, apiRequestName);
    handleResponseProblems(response, 200, true, apiRequestName);
    return true;
  }

  Future<bool> editExpense(
      final int tripId,
      final int expenseId,
      String newTitle,
      double newCost,
      Currency newCurrency,
      Category newCategory,
      DateTime newDate) async {
    final body = {
      'cost': newCost,
      'category': newCategory.index,
      'date': newDate.toIso8601String(),
      'currency': newCurrency.code
    };

    if (newTitle.isNotEmpty) {
      body['title'] = newTitle;
    }

    final apiRequestName = "Edit Expense";
    final response = await _putApiRequest(
        'trip/$tripId/expense/$expenseId/', body, apiRequestName);
    handleResponseProblems(response, 200, true, apiRequestName);
    return true;
  }

// Patch Requests

  Future<bool> updateBaseCurrency(Currency baseCurrency) async {
    final body = {
      'base_currency': baseCurrency.code,
    };
    final apiRequestName = "Update Base Currency";
    final response = await _patchApiRequest('user/me/', body, apiRequestName);
    handleResponseProblems(response, 200, true, apiRequestName);
    return true;
  }

// Delete Requests

  Future<bool> deleteUser() async {
    final apiRequestName = "Delete Account";
    final response = await _deleteApiRequest('user/me/', apiRequestName);
    handleResponseProblems(response, 204, true, apiRequestName);
    return true;
  }

  Future<bool> deleteTrip(int id) async {
    final apiRequestName = "Delete Trip";
    final response = await _deleteApiRequest('trip/$id/', apiRequestName);
    handleResponseProblems(response, 204, true, apiRequestName);
    return true;
  }

  Future<bool> deleteExpense(int tripId, int expenseId) async {
    final apiRequestName = "Delete Expense";
    final response = await _deleteApiRequest(
        'trip/$tripId/expense/$expenseId/', apiRequestName);
    handleResponseProblems(response, 204, true, apiRequestName);
    return true;
  }

// Requests Funcionality

  Future<Response> _sendApiRequest(
    String method,
    String endPoint,
    String apiRequestName, {
    Map<String, Object>? body,
    bool sendAuthorizationHeader = true,
    bool isEncoded = false,
  }) async {
    late final Response response;

    String? encodedBody;
    if (isEncoded && body != null) {
      encodedBody = body.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
          .join('&');
    }

    try {
      final uri = Uri.parse('$_baseUrl$endPoint');
      final headers = {
        if (sendAuthorizationHeader) 'Authorization': _getAuthorizationHeader(),
        'Content-Type': isEncoded
            ? 'application/x-www-form-urlencoded'
            : 'application/json',
      };

      switch (method) {
        case 'POST':
          response = await http.post(
            uri,
            headers: headers,
            body: isEncoded ? encodedBody : jsonEncode(body),
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case 'PATCH':
          response = await http.patch(
            uri,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
          break;
        default:
          throw 'Unsupported HTTP method: $method';
      }
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

  Future<Response> _postApiRequest(String endPoint, Map<String, Object> body,
      bool sendAuthorizationHeader, bool isEncoded, String apiRequestName) {
    return _sendApiRequest(
      'POST',
      endPoint,
      apiRequestName,
      body: body,
      sendAuthorizationHeader: sendAuthorizationHeader,
      isEncoded: isEncoded,
    );
  }

  Future<Response> _putApiRequest(
      String endPoint, Map<String, Object> body, String apiRequestName) {
    return _sendApiRequest('PUT', endPoint, apiRequestName, body: body);
  }

  Future<Response> _patchApiRequest(
      String endPoint, Map<String, Object> body, String apiRequestName) {
    return _sendApiRequest('PATCH', endPoint, apiRequestName, body: body);
  }

  Future<Response> _deleteApiRequest(String endPoint, String apiRequestName) {
    return _sendApiRequest('DELETE', endPoint, apiRequestName);
  }

  bool handleResponseProblems(Response response, int expectedResponseCode,
      bool throwable, String apiRequestType) {
    if (response.statusCode == expectedResponseCode) {
      debugPrint("API SERVICE CODE: $apiRequestType Correct");
      return true;
    }

    if (!throwable) {
      debugPrint(
          "API SERVICE CODE NO THROW: $apiRequestType -  response (${response.statusCode}).");
      return false;
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
