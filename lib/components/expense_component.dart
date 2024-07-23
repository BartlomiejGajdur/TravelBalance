import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:TravelBalance/components/category_item.dart';
import 'package:TravelBalance/components/expense_modal.dart';
import 'package:TravelBalance/models/expense.dart';

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
