import 'package:TravelBalance/providers/trip_provider.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:TravelBalance/models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  final Expense _expense;
  final TripProvider tripProvider;
  ExpenseProvider(this._expense, this.tripProvider);

  Expense get expense => _expense;

  void editExpense(String newTitle, double newCost, Currency newCurrency,
      Category newCategory, DateTime newDate) {
    _expense.setTitle(newTitle);
    _expense.setCost(newCost);
    _expense.setCategory(newCategory);
    _expense.setDateTime(newDate);
    _expense.setCurrency(newCurrency);
    notifyListeners();
  }

  void editExpenseTitle(String newTitle) {
    _expense.setTitle(newTitle);
    notifyListeners();
  }

  void editExpenseCost(double newCost) {
    _expense.setCost(newCost);
    tripProvider.reCalculate();
    notifyListeners();
  }

  void editExpenseCategory(Category newCategory) {
    _expense.setCategory(newCategory);
    notifyListeners();
  }

  void editExpenseDateTime(DateTime newDateTime) {
    _expense.setDateTime(newDateTime);
    notifyListeners();
  }
}
