import 'package:TravelBalance/TravelBalanceComponents/custom_button.dart';
import 'package:TravelBalance/TravelBalanceComponents/custom_divider.dart';
import 'package:TravelBalance/TravelBalanceComponents/custom_text_form_field.dart';
import 'package:TravelBalance/TravelBalanceComponents/double_line_text.dart';
import 'package:TravelBalance/TravelBalanceComponents/mock.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:TravelBalance/services/apple_sign_in_service.dart';
import 'package:TravelBalance/services/google_signin_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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

  void toggleLoading(bool isLoading) {
    setState(() {
      forceLoading = isLoading;
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
              AppleSignInButton(
                  actionTypeButton: ActionType.login,
                  toggleLoadingFunc: toggleLoading),
              SizedBox(height: 24.h),
              GoogleSignInButton(
                  actionTypeButton: ActionType.login,
                  toggleLoadingFunc: toggleLoading),
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
