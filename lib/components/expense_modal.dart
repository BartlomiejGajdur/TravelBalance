import 'package:TravelBalance/TravelBalanceComponents/custom_text_field.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:TravelBalance/models/expense.dart';
import 'package:google_fonts/google_fonts.dart';

class ModalBottomSheetExpense extends StatefulWidget {
  final Expense expense;
  const ModalBottomSheetExpense({super.key, required this.expense});

  @override
  State<ModalBottomSheetExpense> createState() =>
      _ModalBottomSheetExpenseState();
}

class _ModalBottomSheetExpenseState extends State<ModalBottomSheetExpense> {
  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController costController = TextEditingController();

  final TextEditingController dateController = TextEditingController();

  final TextEditingController categoryController = TextEditingController();

  @override
  void dispose() {
    descriptionController.dispose();
    costController.dispose();
    dateController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  String formattedDateTime(DateTime datetime) {
    return "${datetime.day}/${datetime.month}/${datetime.year}";
  }

  Widget formattedTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 4.h),
      child: Text(
        title,
        style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: const Color(0xFF0D0E0F)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 493.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 10.h, 10.w, 0.0),
              child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  )),
            ),
            formattedTitle("Description"),
            CustomTextField(
                text: widget.expense.title,
                controller: descriptionController,
                textFieldBottomPadding: 16.0.h),
            formattedTitle("Cost"),
            CustomTextField(
                text: widget.expense.cost.toString(),
                controller: costController,
                textFieldBottomPadding: 16.0.h,
                suffixIcon: Icons.monetization_on_outlined),
            formattedTitle("Date"),
            CustomTextField(
                text: formattedDateTime(widget.expense.dateTime),
                controller: dateController,
                textFieldBottomPadding: 16.0.h,
                suffixIcon: Icons.calendar_month_outlined,
                clickAction: ClickAction.Date,),
            formattedTitle("Category"),
            CustomTextField(
                text: widget.expense.categoryToString(),
                controller: categoryController,
                textFieldBottomPadding: 16.0.h,
                suffixIcon: Icons.category,
                clickAction: ClickAction.Category),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 56.h,
                    width: 67.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: redWarningColor.withOpacity(0.2)),
                    child: Icon(
                      Icons.delete_forever_sharp,
                      size: 40.h,
                      color: redWarningColor,
                    ),
                  ),
                ),
                SizedBox(width: 11.w),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 56.h,
                    width: 273.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: primaryColor),
                    child: Text("Save Expense", style: buttonTextStyle),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
