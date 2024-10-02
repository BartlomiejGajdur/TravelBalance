import 'package:TravelBalance/Utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget imagePicker({VoidCallback func = _defaultFunc}) {
  return GestureDetector(
    onTap: func,
    child: Container(
      height: 91.h,
      width: 107.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: const Color(0xFF92A332).withOpacity(0.2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image, size: 32.h, color: thirdColor),
          const SizedBox(height: 8),
          Text(
            "Image",
            style: GoogleFonts.outfit(fontSize: 16.sp, color: thirdColor),
          ),
        ],
      ),
    ),
  );
}

void _defaultFunc() {
  debugPrint("Debug from Create Trip Page");
}
