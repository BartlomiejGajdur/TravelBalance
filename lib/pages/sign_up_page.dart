import 'package:TravelBalance/TravelBalanceComponents/custom_button.dart';
import 'package:TravelBalance/TravelBalanceComponents/custom_divider.dart';
import 'package:TravelBalance/TravelBalanceComponents/custom_text_form_field.dart';
import 'package:TravelBalance/TravelBalanceComponents/double_line_text.dart';
import 'package:TravelBalance/TravelBalanceComponents/mock.dart';
import 'package:TravelBalance/Utils/CustomScaffold.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/Utils/helper_functions.dart';
import 'package:TravelBalance/pages/email_confirmation.dart';
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

  Future<bool> signUp() async {
    if (formKey.currentState?.validate() ?? false) {
      return await ApiService().signup(
          usernameController.text,
          emailController.text,
          passwordController.text,
          repeatPasswordController.text);
    } else {
      return false;
    }
  }

  void moveToEmailConfirmation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmailConfirmation(),
      ),
    );
  }

  //FOR DEBUG
  void fillLoginAndPassword(BuildContext context) {
    const String password = "testowehaslo123!";
    passwordController.text = password;
    repeatPasswordController.text = password;
    String textMsg = "[DEBUG ONLY] - Default password set $password";

    showCustomSnackBar(
        context: context, message: textMsg, type: SnackBarType.information);
  }
  //FOR DEBUG

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0.h),
        child: AppBar(),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
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
                  labelText: 'Username',
                  hintText: 'Enter your username',
                  prefixIcon: Icons.person),
              SizedBox(height: 12.h),
              CustomTextFormField(
                  controller: emailController,
                  labelText: 'Email',
                  hintText: 'Enter your email address',
                  prefixIcon: Icons.email,
                  validator: validateEmail),
              SizedBox(height: 12.h),
              CustomTextFormField(
                  controller: passwordController,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: Icons.lock,
                  toggleText: true),
              SizedBox(height: 12.h),
              CustomTextFormField(
                  controller: repeatPasswordController,
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  prefixIcon: Icons.lock,
                  toggleText: true),
              SizedBox(height: 24.h),
              CustomButton(
                onPressed: signUp,
                buttonText: "Sign up",
                onSuccess: moveToEmailConfirmation,
              ),
              SizedBox(height: 30.h),
              const CustomDivider(text: "Or"),
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: () => fillLoginAndPassword(context),
                child: const MockButton(
                    buttonType: ButtonType.apple,
                    actionType: ActionType.signUp),
              ),
              SizedBox(height: 24.h),
              const MockButton(
                  buttonType: ButtonType.google, actionType: ActionType.signUp),
              SizedBox(height: 30.h),
              const DoubleLineText(
                  first: "Have an account?",
                  second: "Log In!",
                  moveTo: "LoginPage"),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }
}
