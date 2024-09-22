import 'package:TravelBalance/TravelBalanceComponents/no_content_message.dart';
import 'package:TravelBalance/Utils/custom_scaffold.dart';
import 'package:TravelBalance/components/expense_sheet_component.dart';
import 'package:TravelBalance/models/expense.dart';
import 'package:TravelBalance/providers/trip_provider.dart';
import 'package:TravelBalance/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:TravelBalance/models/trip.dart';
import 'package:provider/provider.dart';

class ExpenseListPage extends StatelessWidget {
  final Trip trip;

  void editTripName(TripProvider tripProvider) {
    tripProvider.editTripName("newName");
  }

  void addExpense(TripProvider tripProvider) {
    final newExpense = Expense(
        id: 1,
        title: "chhc",
        cost: 23,
        category: Category.activities,
        dateTime: DateTime(1999));
    tripProvider.addExpense(newExpense);
  }

  const ExpenseListPage({
    super.key,
    required this.trip,
  });
  @override
  Widget build(BuildContext context) {
    final tripProvider = Provider.of<TripProvider>(context);
    return CustomScaffold(
        text1: trip.name,
        text2: "Discover your travel costs.",
        onActionButtonClick: () => addExpense(tripProvider),
        onEditIconClick: () => editTripName(tripProvider),
        childWidget: tripProvider.isExpenseListEmpty()
            ? noContentMessage(ContentType.Expenses)
            : ListView.builder(
                itemCount: tripProvider.trip.expensesByDate.length,
                itemBuilder: (context, index) {
                  DateTime date =
                      tripProvider.trip.expensesByDate.keys.toList()[index];
                  List<Expense> expenses =
                      tripProvider.trip.expensesByDate[date]!;
                  return ExpenseSheetComponent(
                      expenses: expenses, dateTime: date);
                },
              ));
  }
}
