import 'package:TravelBalance/TravelBalanceComponents/choose_category.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum ClickAction { Date, Category, None }

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final IconData? suffixIcon;
  final double? textFieldHorizontalPadding;
  final double? textFieldBottomPadding;
  final ClickAction clickAction;
  final Category? expenseCategory;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.text,
    this.suffixIcon,
    this.textFieldHorizontalPadding,
    this.textFieldBottomPadding,
    this.clickAction = ClickAction.None,
    this.expenseCategory,
  }) : assert(clickAction != ClickAction.Category || expenseCategory != null,
            'expenseCategory must be provided when clickAction is Category');

  @override
  Widget build(BuildContext context) {
    controller.text = text;
    return Padding(
      padding: EdgeInsets.only(
        left: textFieldHorizontalPadding ?? horizontalPadding,
        right: textFieldHorizontalPadding ?? horizontalPadding,
        bottom: textFieldBottomPadding ?? 0.0,
      ),
      child: TextField(
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        readOnly: clickAction != ClickAction.None,
        onTap: () {
          if (clickAction == ClickAction.Date) {
            _showDateMenu(context);
          } else if (clickAction == ClickAction.Category) {
            _showCategoryMenu(context, expenseCategory!);
          }
        },
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: Icon(suffixIcon),
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

  void _showDateMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return SizedBox(
          height: 200.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.date_range),
                title: const Text('Today'),
                onTap: () {
                  Navigator.pop(context);
                  controller.text = "07/10/2024";
                },
              ),
              ListTile(
                leading: const Icon(Icons.date_range),
                title: const Text('Yesterday'),
                onTap: () {
                  Navigator.pop(context);
                  controller.text = "06/10/2024";
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Anuluj'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

//Navigator.pop(context);
  void _showCategoryMenu(BuildContext context, Category category) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return SizedBox(child: ChooseCategory(choosenCategory: category, textController: controller,));
      },
    );
  }
}
