import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Definicja enum dla różnych typów SnackBar
enum SnackBarType { error, warning, information, correct, none }

void showCustomSnackBar({
  required BuildContext context,
  required String message,
  SnackBarType type = SnackBarType.none,
}) {
  Color backgroundColor;

  switch (type) {
    case SnackBarType.error:
      backgroundColor = Colors.red;
      break;
    case SnackBarType.warning:
      backgroundColor = Colors.orange;
      break;
    case SnackBarType.information:
      backgroundColor = Colors.blue;
      break;
    case SnackBarType.correct:
      backgroundColor = Colors.green;
      break;
    case SnackBarType.none:
      backgroundColor = Colors.grey;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      duration: const Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0.r),
      ),
      margin: EdgeInsets.all(16.0.w),
    ),
  );
}
