import 'package:TravelBalance/Utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';

class DoubleLineText extends StatelessWidget {
  final String first;
  final String second;
  final String moveTo;
  const DoubleLineText(
      {super.key,
      required this.first,
      required this.second,
      required this.moveTo});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            color: secondaryTextColor,
          ),
          children: [
            TextSpan(
              text: first,
            ),
            TextSpan(
              text: " $second",
              style:
                  const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushNamed(context, moveTo);
                },
            ),
          ],
        ),
      ),
    );
  }
}
