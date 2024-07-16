import 'package:flutter/material.dart';
import 'package:wanderer/components/globals.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ForgotPasswordPage"),
        backgroundColor: leadingColor,
      ),
    );
  }
}
