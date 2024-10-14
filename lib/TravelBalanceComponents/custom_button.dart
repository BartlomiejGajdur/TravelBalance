import 'package:TravelBalance/Utils/custom_snack_bar.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatefulWidget {
  final Future<bool> Function() onPressed;
  final String buttonText;
  final Function() onSuccess;
  final Function() onSkippedSuccess;
  final bool forceLoading;
  final bool skipWaitingForSucces;
  final bool useDefaultPadding;

  const CustomButton({
    super.key,
    required this.buttonText,
    this.onPressed = emptyCallback,
    this.onSuccess = _emptyCallback,
    this.forceLoading = false,
    this.useDefaultPadding = true,
    this.skipWaitingForSucces = false,
    this.onSkippedSuccess = _emptyCallback,
  });

  static Future<bool> emptyCallback() async {
    return false;
  }

  static void _emptyCallback() {}

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isLoading = false;

  void toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  Future<void> handleOnPressed() async {
    if (widget.skipWaitingForSucces) {
      widget.onPressed();
      widget.onSkippedSuccess();
      return;
    }
    toggleLoading();
    try {
      bool success = await widget.onPressed();
      if (success) {
        widget.onSuccess();
      } else {
        showCustomSnackBar(
            context: context,
            message: "Something went wrong :(",
            type: SnackBarType.error);
      }
    } catch (e) {
      showCustomSnackBar(
          context: context, message: e.toString(), type: SnackBarType.error);
    } finally {
      toggleLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: widget.useDefaultPadding ? horizontalPadding : 0.0),
      child: ElevatedButton(
        onPressed: isLoading || widget.forceLoading ? null : handleOnPressed,
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(Size(double.infinity, 56.h)),
          backgroundColor: WidgetStateProperty.all(primaryColor),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonRadius),
            ),
          ),
        ),
        child: isLoading || widget.forceLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: Colors.white,
                ),
              )
            : Text(widget.buttonText, style: buttonTextStyle),
      ),
    );
  }
}
