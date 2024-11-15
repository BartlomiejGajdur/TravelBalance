import 'package:TravelBalance/TravelBalanceComponents/custom_button.dart';
import 'package:TravelBalance/TravelBalanceComponents/custom_text_form_field.dart';
import 'package:TravelBalance/Utils/blur_dialog.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  Future<bool> resetPassword() async {
    if (formKey.currentState?.validate() ?? false) {
      final oldPassword = oldPasswordController.text;
      final newPassword = newPasswordController.text;
      final newPasswordRepeated = repeatPasswordController.text;
      //testowehaslo123
      if (newPasswordController.text != repeatPasswordController.text) {
        throw "Passwords do not match!";
      }

      return await ApiService()
          .changePassword(oldPassword, newPassword, newPasswordRepeated);
    } else {
      throw "Check input errors!";
    }
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (value.length != value.replaceAll(' ', '').length) {
      return 'Input must not contain any spaces';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
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
              child: Text("Change Password", style: mainTextStyle),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                "Time for a fresh start! Create a new password to keep your travel journey secure.",
                style: secondaryTextStyle,
              ),
            ),
            SizedBox(height: 32.h),
            CustomTextFormField(
              controller: oldPasswordController,
              labelText: 'Old password',
              hintText: 'Enter your password',
              prefixIcon: Icons.lock,
              toggleText: true,
              validator: passwordValidator,
            ),
            SizedBox(height: 12.h),
            CustomTextFormField(
              controller: newPasswordController,
              labelText: 'New Password',
              hintText: 'Enter your new password',
              prefixIcon: Icons.lock,
              toggleText: true,
              validator: passwordValidator,
            ),
            SizedBox(height: 12.h),
            CustomTextFormField(
              controller: repeatPasswordController,
              labelText: 'Confirm New Password',
              hintText: 'Re-enter your new password',
              prefixIcon: Icons.lock,
              toggleText: true,
              validator: passwordValidator,
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 50.h),
              child: CustomButton(
                buttonText: "Change Password",
                onPressed: () => resetPassword(),
                onSuccess: () => showPasswordUpdateDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showPasswordUpdateDialog(BuildContext context) {
  showBlurDialog(
    context: context,
    barrierDismissible: false,
    childBuilder: (ctx) => SizedBox(
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
            "Password Updated!",
            style: mainTextStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            "Your password has been successfully updated.\nYou're all set to continue your journey!",
            style: secondaryTextStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          CustomButton(
            buttonText: "Back to Travel Balance",
            onPressed: () async {
              return true;
            },
            onSuccess: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
          SizedBox(height: 25.h),
        ],
      ),
    ),
  );
}
