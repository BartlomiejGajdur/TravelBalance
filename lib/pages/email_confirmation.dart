import 'package:TravelBalance/TravelBalanceComponents/custom_button.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class EmailConfirmation extends StatelessWidget {
  const EmailConfirmation({super.key});

  Future<bool> moveToLogin(BuildContext context) async {
    Navigator.pushNamed(context, "LoginPage");
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "lib/assets/EmailSent.svg",
                    height: 312.h,
                    width: 312.w,
                  ),
                  Text(
                    "Your email is on the way",
                    style: mainTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 23.h),
                  Text(
                    "Thank you for registering! Please check your\nemail and click the activation link to complete\nyour registration.",
                    style: secondaryTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 50.h),
              child: CustomButton(
                onPressed: () => moveToLogin(context),
                buttonText: "Login",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
