import 'package:TravelBalance/Utils/country_picker.dart';
import 'package:TravelBalance/models/custom_image.dart';
import 'package:TravelBalance/providers/user_provider.dart';
import 'package:TravelBalance/services/currency_converter.dart';
import 'package:country_picker/country_picker.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:TravelBalance/models/expense.dart';

class Trip {
  int? _id;
  String _name;
  CustomImage _customImage;
  List<Country> _countries;
  double _tripCost;
  DateTime _dateTime;
  List<Expense> _expenses;
  Map<DateTime, List<Expense>> _expensesByDate = {};
  Map<Category, double> _categoriesWithMoney = {};
  Trip(
      {int? id,
      required String name,
      CustomImage customImage = CustomImage.defaultLandscape,
      required List<Country> countries,
      required double tripCost,
      required DateTime dateTime,
      required List<Expense> expenses})
      : _id = id,
        _name = name,
        _customImage = customImage,
        _dateTime = dateTime,
        _tripCost = tripCost,
        _expenses = expenses,
        _countries = countries,
        _expensesByDate = _groupExpensesByDate(expenses),
        _categoriesWithMoney = _groupCategoriesWithMoney(expenses);

  String get name => _name;
  CustomImage get customImage => _customImage;
  double get tripCost => _tripCost;
  DateTime get dateTime => _dateTime;
  List<Country> get countries => _countries;
  List<Expense> get expenses => _expenses;
  Map<DateTime, List<Expense>> get expensesByDate => _expensesByDate;
  Map<Category, double> get categoriesWithMoney => _categoriesWithMoney;

  void setId(int tripId) {
    if (_id == null) {
      _id = tripId;
    } else {
      throw ("Id is already set!");
    }
  }

  int? getId() {
    if (_id == null) {
      return null;
    } else {
      return _id!;
    }
  }

  factory Trip.fromJson(Map<String, dynamic> data) {
    final int id = data['id'];
    final String name = data['name'];
    final int image = data['image_id'] ?? 0;
    final double tripCost = data['trip_cost'].toDouble();
    DateTime dateTime = DateTime.parse(data['date']);
    final List<Expense> expenses = (data['expenses'] as List)
        .map((expenseData) => Expense.fromJson(expenseData, id))
        .toList();
    final List<Country> countries =
        (data['countries'] as List).map((countryData) {
      final int id = countryData['id'];
      return CountryPicker.getCountryById(id)!;
    }).toList();

    return Trip(
        id: id,
        name: name,
        customImage: getImageById(image),
        dateTime: dateTime,
        tripCost: tripCost,
        countries: countries,
        expenses: expenses);
  }

  void printDetails() {
    debugPrint('  Trip Details:');
    debugPrint('  ID: $_id');
    debugPrint('  Name: $_name');
    debugPrint('  Image ${customImage.index}');
    debugPrint('  Trip Cost: $_tripCost');
    debugPrint('  Expenses:');
    for (var expense in _expenses) {
      expense.printDetails();
    }
  }

  void printExpensesByDate() {
    print("----------------Start--------------");
    _expensesByDate.forEach((date, expenses) {
      print("--------Date: $date");
      for (var expense in expenses) {
        expense.printDetails();
      }
    });
    print("----------------END------------------");
  }

  void recalculateEachCostInBaseCurrency(String baseCurrency) {
    for (var expense in _expenses) {
      expense.setCostInBaseCurrency(CurrencyConverter.convertImplicit(
          expense.cost, expense.currency.code, baseCurrency, _dateTime));
    }
  }

  double sumOfEachExpenseCostInBaseCurrency() {
    double total = 0.0;
    for (var expense in _expenses) {
      total += expense.costInBaseCurrency;
    }
    return total;
  }

  double calculateTripCost() {
    return expenses.fold(0, (sum, expense) => sum + expense.costInBaseCurrency);
  }

  void addExpense(int tripId, String title, double cost, Currency currency,
      double costInBaseCurrency, Category category, DateTime dateTime) {
    Expense newExpense = Expense(
      tripId: tripId,
      title: title,
      cost: cost,
      currency: currency,
      costInBaseCurrency: costInBaseCurrency,
      category: category,
      dateTime: dateTime,
    );

    _expenses.insert(0, newExpense);
    reCalculate();
  }

  void deleteExpense(int expenseId) {
    int index = expenses.indexWhere((expense) => expense.getId() == expenseId);

    if (index != -1) {
      expenses.removeAt(index);
      reCalculate();
    } else {
      throw ("Something went wrong with Expense delete, cannot find expense of given id!");
    }
  }

  void reCalculate() {
    _expensesByDate = _groupExpensesByDate(_expenses);
    _categoriesWithMoney = _groupCategoriesWithMoney(_expenses);
    _tripCost = calculateTripCost();
  }

  void setName(String newName) {
    _name = newName;
  }

  void editTrip(String newName, CustomImage newImage, List<Country> countries) {
    _name = newName;
    _customImage = newImage;
    _countries = countries;
  }

  static Map<DateTime, List<Expense>> _groupExpensesByDate(
      List<Expense> expenses) {
    Map<DateTime, List<Expense>> expensesByDate = {};

    for (var expense in expenses) {
      DateTime date = DateTime(
          expense.dateTime.year, expense.dateTime.month, expense.dateTime.day);

      if (expensesByDate.containsKey(date)) {
        expensesByDate[date]!.add(expense);
      } else {
        expensesByDate[date] = [expense];
      }
    }

    var sortedKeys = expensesByDate.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    Map<DateTime, List<Expense>> sortedExpensesByDate = {
      for (var key in sortedKeys) key: expensesByDate[key]!
    };

    sortedExpensesByDate.forEach((date, expenses) {
      expenses.sort(
          (a, b) => b.dateTime.toString().compareTo(a.dateTime.toString()));
    });

    return sortedExpensesByDate;
  }

  static Map<Category, double> _groupCategoriesWithMoney(
      List<Expense> expenses) {
    Map<Category, double> categoriesWithMoney = {};
    for (var expense in expenses) {
      if (categoriesWithMoney.containsKey(expense.category)) {
        categoriesWithMoney[expense.category] =
            categoriesWithMoney[expense.category]! + expense.cost;
      } else {
        categoriesWithMoney[expense.category] = expense.cost;
      }
    }

    return categoriesWithMoney;
  }
}
