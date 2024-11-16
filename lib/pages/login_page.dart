import 'package:TravelBalance/TravelBalanceComponents/custom_button.dart';
import 'package:TravelBalance/TravelBalanceComponents/custom_divider.dart';
import 'package:TravelBalance/TravelBalanceComponents/custom_text_form_field.dart';
import 'package:TravelBalance/TravelBalanceComponents/double_line_text.dart';
import 'package:TravelBalance/TravelBalanceComponents/mock.dart';
import 'package:TravelBalance/Utils/custom_snack_bar.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../Utils/globals.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool forceLoading = false;
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void toggleLoading() {
    setState(() {
      forceLoading = !forceLoading;
    });
  }

  Future<bool> loginAS() async {
    if (formKey.currentState?.validate() ?? false) {
      return await ApiService()
          .login(usernameController.text, passwordController.text);
    } else {
      throw "Check input errors!";
    }
  }

  void moveToTrips() {
    Navigator.pushNamed(context, "TripListPage");
  }

  //FOR DEBUG
  void fillLoginAndPassword(
      BuildContext context, String login, String password, bool haveTrips) {
    usernameController.text = login;
    passwordController.text = password;
    String textMsg = "[DEBUG ONLY] - ";
    textMsg += haveTrips
        ? "User credentials with trips"
        : "User credentials without trips";

    showCustomSnackBar(
        context: context, message: textMsg, type: SnackBarType.information);
  }

  Future<void> signInWithApple(BuildContext context) async {
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
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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

  //FOR DEBUG

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 108.h),
              GestureDetector(
                onTap: () => fillLoginAndPassword(
                    context, "testowy_user", "testowehaslo123", true),
                child: Padding(
                  padding: EdgeInsets.only(left: horizontalPadding),
                  child: Text("Welcome back wanderer!", style: mainTextStyle),
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.only(left: horizontalPadding),
                child: Text(
                  "Sign In to your account",
                  style: secondaryTextStyle,
                ),
              ),
              SizedBox(height: 24.h),
              CustomTextFormField(
                  controller: usernameController,
                  labelText: 'Username',
                  hintText: 'Enter your username',
                  prefixIcon: Icons.person),
              SizedBox(height: 16.h),
              CustomTextFormField(
                  controller: passwordController,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: Icons.lock,
                  toggleText: true),
              SizedBox(height: 16.h),
              forgotPassword(context),
              SizedBox(height: 20.h),
              CustomButton(
                onPressed: loginAS,
                buttonText: "Login",
                onSuccess: moveToTrips,
                forceLoading: forceLoading,
              ),
              SizedBox(height: 40.h),
              const CustomDivider(text: "Or"),
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: () async {
                  signInWithApple(context);
                },
                child: const MockButton(
                    buttonType: ButtonType.apple, actionType: ActionType.login),
              ),
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: () async {
                  toggleLoading();
                  bool result = await ApiService().loginGoogle(context);
                  if (result) {
                    moveToTrips();
                  }
                  toggleLoading();
                },
                child: const MockButton(
                    buttonType: ButtonType.google,
                    actionType: ActionType.login),
              ),
              SizedBox(height: 88.h),
              const DoubleLineText(
                  first: "Don’t have an account?",
                  second: "Sign Up!",
                  moveTo: "SignUpPage"),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }

  Padding forgotPassword(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: horizontalPadding),
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "ForgotPasswordPage");
          },
          child: Text(
            "Forgot Password?",
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: secondaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
