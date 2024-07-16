import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanderer/components/category_item.dart';
import 'package:wanderer/components/expense_modal.dart';
import 'package:wanderer/models/expense.dart';

class ExpenseComponent extends StatelessWidget {
  final Expense expense;

  const ExpenseComponent({
    super.key,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0.w),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return ModalBottomSheetExpense(
                expense: expense,
              );
            },
          );
        },
        child: ListTile(
          leading: categoryIcon(expense.category),
          title: Text(expense.title),
          trailing: Text(
            '\$${expense.cost.toStringAsFixed(2)}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
          ),
          subtitle: Text(expense.categoryToString()),
        ),
      ),
    );
  }
}
