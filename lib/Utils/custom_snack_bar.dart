import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

enum SnackBarType { error, warning, information, correct, none }

void showCustomSnackBar({
  required BuildContext context,
  required String message,
  SnackBarType type = SnackBarType.none,
}) {
  AnimatedSnackBarType snackBarType;

  switch (type) {
    case SnackBarType.error:
      snackBarType = AnimatedSnackBarType.error;
      break;
    case SnackBarType.warning:
      snackBarType = AnimatedSnackBarType.warning;
      break;
    case SnackBarType.information:
      snackBarType = AnimatedSnackBarType.info;
      break;
    case SnackBarType.correct:
      snackBarType = AnimatedSnackBarType.success;
      break;
    case SnackBarType.none:
      snackBarType = AnimatedSnackBarType.info;
      break;
  }

  AnimatedSnackBar.material(
    message,
    type: snackBarType,
    mobileSnackBarPosition:
        MobileSnackBarPosition.top, // Dolna pozycja na ekranie
    desktopSnackBarPosition:
        DesktopSnackBarPosition.topRight, // Pozycja na desktopie
    duration: const Duration(seconds: 4), // Czas wyświetlania
  ).show(context);
}
