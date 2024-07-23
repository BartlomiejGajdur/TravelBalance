import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wanderer/components/category_item.dart';
import 'package:wanderer/models/expense.dart';

class ModalBottomSheetExpense extends StatelessWidget {
  Expense expense;
  ModalBottomSheetExpense({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 600.h,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.close),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        expense.cost.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30.sp),
                      ),
                      Text(
                        expense.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.sp),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Text(expense.dateTime.toString()),
                    ],
                  ),
                  Column(
                    children: [
                      categoryIcon(expense.category, 1.75),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(expense.categoryToString()),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: const Divider(
                  thickness: 1,
                  height: 1,
                ),
              )
            ],
          ),
        ));
  }
}
