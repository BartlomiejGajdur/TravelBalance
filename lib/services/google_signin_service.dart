import 'dart:io';

import 'package:TravelBalance/TravelBalanceComponents/mock.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInButton extends StatelessWidget {
  final ActionType actionTypeButton;
  final Function() toggleLoadingFunc;

  GoogleSignInButton(
      {super.key,
      required this.actionTypeButton,
      required this.toggleLoadingFunc});

  void moveToTrips(BuildContext context) {
    Navigator.pushNamed(context, "TripListPage");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        toggleLoadingFunc();
        bool result = await ApiService().loginGoogle();
        if (result) {
          moveToTrips(context);
        }
        toggleLoadingFunc();
      },
      child: MockButton(
        buttonType: ButtonType.google,
        actionType: actionTypeButton,
      ),
    );
  }

  static final _googleSignIn = GoogleSignIn(
      clientId: Platform.isIOS
          ? "1007518232866-2j5uguag2hs5rmg7r7k4120v640k0pqs.apps.googleusercontent.com"
          : null);

  static Future<GoogleSignInAccount?> login() async {
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

  static Future<bool> logout() async {
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
