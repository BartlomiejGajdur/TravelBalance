import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

//Default Currency
String defaultCurrencyCode = "USD";
Currency defaultCurrency = CurrencyService().findByCode(defaultCurrencyCode)!;

//Background TravelBalance Pro page
String TravelBalanceProBackgroundPath = "lib/assets/ProPageBackground.png";

//AppColors
const Color primaryColor = Color(0xFF56642A);
const Color secondaryColor = Color(0xFF849531);
const Color thirdColor = Color(0xFF92A332);
const Color mainTextColor = Color(0xFF192048);
const Color secondaryTextColor = Color(0xFF575555);
const Color redWarningColor = Color(0xFFED5E68);
const Color premiumColor = Color(0xFF1591EA);
const Color buttonTextColor = Colors.white;

// Button Text Style with Google Fonts
TextStyle buttonTextStyle = GoogleFonts.outfit(
  fontSize: 18.sp,
  fontWeight: FontWeight.bold,
  color: buttonTextColor,
);

TextStyle buttonTextStyle_2 = GoogleFonts.outfit(
  fontSize: 18.sp,
  fontWeight: FontWeight.bold,
  color: mainTextColor,
);

TextStyle mainTextStyle = GoogleFonts.outfit(
  fontSize: 24.sp,
  fontWeight: FontWeight.bold,
  color: mainTextColor,
);

TextStyle secondaryTextStyle = GoogleFonts.outfit(
  fontSize: 16.sp,
  color: secondaryTextColor,
);

//Headers
TextStyle mainHeaderTextStyle = GoogleFonts.outfit(
  fontSize: 30.sp,
  fontWeight: FontWeight.w800,
  color: Colors.white,
);

TextStyle secondaryHeaderTextStyle = GoogleFonts.outfit(
  fontSize: 14.sp,
  fontWeight: FontWeight.w500,
  color: Colors.white,
);

double buttonHorizontalPadding = 22.w;
double horizontalPadding = 28.w;
double buttonRadius = 16.r;
double textFieldRadius = 16.r;
