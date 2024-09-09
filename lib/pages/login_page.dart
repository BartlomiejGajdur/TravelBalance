import 'package:TravelBalance/TravelBalanceComponents/custom_button.dart';
import 'package:TravelBalance/TravelBalanceComponents/custom_divider.dart';
import 'package:TravelBalance/TravelBalanceComponents/custom_text_form_field.dart';
import 'package:TravelBalance/TravelBalanceComponents/double_line_text.dart';
import 'package:TravelBalance/TravelBalanceComponents/mock.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/google_signin_api.dart';
import '../pages/forgot_password_page.dart';
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

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

// Google Auth Part @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
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
      });
    }
  }

  Future<bool> loginAS() async {
    return await ApiService()
        .login(usernameController.text, passwordController.text);
  }
// Google Auth Part @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
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
              formKey: formKey,
              labelText: 'Username',
              hintText: 'Please write a username',
              prefixIcon: Icons.person),
          SizedBox(height: 16.h),
          CustomTextFormField(
              controller: passwordController,
              formKey: formKey,
              labelText: 'Password',
              hintText: 'Please insert a password',
              prefixIcon: Icons.lock,
              toggleText: true),
          SizedBox(height: 16.h),
          ForgotPassword(context),
          SizedBox(height: 20.h),
          CustomButton(onPressed: loginAS, buttonText: "Login"),
          SizedBox(height: 40.h),
          const CustomDivider(text: "Or login with"),
          SizedBox(height: 24.h),
          const MockButton(
              buttonType: ButtonType.apple, actionType: ActionType.login),
          SizedBox(height: 24.h),
          const MockButton(
              buttonType: ButtonType.google, actionType: ActionType.login),
          SizedBox(height: 88.h),
          const DoubleLineText(
              first: "Don’t have an account?",
              second: "Sign Up!",
              moveTo: "SignUpPage")
          // ElevatedButton.icon(
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.white,
          //     foregroundColor: Colors.black,
          //   ),
          //   icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
          //   label: const Text('Sign Up with Google'),
          //   onPressed: () {
          //     signIn(context);
          //   },
          // ),
          // if (_user != null)
          //   Padding(
          //     padding: EdgeInsets.only(top: 20.h),
          //     child: Column(
          //       children: [
          //         Text(
          //           '''
          //           Logged in as: ${_user!.displayName}
          //           ${_user!.email}
          //           ${_user!.id}''',
          //           style: TextStyle(fontSize: 8.sp),
          //         ),
          //       ],
          //     ),
          //   ),
          // if (_user != null)
          //   ElevatedButton(
          //       onPressed: () => logOut(context), child: const Text("Logout")),
          // if (_googleAuth != null)
          //   Padding(
          //     padding: EdgeInsets.only(top: 20.h),
          //     child: Column(
          //       children: [
          //         Text(
          //           '''
          //           Authorization in as:
          //           IDToken:
          //           ${_googleAuth!.idToken}
          //           AccessToken:
          //           ${_googleAuth!.accessToken}''',
          //           style: TextStyle(fontSize: 8.sp),
          //         ),
          //       ],
          //     ),
          //   ),
        ],
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
