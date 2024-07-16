
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanderer/components/expense_component.dart';
import 'package:wanderer/models/expense.dart';

class ExpenseSheetComponent extends StatelessWidget {
  final List<Expense> expenses;
  final DateTime dateTime;
  final String yearMonthDayString;

  ExpenseSheetComponent({
    super.key,
    required this.expenses,
    required this.dateTime,
  })  : yearMonthDayString =
            '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0.r),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(2, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 12.0.h),
              child: Text(
                yearMonthDayString,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
            ),
            for (var expense in expenses) ExpenseComponent(expense: expense),
          ],
        ),
      ),
    );
  }
}
