import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:TravelBalance/Utils/category_item.dart';
import 'package:TravelBalance/components/expense_modal.dart';
import 'package:TravelBalance/models/expense.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpenseComponent extends StatelessWidget {
  final Expense expense;

  const ExpenseComponent({
    super.key,
    required this.expense,
  });

  String getShorterTitle() {
    String title = expense.title;
    if (title.length > 18) {
      title = title.substring(0, 18);
      title += "...";
    }
    return title;
  }

  String getDateTime() {
    int hour = expense.dateTime.hour;
    int minute = expense.dateTime.minute;
    final String postFix = hour >= 12 ? "PM" : "AM";

    final String hourDateInCorrectFormat =
        (hour % 12 == 0 ? 12 : hour % 12).toString().padLeft(2, '0');
    final String minuteFormatted = minute.toString().padLeft(2, '0');

    return "$hourDateInCorrectFormat:$minuteFormatted $postFix";
  }

  Widget _expenseField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: 336.w,
        height: 89.h,
        decoration: BoxDecoration(
            color: const Color(0xFFFCFCFC),
            borderRadius: BorderRadius.circular(24.r)),
        child: Row(
          children: [
            SizedBox(width: 17.w),
            categoryIcon(expense.category),
            SizedBox(width: 9.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  expense.categoryToString(),
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF292B2D),
                    ),
                  ),
                ),
                SizedBox(height: 13.h),
                Text(
                  getShorterTitle(),
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Color(0xFF91919F),
                    ),
                  ),
                )
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '- \$${expense.cost.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFFFD3C4A),
                    ),
                  ),
                ),
                SizedBox(height: 13.h),
                Text(
                  getDateTime(),
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Color(0xFF91919F),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(width: 17.w),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return ModalBottomSheetExpense(
              expense: expense,
            );
          },
        );
      },
      child: _expenseField(),
    );
  }
}
