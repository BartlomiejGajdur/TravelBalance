import 'package:flutter/material.dart';
import 'package:TravelBalance/models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  Expense _expense;

  ExpenseProvider(this._expense);

  Expense get expense => _expense;

  void editExpenseTitle(String newTitle) {
    _expense.setTitle(newTitle);
    notifyListeners();
  }

  void editExpenseCost(double newCost) {
    _expense.setCost(newCost);
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
