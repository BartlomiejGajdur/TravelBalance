import 'package:TravelBalance/Utils/globals.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final bool toggleText;
  final double? textFieldHorizontalPadding;

  const CustomTextFormField({
    super.key,
    required this.controller,
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.textFieldHorizontalPadding ??
            horizontalPadding, // default padding
      ),
      child: TextFormField(
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        controller: widget.controller,
        obscureText: widget.toggleText ? !showText : false,
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: Colors.grey[600])
              : null,
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
            borderSide: const BorderSide(color: secondaryColor, width: 2.0),
            borderRadius: BorderRadius.circular(8.0), // radius for text field
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: secondaryColor, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          // Adds left padding when there's no prefixIcon
          contentPadding: widget.prefixIcon == null
              ? const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0)
              : const EdgeInsets.symmetric(vertical: 18.0),
        ),
        validator: widget.validator ?? defaultValidator,
        onChanged: (value) {
          final FormState form = Form.of(context);
          form.validate();
        },
      ),
    );
  }
}
