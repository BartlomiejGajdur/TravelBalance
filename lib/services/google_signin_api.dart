import 'dart:io';
import 'package:TravelBalance/Utils/custom_snack_bar.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  GoogleSignInApi._privateConstructor();

  static final GoogleSignInApi _instance = GoogleSignInApi._privateConstructor();

  factory GoogleSignInApi() {
    return _instance;
  }

  final _googleSignIn = GoogleSignIn(
    clientId: Platform.isIOS
        ? '1007518232866-9ef0serrldjq7ti29b7apbhtoqp6tbb6.apps.googleusercontent.com'
        : null,
  );

  Future<GoogleSignInAccount?> login(BuildContext context) async {
    try {
      final GoogleSignInAccount? user = await _googleSignIn.signIn();
      if (user == null) {
        showCustomSnackBar(
            context: context,
            message: 'User declined login!',
            type: SnackBarType.warning);
      }
      return user;
    } on Exception catch (e) {
      showCustomSnackBar(
        context: context,
        message: 'Error during Google Sign-In: $e',
      );
      return null;
    }
  }

  Future<bool> logout(BuildContext context) async {
    try {
      await _googleSignIn.signOut();
      showCustomSnackBar(
          context: context,
          message: 'User signed out successfully.',
          type: SnackBarType.correct);
      ApiService().clearToken();
      return true;
    } on Exception catch (e) {
      showCustomSnackBar(
          context: context, message: 'Error during Google Sign-Out: $e');
      return false;
    }
  }
}
