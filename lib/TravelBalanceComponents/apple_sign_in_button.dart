import 'package:TravelBalance/Utils/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignInWithAppleButton(
      onPressed: () async {
        try {
          final result = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
          );

          print(result);
          // You can use the result to authenticate the user with your server.
        } catch (error) {
          showCustomSnackBar(
              context: context,
              message: "Error during Apple Sign In: ${error}",
              type: SnackBarType.warning);
        }
      },
    );
  }
}
