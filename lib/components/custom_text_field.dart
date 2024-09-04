import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Utils/globals.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  final Color cursorColor;
  final Color borderColor;
  final double borderRadius;
  final Color shadowColor;
  final double shadowBlurRadius;
  final double shadowSpreadRadius;
  final Offset shadowOffset;
  final double horizontalPadding;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.obscureText,
    required this.horizontalPadding,
    this.cursorColor = primaryColor,
    this.borderColor = Colors.grey,
    this.borderRadius = 24.0,
    this.shadowColor = Colors.grey,
    this.shadowBlurRadius = 5.0,
    this.shadowSpreadRadius = 2.0,
    this.shadowOffset = const Offset(0, 3),
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 4.0.h),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.5),
              spreadRadius: shadowSpreadRadius,
              blurRadius: shadowBlurRadius,
              offset: shadowOffset,
            ),
          ],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 1.0.w),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: cursorColor, width: 2.0.w),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            suffixIcon: suffixIcon,
          ),
          cursorColor: cursorColor,
        ),
      ),
    );
  }
}
