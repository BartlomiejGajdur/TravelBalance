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

  void addExpense(int tripId, String title, double cost, Category category,
      DateTime dateTime) {
    trip.addExpense(tripId, title, cost, category, dateTime);
    notifyUi();
  }

  void deleteExpense(int expenseId) {
    trip.deleteExpense(expenseId);
    notifyUi();
  }

  void setExpenseIdOfLastAddedExpense(int expenseId) {
    assert(trip.expenses.isNotEmpty, "Expenses can't be empty");
    trip.expenses[0].setId(expenseId);
  }

  void deleteLastAddedExpense() {
    assert(trip.expenses.isNotEmpty, "Expenses can't be empty");
    trip.expenses.removeAt(0);
    notifyListeners();
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
