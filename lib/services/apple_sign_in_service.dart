import 'package:TravelBalance/TravelBalanceComponents/mock.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io' show Platform;

class AppleSignInButton extends StatelessWidget {
  final ActionType actionTypeButton;
  final Function() toggleLoadingFunc;

  AppleSignInButton(
      {super.key,
      required this.actionTypeButton,
      required this.toggleLoadingFunc});

  void moveToTrips(BuildContext context) {
    Navigator.pushNamed(context, "TripListPage");
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? GestureDetector(
            onTap: () async {
              toggleLoadingFunc();
              bool result = await ApiService().loginApple(context);
              if (result) {
                moveToTrips(context);
              }
              toggleLoadingFunc();
            },
            child: MockButton(
              buttonType: ButtonType.apple,
              actionType: actionTypeButton,
            ),
          )
        : SizedBox();
  }

  static Future<AuthorizationCredentialAppleID> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: 'com.domainname.travelbalance',
        redirectUri: Uri.parse('https://travelbalance.pl/callback'),
      ),
    );
    return appleCredential;
  }
}
