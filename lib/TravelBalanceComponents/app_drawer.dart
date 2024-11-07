import 'package:TravelBalance/TravelBalanceComponents/custom_button.dart';
import 'package:TravelBalance/Utils/blur_dialog.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:TravelBalance/services/google_signin_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/providers/user_provider.dart';
import 'package:TravelBalance/pages/login_page.dart';

enum Option {
  currency,
  changePassword,
  sendFeedback,
  about,
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300.w,
      child: SafeArea(
        bottom: true,
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Text(
              "Hey, Captain of Control!",
              style: GoogleFonts.outfit(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: mainTextColor,
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              "Feel like tweaking something?\nUpdate your settings here - your app, your rules!",
              style: GoogleFonts.outfit(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 21.w),
              child: const Divider(color: Color(0xFFD9D9D9)),
            ),
            SizedBox(height: 15.h),
            SvgPicture.asset(
              "lib/assets/TwoGuysOneTent.svg",
              height: 214.h,
              width: 270.w,
            ),
            SizedBox(height: 53.h),
            clickableListTile(context, "Currency", Option.currency),
            clickableListTile(
                context, "Change password", Option.changePassword),
            clickableListTile(context, "Send feedback", Option.sendFeedback),
            clickableListTile(context, "About", Option.about),
            const Spacer(), // Użyj Spacer, aby wypchnąć SVG na dół
            Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                  final tokenType = ApiService().getToken();
                  if (tokenType == BaseTokenType.Token) {
                    Provider.of<UserProvider>(context, listen: false).logout();
                  } else if (tokenType == BaseTokenType.Bearer) {
                    GoogleSignInApi().logout(context);
                  }
                },
                child: SvgPicture.asset(
                  "lib/assets/Logout.svg",
                  height: 27.h,
                  width: 114.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget clickableListTile(
      BuildContext context, String givenText, Option option,
      [String? moveTo]) {
    return GestureDetector(
      onTap: () {
        switch (option) {
          case Option.currency:
            showCurrency(context);
            break;
          case Option.changePassword:
            moveToChangePassword(context);
            break;
          case Option.sendFeedback:
            showSendFeedback(context);
            break;
          case Option.about:
            showAbout(context);
            break;

          default:
        }
      },
      child: ListTile(
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: secondaryColor,
        ),
        title: Text(
          givenText,
          style: GoogleFonts.outfit(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: mainTextColor,
          ),
        ),
      ),
    );
  }
}

void showAbout(BuildContext context) {
  showBlurDialog(
      context: context,
      childBuilder: (ctx) {
        return Container(
          padding: EdgeInsets.all(0),
          width: 335.w,
          height: 300.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "About Travel Balance",
                style: GoogleFonts.outfit(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: mainTextColor,
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.0.w),
                child: Text(
                  "Travel Balance is an app designed to simplify expense management during your travels. It helps you monitor costs, manage budgets, and log travel-related expenses effortlessly. Our goal is to provide a convenient tool for tracking expenses across different countries, making it easier to manage your finances on the go.",
                  style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF718096),
                      letterSpacing: 0.3),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        );
      });
}

void showSendFeedback(BuildContext context) {
  final TextEditingController feedbackController = TextEditingController();
  final int maxLength = 200;
  showBlurDialog(
      context: context,
      childBuilder: (ctx) {
        return Container(
          padding: EdgeInsets.all(0),
          width: 335.w,
          height: 450.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 25.h),
              Text(
                "Share your feedback",
                style: GoogleFonts.outfit(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: mainTextColor,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.0.w),
                child: Text(
                  "We value your input! Let us know how we can improve.",
                  style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF718096),
                      letterSpacing: 0.3),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 17.0.w),
                  child: TextField(
                    maxLength: maxLength,
                    controller: feedbackController,
                    minLines: 8,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText:
                          "How’s the app treating you? Found any hidden travel gems yet?",
                      hintStyle: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF718096),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: primaryColor, width: 1.0),
                        borderRadius: BorderRadius.circular(16.0.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: secondaryColor, width: 2.0),
                        borderRadius: BorderRadius.circular(16.0.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 7.0.h,
                        horizontal: 16.0,
                      ),
                    ),
                  )),
              SizedBox(height: 4.h),
              CustomButton(buttonText: "Send Feedback")
              // Wyświetlamy liczbę znaków
            ],
          ),
        );
      });
}

void moveToChangePassword(BuildContext context) {}

void showCurrency(BuildContext context) {}
