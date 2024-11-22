import 'package:TravelBalance/TravelBalanceComponents/mock.dart';
import 'package:TravelBalance/Utils/custom_snack_bar.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io' show Platform;

class AppleSignInButton extends StatelessWidget {
  final ActionType actionTypeButton;

  AppleSignInButton({super.key, required this.actionTypeButton});

  //Move to i bedzie if w zaleznosci od tego jaka akcja to jest
  void moveToTrips(BuildContext context) {
    Navigator.pushNamed(context, "TripListPage");
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? GestureDetector(
            onTap: () async {
              bool result = await ApiService().loginApple();
              if (result) {
                moveToTrips(context);
              } else {
                showCustomSnackBar(
                    context: context,
                    message: "RESUT FALSE PO LOGOWANIU APPLA");
              }
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

//   void CopyToClipboard(String textToCopy) async {
//     await Clipboard.setData(ClipboardData(text: textToCopy));
//   }

//   Future<void> _signInWithApple(BuildContext context) async {
//     try {
//       final appleCredential = await SignInWithApple.getAppleIDCredential(
//         scopes: [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName,
//         ],
//         webAuthenticationOptions: WebAuthenticationOptions(
//           clientId: 'com.domainname.travelbalance',
//           redirectUri: Uri.parse('https://travelbalance.pl/callback'),
//         ),
//       );

//       // Zbieramy dane logowania
//       String userIdentifier = appleCredential.userIdentifier ?? "Brak";
//       String givenName = appleCredential.givenName ?? "Brak";
//       String familyName = appleCredential.familyName ?? "Brak";
//       String email = appleCredential.email ?? "Brak";
//       String identityToken = appleCredential.identityToken ?? "Brak";
//       String authorizationCode = appleCredential.authorizationCode;
//       String state = appleCredential.state ?? "Brak";

//       // Wyświetlamy popup z danymi użytkownika
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Dane użytkownika'),
//             content: SizedBox(
//               width: double.maxFinite,
//               child: ListView(
//                 shrinkWrap: true,
//                 children: <Widget>[
//                   Text('User Identifier: $userIdentifier'),
//                   ElevatedButton(
//                     onPressed: () => CopyToClipboard(userIdentifier),
//                     child: Text("Copy User Identifier"),
//                   ),
//                   SizedBox(height: 10),
//                   Text('Given Name: $givenName'),
//                   ElevatedButton(
//                     onPressed: () => CopyToClipboard(givenName),
//                     child: Text("Copy Given Name"),
//                   ),
//                   SizedBox(height: 10),
//                   Text('Family Name: $familyName'),
//                   ElevatedButton(
//                     onPressed: () => CopyToClipboard(familyName),
//                     child: Text("Copy Family Name"),
//                   ),
//                   SizedBox(height: 10),
//                   Text('Email: $email'),
//                   ElevatedButton(
//                     onPressed: () => CopyToClipboard(email),
//                     child: Text("Copy Email"),
//                   ),
//                   SizedBox(height: 10),
//                   Text('Identity Token: $identityToken'),
//                   ElevatedButton(
//                     onPressed: () => CopyToClipboard(identityToken),
//                     child: Text("Copy Identity Token"),
//                   ),
//                   SizedBox(height: 10),
//                   Text('Authorization Code: $authorizationCode'),
//                   ElevatedButton(
//                     onPressed: () => CopyToClipboard(authorizationCode),
//                     child: Text("Copy Authorization Code"),
//                   ),
//                   SizedBox(height: 10),
//                   Text('State: $state'),
//                   ElevatedButton(
//                     onPressed: () => CopyToClipboard(state),
//                     child: Text("Copy State"),
//                   ),
//                 ],
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: Text('OK'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     } catch (error) {
//       // Obsługa błędów
//       print("Error during sign-in: $error");
//       // Możesz także pokazać popup z błędem
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text(
//                 'NIE DZIALA NA ANDROIDZIE, JAK JESTES NA IOS TO COS NIE TAK JEST :('),
//             content: Text(error.toString()),
//             actions: <Widget>[
//               TextButton(
//                 child: Text('OK'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }
// }
