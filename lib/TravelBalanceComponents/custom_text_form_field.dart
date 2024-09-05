/*
@@@<NAME>_PAGE@@@
  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
@@@@@@@@@@@

@@@Usage@@@
CustomTextFormField(
    controller: controller,
    formKey: formKey, 
    labelText: 'Username',
    hintText: 'Please write a username',
    prefixIcon: Icon(Icons.percent),
    toggleText: true),
@@@@@@@@@@@

*/

import 'package:TravelBalance/Utils/globals.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final String labelText;
  final String hintText;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final bool toggleText;
  final double? textFieldHorizontalPadding;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.formKey,
    required this.labelText,
    required this.hintText,
    this.prefixIcon,
    this.validator,
    this.toggleText = false,
    this.textFieldHorizontalPadding,
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool showText = false;

  String? defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (value.length != value.replaceAll(' ', '').length) {
      return 'Input must not contain any spaces';
    }
    return null;
  }

  void defaultOnChanged(String value) {
    final FormState? form = widget.formKey.currentState;
    if (form != null) {
      form.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: widget.textFieldHorizontalPadding ?? horizontalPadding),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.toggleText ? !showText : false,
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.prefixIcon,
            color: Colors.grey[600],
          ),
          suffixIcon: widget.toggleText
              ? IconButton(
                  icon: Icon(
                    showText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    setState(() {
                      showText = !showText;
                    });
                  },
                )
              : null,
          labelText: widget.labelText,
          labelStyle: TextStyle(color: Colors.grey[600]),
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green, width: 2.0),
            borderRadius: BorderRadius.circular(textFieldRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryColor, width: 2.0),
            borderRadius: BorderRadius.circular(textFieldRadius),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(textFieldRadius),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
            borderRadius: BorderRadius.circular(textFieldRadius),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18.0),
        ),
        validator: widget.validator ?? defaultValidator,
        onChanged: (value) => defaultOnChanged(value),
      ),
    );
  }
}
