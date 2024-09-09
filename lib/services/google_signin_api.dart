import 'dart:io';

import 'package:TravelBalance/Utils/CustomScaffold.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn(
    clientId: Platform.isIOS
        ? '1007518232866-9ef0serrldjq7ti29b7apbhtoqp6tbb6.apps.googleusercontent.com'
        : null,
  );

  static Future<GoogleSignInAccount?> login(BuildContext context) async {
    try {
      final GoogleSignInAccount? user = await _googleSignIn.signIn();
      if (user != null) {
        showCustomSnackBar(
            context: context,
            message: 'Successfully signed in as ${user.displayName}',
            type: SnackBarType.correct);
      }
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

  static Future<bool> logout(BuildContext context) async {
    try {
      await _googleSignIn.signOut();
      showCustomSnackBar(
          context: context,
          message: 'User signed out successfully.',
          type: SnackBarType.correct);

      return true;
    } on Exception catch (e) {
      showCustomSnackBar(
          context: context, message: 'Error during Google Sign-Out: $e');
      return false;
    }
  }
}
