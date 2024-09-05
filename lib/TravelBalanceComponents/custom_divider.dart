import 'package:TravelBalance/Utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDivider extends StatelessWidget {
  final String text;
  final double lineThickness;

  const CustomDivider({
    super.key,
    required this.text,
    this.lineThickness = 1.0, // Domyślna grubość linii
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: const Color(0xFFE2E8F0),
              thickness: lineThickness,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
            child: Text(
              text,
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                color: const Color(0xFF4A5568),
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: const Color(0xFFE2E8F0),
              thickness: lineThickness,
            ),
          ),
        ],
      ),
    );
  }
}
