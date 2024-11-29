import 'package:TravelBalance/providers/trip_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:TravelBalance/TravelBalanceComponents/expense_component.dart';
import 'package:TravelBalance/models/expense.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ExpenseSheetComponent extends StatelessWidget {
  final DateTime dateTime;

  const ExpenseSheetComponent({
    super.key,
    required this.dateTime,
  });

  String _getDisplayDate() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));

    if (dateTime.isAtSameMomentAs(today)) {
      return 'Today';
    } else if (dateTime.isAtSameMomentAs(yesterday)) {
      return 'Yesterday';
    } else {
      return '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TripProvider>(
      builder: (context, tripProvider, child) {
        List<Expense> expenses =
            tripProvider.trip.groupExpensesByDate()[dateTime] ?? [];

        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                child: Text(
                  _getDisplayDate(),
                  style: GoogleFonts.inter(
                      fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ),
              for (var expense in expenses)
                Slidable(
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          tripProvider.deleteExpense(expense.getId());
                        },
                        backgroundColor: const Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: ExpenseComponent(
                    key: ValueKey(expense.getId()),
                    expense: expense,
                    tripProvider: tripProvider,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
