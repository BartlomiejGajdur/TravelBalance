import 'package:flutter/material.dart';
import 'package:TravelBalance/models/expense.dart';

class Trip {
  int? _id;
  String _name;
  String? _image;
  double _tripCost;
  List<Expense> _expenses;
  Map<DateTime, List<Expense>> _expensesByDate = {};
  Map<Category, double> _categoriesWithMoney = {};
  Trip(
      {int? id,
      required String name,
      required String? image,
      required double tripCost,
      required List<Expense> expenses})
      : _id = id,
        _name = name,
        _image = image,
        _tripCost = tripCost,
        _expenses = expenses,
        _expensesByDate = _groupExpensesByDate(expenses),
        _categoriesWithMoney = _groupCategoriesWithMoney(expenses);

  String get name => _name;
  String? get image => _image;
  double get tripCost => _tripCost;
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
    final String? image = data['image'];
    final double tripCost = data['trip_cost'].toDouble();
    final List<Expense> expenses = (data['expenses'] as List)
        .map((expenseData) => Expense.fromJson(expenseData, id))
        .toList();
    return Trip(
        id: id,
        name: name,
        image: image,
        tripCost: tripCost,
        expenses: expenses);
  }

  void printDetails() {
    debugPrint('  Trip Details:');
    debugPrint('  ID: $_id');
    debugPrint('  Name: $_name');
    debugPrint(_image != null ? '  Image: $_image' : '  Image: Not Specified');
    debugPrint('  Trip Cost: $_tripCost');
    debugPrint('  Expenses:');
    for (var expense in _expenses) {
      expense.printDetails();
    }
  }

  double calculateTripCost() {
    return expenses.fold(0, (sum, expense) => sum + expense.cost);
  }

  void addExpense(Expense expense) {
    expenses.add(expense);
    _expensesByDate = _groupExpensesByDate(_expenses);
    _categoriesWithMoney = _groupCategoriesWithMoney(expenses);
    _tripCost = calculateTripCost();
  }

  void reCalculate() {
    _expensesByDate = _groupExpensesByDate(_expenses);
    _categoriesWithMoney = _groupCategoriesWithMoney(_expenses);
    _tripCost = calculateTripCost();
  }

  void deleteExpense(int expenseId) {
    // Znajdź indeks wydatku z podanym ID
    int index = expenses.indexWhere((expense) => expense.id == expenseId);

    if (index != -1) {
      expenses.removeAt(index);
      _expensesByDate = _groupExpensesByDate(expenses);
      _categoriesWithMoney = _groupCategoriesWithMoney(expenses);
      _tripCost = calculateTripCost();
    } else {
      throw ("Something went wrong with Expense delete, cannot find expense of given id!");
    }
  }

  void setName(String newName) {
    _name = newName;
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

    Map<DateTime, List<Expense>> sortedExpensesByDate = {};
    for (var key in sortedKeys) {
      sortedExpensesByDate[key] = expensesByDate[key]!;
    }

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
