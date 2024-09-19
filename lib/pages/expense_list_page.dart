import 'package:TravelBalance/TravelBalanceComponents/no_content_message.dart';
import 'package:TravelBalance/Utils/custom_scaffold.dart';
import 'package:TravelBalance/components/expense_sheet_component.dart';
import 'package:TravelBalance/models/expense.dart';
import 'package:TravelBalance/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:TravelBalance/models/trip.dart';
import 'package:provider/provider.dart';

class ExpenseListPage extends StatelessWidget {
  final Trip trip;

  const ExpenseListPage({
    super.key,
    required this.trip,
  });
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        text1: trip.name,
        text2: "Discover your travel costs.",
        onActionButtonClick: trip.addExpense,
        childWidget: Provider.of<UserProvider>(context, listen: false)
                .isExpenseListEmpty(trip)
            ? noContentMessage(ContentType.Expenses)
            : ListView.builder(
                itemCount: trip.expensesByDate.length,
                itemBuilder: (context, index) {
                  DateTime date = trip.expensesByDate.keys.toList()[index];
                  List<Expense> expenses = trip.expensesByDate[date]!;
                  return ExpenseSheetComponent(
                      expenses: expenses, dateTime: date);
                },
              ));
  }
}
