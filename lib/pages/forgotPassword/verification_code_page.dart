import 'package:TravelBalance/TravelBalanceComponents/custom_button.dart';
import 'package:TravelBalance/TravelBalanceComponents/custom_text_form_field.dart';
import 'package:TravelBalance/Utils/helper_functions.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerificationCodePage extends StatelessWidget {
  VerificationCodePage({super.key});

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
            child: Text(
                "Enter the verification code that we have sent to your email",
                style: secondaryTextStyle),
          ),
          SizedBox(height: 32.h),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 50.h),
            child: CustomButton(
              buttonText: "Continue",
            ),
          )
        ],
      ),
    );
  }
}
