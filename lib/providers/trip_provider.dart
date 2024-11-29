import 'package:TravelBalance/models/custom_image.dart';
import 'package:TravelBalance/models/expense.dart';
import 'package:TravelBalance/models/trip.dart';
import 'package:TravelBalance/providers/user_provider.dart';
import 'package:TravelBalance/services/api_service.dart';
import 'package:TravelBalance/services/currency_converter.dart';
import 'package:country_picker/country_picker.dart';
import 'package:currency_picker/currency_picker.dart';
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

  void editTrip(String newName, CustomImage newImage, List<Country> countries) {
    trip.editTrip(newName, newImage, countries);
    notifyUi();
  }

  void addExpense(int tripId, String title, double cost, Currency currency,
      Category category, DateTime dateTime) {
    double convertedToBaseCurrency = CurrencyConverter.convertExplicit(
        cost, currency, userProvider.user!.baseCurrency, trip.dateTime);
    trip.addExpense(tripId, title, cost, currency, convertedToBaseCurrency,
        category, dateTime);
    notifyUi();
  }

  void deleteExpense(int? expenseId) {
    if (expenseId == null) return;

    trip.deleteExpense(expenseId);
    int? tripIndex = trip.getId();
    if (tripIndex != null) {
      ApiService().deleteExpense(tripIndex, expenseId);
    }
    notifyUi();
  }

  void setExpenseIdOfLastAddedExpense(int expenseId) {
    assert(trip.expenses.isNotEmpty, "Expenses can't be empty");
    trip.expenses[0].setId(expenseId);
  }

  void deleteLastAddedExpense() {
    assert(trip.expenses.isNotEmpty, "Expenses can't be empty");
    trip.expenses.removeAt(0);
    reCalculate();
  }

  void reCalculate() {
    trip.recalculateEachCostInBaseCurrency(
        userProvider.user!.baseCurrency.code);
    notifyUi();
  }

  bool isExpenseListEmpty() {
    return trip.expenses.isEmpty;
  }
}
