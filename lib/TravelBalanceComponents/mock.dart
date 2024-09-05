import 'package:TravelBalance/Utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// Import dla ikon FontAwesome

enum ButtonType { Google, Apple }

class MockButton extends StatelessWidget {
  final ButtonType buttonType;

  const MockButton({super.key, required this.buttonType});

  @override
  Widget build(BuildContext context) {
    // Ustalanie stylu przycisku w zależności od typu
    final Color backgroundColor =
        buttonType == ButtonType.Google ? Colors.white : Colors.black;
    final Color textColor =
        buttonType == ButtonType.Google ? Colors.black : Colors.white;

    final String text = buttonType == ButtonType.Google
        ? 'Sign in with Google'
        : 'Sign in with Apple';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius:
              BorderRadius.circular(buttonRadius), // Dodajemy zaokrąglenia
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Wyśrodkowanie zawartości
          children: [
            if (buttonType == ButtonType.Google)
              const FaIcon(FontAwesomeIcons.google, color: Colors.red)
            else
              Icon(Icons.apple, size: 24.sp, color: textColor),
            SizedBox(width: 8.w), // Odstęp między ikoną a tekstem
            Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: textColor, // Kolor tekstu
              ),
            ),
          ],
        ),
      ),
    );
  }
}
