import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login(BuildContext context) async {
    try {
      final GoogleSignInAccount? user = await _googleSignIn.signIn();
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully signed in as ${user.displayName}')),
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
