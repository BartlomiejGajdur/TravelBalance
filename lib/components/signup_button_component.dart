import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wanderer/pages/login_page.dart';

class SignupButtonComponent extends StatefulWidget {
  final Future<bool> Function() onClick;
  const SignupButtonComponent({super.key, required this.onClick});

  @override
  State<SignupButtonComponent> createState() => _SignupButtonComponentState();
}

class _SignupButtonComponentState extends State<SignupButtonComponent> {
  bool isLoading = false;

  void toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void showResultDialog(BuildContext context, bool result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: 335.w,
            height: 413.h,
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  result ? "lib/assets/SignedUp.png" : "lib/assets/error.png",
                  height: 181.h,
                  width: 181.w,
                ),
                Text(
                  result
                      ? "Registration Successful!"
                      : "Registration Unsuccessful!",
                  style: GoogleFonts.montserrat(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  result
                      ? "You have successfully registered.\nPlease activate your account by clicking the link in the email we sent."
                      : "Well... Something went wrong. Sorry :)",
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF656565),
                  ),
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (result) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    }
                  },
                  style: ButtonStyle(
                    minimumSize:
                        WidgetStateProperty.all(Size(double.infinity, 50.h)),
                    backgroundColor: WidgetStateProperty.all(Colors.green[400]),
                  ),
                  child: Text(
                    'CONTINUE',
                    style: GoogleFonts.montserrat(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: ElevatedButton(
        onPressed: () async {
          toggleLoading();
          bool result = await widget.onClick();
          toggleLoading();
          showResultDialog(context, result);
        },
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(Size(double.infinity, 50.h)),
          backgroundColor: WidgetStateProperty.all(Colors.green[400]),
        ),
        child: isLoading
            ? SizedBox(
                width: 24.w,
                height: 24.h,
                child: CircularProgressIndicator(
                  color: Colors.white, // Kolor kółka ładowania
                  strokeWidth: 2.0.w,
                ),
              )
            : const Text(
                "SIGNUP",
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
