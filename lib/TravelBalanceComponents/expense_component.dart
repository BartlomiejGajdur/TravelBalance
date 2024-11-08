import 'package:TravelBalance/providers/expense_provider.dart';
import 'package:TravelBalance/providers/trip_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:TravelBalance/Utils/category_item.dart';
import 'package:TravelBalance/components/expense_modal.dart';
import 'package:TravelBalance/models/expense.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ExpenseComponent extends StatelessWidget {
  final Expense expense;
  final TripProvider tripProvider;
  const ExpenseComponent(
      {super.key, required this.expense, required this.tripProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpenseProvider(expense, tripProvider),
      child: Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, child) {
          return GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return ModalBottomSheetExpense(
                    expenseProvider: expenseProvider,
                  );
                },
              );
            },
            child: _expenseField(expenseProvider),
          );
        },
      ),
    );
  }

  Widget _expenseField(ExpenseProvider expenseProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: 336.w,
        height: 89.h,
        decoration: BoxDecoration(
          color: const Color(0xFFFCFCFC),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          children: [
            SizedBox(width: 17.w),
            categoryIcon(expenseProvider.expense.category),
            SizedBox(width: 9.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  expenseProvider.expense.categoryToString(),
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
                  getShorterTitle(expenseProvider),
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
            SizedBox(
              height: 89.h,
              width: 105.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '- ${expenseProvider.expense.currency.symbol}${expenseProvider.expense.cost.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFFFD3C4A),
                      ),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 13.h),
                  Text(
                    getDateTime(expenseProvider),
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
            ),
            SizedBox(width: 17.w),
          ],
        ),
      ),
    );
  }

  String getShorterTitle(ExpenseProvider expenseProvider) {
    String title = expenseProvider.expense.title;
    if (title.length > 15) {
      title = title.substring(0, 15);
      title += "...";
    }
    return title;
  }

  String getDateTime(ExpenseProvider expenseProvider) {
    int hour = expenseProvider.expense.dateTime.hour;
    int minute = expenseProvider.expense.dateTime.minute;
    final String postFix = hour >= 12 ? "PM" : "AM";

    final String hourDateInCorrectFormat =
        (hour % 12 == 0 ? 12 : hour % 12).toString().padLeft(2, '0');
    final String minuteFormatted = minute.toString().padLeft(2, '0');

    return "$hourDateInCorrectFormat:$minuteFormatted $postFix";
  }
}
