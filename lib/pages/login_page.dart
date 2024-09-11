import 'package:TravelBalance/TravelBalanceComponents/custom_button.dart';
import 'package:TravelBalance/TravelBalanceComponents/custom_divider.dart';
import 'package:TravelBalance/TravelBalanceComponents/custom_text_form_field.dart';
import 'package:TravelBalance/TravelBalanceComponents/double_line_text.dart';
import 'package:TravelBalance/TravelBalanceComponents/mock.dart';
import 'package:TravelBalance/Utils/CustomScaffold.dart';
import 'package:TravelBalance/pages/trip_list_page.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/google_signin_api.dart';
import '../pages/forgot_password_page.dart';
import '../Utils/globals.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

// Google Auth Part @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
// State is not saved beetwen pages yet !
  GoogleSignInAccount? _user;
  GoogleSignInAuthentication? _googleAuth;
  Future<void> signIn(BuildContext context) async {
    final user = await GoogleSignInApi.login(context);
    setState(() {
      _user = user;
    });
    if (_user != null) {
      final googleAuth = await _user!.authentication;
      setState(() {
        _googleAuth = googleAuth;
      });
    }
  }

  Future<void> logOut(BuildContext context) async {
    bool isUserLogedOut = await GoogleSignInApi.logout(context);
    if (isUserLogedOut) {
      setState(() {
        _user = null;
        _googleAuth = null;
      });
    }
  }

  Future<bool> loginAS() async {
    if (formKey.currentState?.validate() ?? false) {
      return await ApiService()
          .login(usernameController.text, passwordController.text);
    } else {
      throw "Check input errors!";
    }
  }
// Google Auth Part @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

  void moveToTrips() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TripListPage(),
      ),
    );
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
              Padding(
                padding: EdgeInsets.only(left: horizontalPadding),
                child: Text("Welcome back wanderer!", style: mainTextStyle),
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
              ForgotPassword(context),
              SizedBox(height: 20.h),
              CustomButton(
                onPressed: loginAS,
                buttonText: "Login",
                onSuccess: moveToTrips,
              ),
              SizedBox(height: 40.h),
              const CustomDivider(text: "Or"),
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: () => fillLoginAndPassword(
                    context, "testowy_user", "testowehaslo123!", true),
                onDoubleTap: () => fillLoginAndPassword(
                    context, "noTrips", "testowehaslo123!", false),
                child: const MockButton(
                    buttonType: ButtonType.apple, actionType: ActionType.login),
              ),
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: () => signIn(context),
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
              if (_user != null)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  icon:
                      const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                  label: const Text('Log Out'),
                  onPressed: () {
                    logOut(context);
                  },
                ),
              if (_googleAuth != null)
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[100],
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("Copy accessToken"),
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(
                          text: _googleAuth!.accessToken.toString()));
                    },
                  ),
                ),
              if (_googleAuth != null)
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[200],
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("Copy idToken"),
                    onPressed: () async {
                      await Clipboard.setData(
                          ClipboardData(text: _googleAuth!.idToken.toString()));
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Padding ForgotPassword(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: horizontalPadding),
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ForgotPasswordPage()),
            );
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
