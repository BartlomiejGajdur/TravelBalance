import 'package:TravelBalance/TravelBalanceComponents/mock.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInButton extends StatelessWidget {
  final ActionType actionTypeButton;

  AppleSignInButton({super.key, required this.actionTypeButton});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _signInWithApple(context);
      },
      child: MockButton(
        buttonType: ButtonType.apple,
        actionType: actionTypeButton,
      ),
    );
  }

  Future<void> _signInWithApple(BuildContext context) async {
    try {
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

      // Zbieramy dane logowania
      String userIdentifier = appleCredential.userIdentifier ?? "Brak";
      String givenName = appleCredential.givenName ?? "Brak";
      String familyName = appleCredential.familyName ?? "Brak";
      String email = appleCredential.email ?? "Brak";
      String identityToken = appleCredential.identityToken ?? "Brak";
      String authorizationCode = appleCredential.authorizationCode ?? "Brak";
      String state = appleCredential.state ?? "Brak";

      // Wyświetlamy popup z danymi użytkownika
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Dane użytkownika'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Text('User Identifier: $userIdentifier'),
                  Text('Given Name: $givenName'),
                  Text('Family Name: $familyName'),
                  Text('Email: $email'),
                  Text('Identity Token: $identityToken'),
                  Text('Authorization Code: $authorizationCode'),
                  Text('State: $state'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (error) {
      // Obsługa błędów
      print("Error during sign-in: $error");
      // Możesz także pokazać popup z błędem
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                'NIE DZIALA NA ANDROIDZIE, JAK JESTES NA IOS TO COS NIE TAK JEST :('),
            content: Text(error.toString()),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
