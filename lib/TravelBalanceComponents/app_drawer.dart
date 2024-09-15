import 'package:TravelBalance/services/api_service.dart';
import 'package:TravelBalance/services/google_signin_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/providers/user_provider.dart';
import 'package:TravelBalance/pages/login_page.dart';

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
            clickableListTile(context, "Currency"),
            clickableListTile(context, "Change password"),
            clickableListTile(context, "Send feedback"),
            clickableListTile(context, "About"),
            clickableListTile(context, "Help"),
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

  Widget clickableListTile(BuildContext context, String givenText,
      [String? moveTo]) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        if (moveTo != null) {
          Navigator.pushNamed(context, moveTo);
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
