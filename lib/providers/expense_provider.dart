import 'package:TravelBalance/providers/trip_provider.dart';
import 'package:flutter/material.dart';
import 'package:TravelBalance/models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  final Expense _expense;
  final TripProvider tripProvider;
  ExpenseProvider(this._expense, this.tripProvider);

  Expense get expense => _expense;

  void notifyUi() {
    tripProvider.reCalculate();
    notifyListeners();
  }

  void editExpense(
      String newTitle, double newCost, Category newCategory, DateTime newDate) {
    _expense.setTitle(newTitle);
    _expense.setCost(newCost);
    _expense.setCategory(newCategory);
    _expense.setDateTime(newDate);
    notifyUi();
  }

  void editExpenseTitle(String newTitle) {
    _expense.setTitle(newTitle);
  }

  void editExpenseCost(double newCost) {
    _expense.setCost(newCost);
  }

  void editExpenseCategory(Category newCategory) {
    _expense.setCategory(newCategory);
  }

  void editExpenseDateTime(DateTime newDateTime) {
    _expense.setDateTime(newDateTime);
  }
}
