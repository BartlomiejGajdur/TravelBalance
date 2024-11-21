import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  GoogleSignInApi._privateConstructor();

  static final GoogleSignInApi _instance =
      GoogleSignInApi._privateConstructor();

  factory GoogleSignInApi() {
    return _instance;
  }

  final _googleSignIn = GoogleSignIn(
    clientId: Platform.isIOS
        ? '1007518232866-9ef0serrldjq7ti29b7apbhtoqp6tbb6.apps.googleusercontent.com'
        : null,
  );

  Future<GoogleSignInAccount?> login() async {
    try {
      final GoogleSignInAccount? user = await _googleSignIn.signIn();
      if (user == null) {
        debugPrint('User declined login!');
      }
      return user;
    } on Exception catch (e) {
      debugPrint('Error during Google Sign-In: $e');
      return null;
    }
  }

  Future<bool> logout() async {
    try {
      await _googleSignIn.signOut();
      debugPrint('User signed out successfully.');
      return true;
    } on Exception catch (e) {
      debugPrint('Error during Google Sign-Out: $e');
      return false;
    }
  }
}
