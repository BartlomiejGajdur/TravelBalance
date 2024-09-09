import 'package:TravelBalance/TravelBalanceComponents/custom_button.dart';
import 'package:TravelBalance/TravelBalanceComponents/custom_divider.dart';
import 'package:TravelBalance/TravelBalanceComponents/custom_text_form_field.dart';
import 'package:TravelBalance/TravelBalanceComponents/double_line_text.dart';
import 'package:TravelBalance/TravelBalanceComponents/mock.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:TravelBalance/services/api_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  Future<bool> signup() async {
    return await ApiService().signup(
        usernameController.text,
        emailController.text,
        passwordController.text,
        repeatPasswordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0.h),
        child: AppBar(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.only(left: horizontalPadding),
            child: Text("Sign Up", style: mainTextStyle),
          ),
          SizedBox(height: 24.h),
          CustomTextFormField(
              controller: usernameController,
              formKey: formKey,
              labelText: 'Username',
              hintText: 'Please insert a username',
              prefixIcon: Icons.person),
          SizedBox(height: 12.h),
          CustomTextFormField(
              controller: emailController,
              formKey: formKey,
              labelText: 'Email',
              hintText: 'Please insert a Email',
              prefixIcon: Icons.email),
          SizedBox(height: 12.h),
          CustomTextFormField(
              controller: passwordController,
              formKey: formKey,
              labelText: 'Password',
              hintText: 'Please insert a password',
              prefixIcon: Icons.lock,
              toggleText: true),
          SizedBox(height: 12.h),
          CustomTextFormField(
              controller: repeatPasswordController,
              formKey: formKey,
              labelText: 'Confirm Password',
              hintText: 'Please repeat password',
              prefixIcon: Icons.lock,
              toggleText: true),
          SizedBox(height: 24.h),
          CustomButton(onPressed: signup, buttonText: "Sign up"),
          SizedBox(height: 30.h),
          const CustomDivider(text: "Or Sign in with"),
          SizedBox(height: 24.h),
          const MockButton(
              buttonType: ButtonType.apple, actionType: ActionType.signUp),
          SizedBox(height: 24.h),
          const MockButton(
              buttonType: ButtonType.google, actionType: ActionType.signUp),
          SizedBox(height: 30.h),
          const DoubleLineText(
              first: "Have an account?",
              second: "Sign In!",
              moveTo: "LoginPage"),
        ],
      ),
    );
  }
}
