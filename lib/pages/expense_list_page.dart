import 'dart:math';

import 'package:TravelBalance/TravelBalanceComponents/edit_trip.dart';
import 'package:TravelBalance/TravelBalanceComponents/no_content_message.dart';
import 'package:TravelBalance/Utils/custom_scaffold.dart';
import 'package:TravelBalance/TravelBalanceComponents/expense_sheet_component.dart';
import 'package:TravelBalance/models/expense.dart';
import 'package:TravelBalance/providers/trip_provider.dart';
import 'package:flutter/material.dart';
import 'package:TravelBalance/models/trip.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ExpenseListPage extends StatelessWidget {
  final Trip trip;
  final int indexInList;

  Widget _buildGraphWidget(TripProvider tripProvider) {
    return SizedBox(
      width: double.infinity,
      height: 250.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 200.w,
            height: 200.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000), color: Colors.green),
          ),
          Container(
            width: 160.w,
            height: 160.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000), color: Colors.white),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("\$${tripProvider.trip.tripCost}"),
              const Text("Current Spending")
            ],
          ),
        ],
      ),
    );
  }

  void addExpense(TripProvider tripProvider) {
    // For tests. Should take values from add Page and add corresponding expense
    final random = Random();

    int categoryIndex = random.nextInt(Category.values.length);
    Category randomCategory = Category.values[categoryIndex];

    int dateOffset = random.nextInt(3);
    DateTime selectedDate = DateTime.now().subtract(Duration(days: dateOffset));

    final newExpense = Expense(
      id: 1,
      title: "BARDZO DLUGA NAZWA O JAPIER ALE DLUGA KURWRWRWRW",
      cost: 23.0,
      category: randomCategory,
      dateTime: selectedDate,
    );

    tripProvider.addExpense(newExpense);
  }

  const ExpenseListPage(
      {super.key, required this.trip, required this.indexInList});
  @override
  Widget build(BuildContext context) {
    final tripProvider = Provider.of<TripProvider>(context);
    return CustomScaffold(
      text1: trip.name,
      text2: "Discover your travel costs.",
      onActionButtonClick: () => addExpense(tripProvider),
      onEditIconClick: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: EditTrip(
                tripProvider: tripProvider,
                indexInList: indexInList,
              ),
            );
          },
        );
      },
      childWidget: Column(
        children: [
          if (!tripProvider.isExpenseListEmpty())
            _buildGraphWidget(tripProvider),
          tripProvider.isExpenseListEmpty()
              ? noContentMessage(ContentType.Expenses)
              : Expanded(
                  // Wrap the ListView in an Expanded widget
                  child: ListView.builder(
                    itemCount: tripProvider.trip.expensesByDate.length,
                    itemBuilder: (context, index) {
                      DateTime date =
                          tripProvider.trip.expensesByDate.keys.toList()[index];
                      List<Expense> expenses =
                          tripProvider.trip.expensesByDate[date]!;
                      return ExpenseSheetComponent(
                        expenses: expenses,
                        dateTime: date,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
