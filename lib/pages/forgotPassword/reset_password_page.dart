import 'package:TravelBalance/TravelBalanceComponents/custom_button.dart';
import 'package:TravelBalance/TravelBalanceComponents/custom_text_form_field.dart';
import 'package:TravelBalance/Utils/helper_functions.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ForgotPasswordPage({super.key});

  Future<bool> sendLink() async {
    if (formKey.currentState?.validate() ?? false) {
      return true;
      //return await ApiService().forgotPassword;
    } else {
      throw "Check input errors!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: horizontalPadding),
              child: Text("Reset Password", style: mainTextStyle),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                  "Enter your email, we will send a verification code to your email",
                  style: secondaryTextStyle),
            ),
            SizedBox(height: 32.h),
            CustomTextFormField(
              controller: emailController,
              labelText: 'Email',
              hintText: 'Enter your email address',
              prefixIcon: Icons.email,
              validator: validateEmail,
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: () => Navigator.pushNamed(
                    context, "VerificationCodePage",
                    arguments: emailController.text),
                child: Text("[Debug] Przejdz dalej")),
            Padding(
              padding: EdgeInsets.only(bottom: 50.h),
              child: CustomButton(
                buttonText: "Send Link",
                onPressed: sendLink,
                onSuccess: () =>
                    Navigator.pushNamed(context, "VerificationCodePage"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
