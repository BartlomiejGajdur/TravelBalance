import 'dart:ui';

import 'package:TravelBalance/TravelBalanceComponents/custom_button.dart';
import 'package:TravelBalance/TravelBalanceComponents/custom_text_form_field.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CreateNewPasswordPage extends StatelessWidget {
  final String email;
  final String verificationCode;
  CreateNewPasswordPage(
      {super.key, required this.email, required this.verificationCode});

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<bool> resetPassword(String password, String repeatedPassword) async {
    if (formKey.currentState?.validate() ?? false) {
      return await ApiService().changeForgottenPassword(
          email, verificationCode, password, repeatedPassword);
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
              child: Text("Create New Password", style: mainTextStyle),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                  "Your password must be different from previous used password",
                  style: secondaryTextStyle),
            ),
            SizedBox(height: 32.h),
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
            const Spacer(),

            Padding(
              padding: EdgeInsets.only(bottom: 50.h),
              child: CustomButton(
                  buttonText: "ResetPassword",
                  onPressed: () => resetPassword(
                      passwordController.text, repeatPasswordController.text),
                  onSuccess: () => showBlurDialog(context)),
            )
          ],
        ),
      ),
    );
  }
}

void showBlurDialog(BuildContext context) {
  showGeneralDialog(
    barrierDismissible: false,
    barrierLabel: '',
    barrierColor: Colors.black38,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (ctx, anim1, anim2) => Dialog(
        insetPadding: const EdgeInsets.all(0),
        child: SizedBox(
          height: 400.h,
          width: 335.w,
          child: Column(
            children: [
              SizedBox(height: 25.h),
              SvgPicture.asset(
                "lib/assets/GreenTick.svg",
                height: 120.h,
                width: 120.w,
              ),
              SizedBox(height: 22.h),
              Text(
                "Password Update\nSuccessfully",
                style: mainTextStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                "Password changed succesfully,\nyou can login again with new password",
                style: secondaryTextStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              CustomButton(
                buttonText: "Back to Login",
                onPressed: () async {
                  return true;
                },
                onSuccess: () => Navigator.pushNamed(context, "LoginPage"),
              ),
              SizedBox(height: 25.h),
            ],
          ),
        )),
    transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
      filter:
          ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
      child: FadeTransition(
        opacity: anim1,
        child: child,
      ),
    ),
    context: context,
  );
}
