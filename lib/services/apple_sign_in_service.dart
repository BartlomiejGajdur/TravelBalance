import 'package:TravelBalance/TravelBalanceComponents/mock.dart';
import 'package:TravelBalance/Utils/custom_snack_bar.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io' show Platform;

class AppleSignInButton extends StatelessWidget {
  final ActionType actionTypeButton;
  final Function(bool isLoading) toggleLoadingFunc;

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
              toggleLoadingFunc(true);
              bool result = false;
              try {
                result = await ApiService().loginApple(context);
              } catch (error) {
                showCustomSnackBar(
                    context: context,
                    message: error.toString(),
                    type: SnackBarType.error);
              } finally {
                toggleLoadingFunc(false);
              }
              
              if (result) {
                moveToTrips(context);
              }
              toggleLoadingFunc(false);
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
