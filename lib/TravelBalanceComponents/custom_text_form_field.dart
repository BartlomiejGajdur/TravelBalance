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

import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final String labelText;
  final String hintText;
  final String? Function(String?)? validator;
  final Icon? prefixIcon;
  final bool toggleText; 

  const CustomTextFormField({super.key, 
    required this.controller,
    required this.formKey,
    required this.labelText,
    required this.hintText,
    this.prefixIcon,
    this.validator,
    this.toggleText = false, 
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
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.toggleText ? !showText : false, 
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.toggleText
            ? IconButton(
                icon: Icon(showText ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    showText = !showText; 
                  });
                },
              )
            : null, 
        labelText: widget.labelText,
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.green, width: 2.0),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 5, 99, 33), width: 2.0),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: widget.validator ?? defaultValidator,
      onChanged: (value) => defaultOnChanged(value),
    );
  }
}
