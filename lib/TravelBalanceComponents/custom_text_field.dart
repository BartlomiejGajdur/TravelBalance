import 'package:TravelBalance/TravelBalanceComponents/choose_category.dart';
import 'package:TravelBalance/Utils/date_picker.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum ClickAction { Date, Category, None }

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? text;
  final IconData? suffixIcon;
  final double? textFieldHorizontalPadding;
  final double? textFieldBottomPadding;
  final ClickAction clickAction;
  final bool numbersOnly;

  const CustomTextField({
    super.key,
    required this.controller,
    this.text,
    this.suffixIcon,
    this.textFieldHorizontalPadding,
    this.textFieldBottomPadding,
    this.clickAction = ClickAction.None,
    this.numbersOnly = false,
  });
  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    super.initState();
    if (widget.text != null) {
      widget.controller.text = widget.text!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.textFieldHorizontalPadding ?? horizontalPadding,
        right: widget.textFieldHorizontalPadding ?? horizontalPadding,
        bottom: widget.textFieldBottomPadding ?? 0.0,
      ),
      child: TextField(
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        readOnly: widget.clickAction != ClickAction.None,
        onTap: () {
          if (widget.clickAction == ClickAction.Date) {
            DateTime? datetime =
                formattedStringInDateTime(widget.controller.text);
            showCustomDatePicker(context, datetime, widget.controller);
          } else if (widget.clickAction == ClickAction.Category) {
            _showCategoryMenu(context);
          }
        },
        controller: widget.controller,
        keyboardType: widget.numbersOnly
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        inputFormatters: widget.numbersOnly
            ? [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ]
            : [],
        decoration: InputDecoration(
          suffixIcon: Icon(widget.suffixIcon),
          suffixIconColor: const Color(0XFF9BA1A8),
          labelStyle: TextStyle(color: Colors.grey[600]),
          hintStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: const Color(0xFF718096),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0XFFE2E8F0), width: 1.0),
            borderRadius: BorderRadius.circular(16.0.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0XFFE2E8F0), width: 2.0),
            borderRadius: BorderRadius.circular(16.0.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0XFFE2E8F0), width: 2.0),
            borderRadius: BorderRadius.circular(16.0.r),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 7.0.h,
            horizontal: 16.0,
          ),
        ),
      ),
    );
  }

  void _showCategoryMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return SizedBox(
            child: ChooseCategory(
          initialCategoryName: widget.controller.text,
          textController: widget.controller,
          onCategoryClick: () => Navigator.of(ctx).pop(),
        ));
      },
    );
  }
}
