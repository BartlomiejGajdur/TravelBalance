import 'package:TravelBalance/TravelBalanceComponents/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerificationCodePage extends StatelessWidget {
  final String email;
  const VerificationCodePage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: horizontalPadding),
            child: Text("Verification Code", style: mainTextStyle),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: RichText(
              text: TextSpan(
                style: secondaryTextStyle,
                children: [
                  const TextSpan(
                    text: "Enter the verification code that we have sent to",
                  ),
                  TextSpan(
                      text: " $email",
                      style: const TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold))
                ],
              ),
            ),
          ),
          SizedBox(height: 32.h),
          const Spacer(),
          ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                    context,
                    "CreateNewPasswordPage",
                    arguments: {
                      'email': email,
                      'verificationCode': "12344",
                    },
                  ),
              child: const Text("[Debug] Przejdz dalej")),
          Padding(
            padding: EdgeInsets.only(bottom: 50.h),
            child: const CustomButton(
              buttonText: "Continue",
            ),
          )
        ],
      ),
    );
  }
}
