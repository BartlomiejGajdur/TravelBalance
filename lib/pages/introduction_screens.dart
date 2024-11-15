import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/services/shared_prefs_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroductionPage extends StatelessWidget {
  IntroductionPage({super.key});

  void goToLoginPage(BuildContext context) async {
    SharedPrefsStorage().setBool('wasIntroductionScreenShown', true);
    Navigator.pushNamed(context, "LoginPage");
  }

  final TextStyle titleStyle = GoogleFonts.outfit(
    fontSize: 32.sp,
    fontWeight: FontWeight.w600,
    color: primaryColor,
  );

  final TextStyle bodyStyle = GoogleFonts.outfit(
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF575555),
  );

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: "Create Your Trip",
          body:
              "Start your adventure by creating a new trip. Add a name, upload a cover photo, and write a brief description to set the tone for your journey.",
          image: SvgPicture.asset("lib/assets/IntroductionScreen_1.svg"),
          decoration: PageDecoration(
              titleTextStyle: titleStyle,
              bodyTextStyle: bodyStyle,
              imagePadding: EdgeInsets.only(top: 51.0.h)),
        ),
        PageViewModel(
          title: "Track Your Expenses",
          body:
              "Easily track your travel expenses by categorizing them, like accommodation, food, and transport. Keep your budget in check by logging every purchase.",
          image: SvgPicture.asset("lib/assets/IntroductionScreen_2.svg"),
          decoration: PageDecoration(
              titleTextStyle: titleStyle,
              bodyTextStyle: bodyStyle,
              imagePadding: EdgeInsets.only(top: 51.0.h)),
        ),
        PageViewModel(
          title: "View Trip Statistics ",
          body:
              "Get an overview of your spending with detailed statistics. See expenses by category, compare with your budget, and gain insights into your travel habits.",
          image: SvgPicture.asset("lib/assets/IntroductionScreen_3.svg"),
          decoration: PageDecoration(
              titleTextStyle: titleStyle,
              bodyTextStyle: bodyStyle,
              imagePadding: EdgeInsets.only(top: 51.0.h)),
        ),
      ],
      onDone: () => goToLoginPage(context),
      onSkip: () => goToLoginPage(context),
      showSkipButton: true,
      skip: const Text("Skip", style: TextStyle(color: secondaryColor)),
      next: const Icon(Icons.arrow_forward, color: primaryColor),
      done: const Text("Get Started",
          style: TextStyle(fontWeight: FontWeight.w600, color: secondaryColor)),
      curve: Curves.fastLinearToSlowEaseIn,
      dotsDecorator: const DotsDecorator(
        activeColor: primaryColor,
        color: Colors.grey,
        spacing: EdgeInsets.symmetric(horizontal: 3.0),
        size: Size(10.0, 10.0),
        activeSize: Size(12.0, 12.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
