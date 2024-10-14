import 'package:TravelBalance/models/expense.dart';
import 'package:TravelBalance/models/trip.dart';
import 'package:TravelBalance/providers/user_provider.dart';
import 'package:flutter/material.dart';

class TripProvider with ChangeNotifier {
  final Trip trip;
  final UserProvider userProvider;

  TripProvider(this.trip, this.userProvider);

  void notifyUi() {
    userProvider.notifyListeners();
    notifyListeners();
  }

  void editTripName(String newName) {
    trip.setName(newName);
    notifyUi();
  }

  void addExpense(Expense expense) {
    trip.addExpense(expense);
    notifyUi();
  }

  void deleteExpense(int index) {
    trip.deleteExpense(index);
    notifyUi();
  }

  void reCalculate() {
    trip.reCalculate();
    debugPrint("Categories with Money: ${trip.categoriesWithMoney}");
    notifyUi();
  }

  bool isExpenseListEmpty() {
    return trip.expenses.isEmpty;
  }
}
