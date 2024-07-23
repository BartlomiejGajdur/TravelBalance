import 'package:flutter/material.dart';
import 'package:TravelBalance/components/expense_sheet_component.dart';
import 'package:TravelBalance/components/globals.dart';
import 'package:TravelBalance/models/expense.dart';
import 'package:TravelBalance/models/trip.dart';

class ExpenseListPage extends StatelessWidget {
  final Trip trip;

  const ExpenseListPage({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          trip.name,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: leadingColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[100],
      body: ListView.builder(
        itemCount: trip.expensesByDate.length,
        itemBuilder: (context, index) {
          DateTime date = trip.expensesByDate.keys.toList()[index];
          List<Expense> expenses = trip.expensesByDate[date]!;
          return ExpenseSheetComponent(expenses: expenses, dateTime: date);
        },
      ),
    );
  }
}
