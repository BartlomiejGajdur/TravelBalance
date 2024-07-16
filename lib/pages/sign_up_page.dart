import 'package:flutter/material.dart';
import 'package:wanderer/components/globals.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SignUpPage"),
        backgroundColor: leadingColor,
      ),
    );
  }
}
