import 'dart:async'; // Importuje Timer z dart:async
import 'package:TravelBalance/TravelBalanceComponents/custom_button.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class VerificationCodePage extends StatefulWidget {
  final String email;
  const VerificationCodePage({super.key, required this.email});

  @override
  _VerificationCodePageState createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  late Timer _timer;
  int _start = 120;
  bool isResend = false;
  String verificationCode = "";

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
          isResend = true;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  Future<void> _handleResend() async {
    if (isResend) {
      ApiService().forgotPassword(widget.email);
      setState(() {
        _start = 120;
        isResend = false;
      });
      _startTimer();
    }
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
    return "$minutes:$formattedSeconds";
  }

  Future<bool> validateVerificationCode(String verificationCode) async {
    return await ApiService()
        .validateVerificationCode(widget.email, verificationCode);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String timerText =
        isResend ? "Send again!" : "Send again in ${formatTime(_start)}";
    TextStyle timerStyle = isResend
        ? const TextStyle(color: primaryColor, fontWeight: FontWeight.bold)
        : const TextStyle(color: secondaryTextColor, fontWeight: FontWeight.normal);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: horizontalPadding),
            child: Text("Verification Code", style: mainTextStyle),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: RichText(
              text: TextSpan(
                style: secondaryTextStyle,
                children: [
                  const TextSpan(
                    text: "Enter the verification code that we have sent to",
                  ),
                  TextSpan(
                      text: " ${widget.email}",
                      style: const TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          SizedBox(height: 32.h),
          Align(
            alignment: Alignment.center,
            child: Pinput(
              length: 5,
              onCompleted: (value) => verificationCode = value,
            ),
          ),
          SizedBox(height: 18.h),
          Align(
            alignment: Alignment.center,
            child: RichText(
              text: TextSpan(
                style: secondaryTextStyle,
                children: [
                  const TextSpan(
                    text: "Did not receive the code? ",
                  ),
                  TextSpan(
                    text: timerText,
                    style: timerStyle,
                    recognizer: TapGestureRecognizer()..onTap = _handleResend,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 50.h),
            child: CustomButton(
              buttonText: "Continue",
              onPressed: () => validateVerificationCode(verificationCode),
              onSuccess: () => Navigator.pushNamed(
                context,
                "CreateNewPasswordPage",
                arguments: {
                  'email': widget.email,
                  'verificationCode': verificationCode,
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
