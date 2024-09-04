import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

//AppColors
const Color primaryColor = Color(0xFF56642A);
const Color secondaryColor = Color(0xFF849531);
const Color thirdColor = Color(0xFF92A332);
const Color mainTextColor = Color(0xFF192048);
const Color secondaryTextColor = Color(0xFF575555);
const Color redWarningColor = Color(0xFFED5E68);
const Color buttonTextColor = Colors.white;
// Button Text Style with Google Fonts
TextStyle buttonTextStyle = GoogleFonts.outfit(
  fontSize: 18.sp,
  fontWeight: FontWeight.bold,
  color: buttonTextColor,
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

double buttonHorizontalPadding = 22.w;
