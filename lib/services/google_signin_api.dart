import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn(
    clientId: Platform.isIOS
        ? '1007518232866-aqth9ace072tfoi7smssfmm9vfkapa8k.apps.googleusercontent.com'
        : null,
  );

  static Future<GoogleSignInAccount?> login(BuildContext context) async {
    try {
      final GoogleSignInAccount? user = await _googleSignIn.signIn();
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Successfully signed in as ${user.displayName}')),
        );
      }
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nie jest to errorr ale te user jest null')),
        );
      }
      return user;
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during Google Sign-In: $e')),
      );
      return null;
    }
  }

  static Future<bool> logout(BuildContext context) async {
    try {
      await _googleSignIn.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User signed out successfully.')),
      );
      return true;
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during Google Sign-Out: $e')),
      );
      return false;
    }
  }
}
