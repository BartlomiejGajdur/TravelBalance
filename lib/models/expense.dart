import 'package:TravelBalance/Utils/globals.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';

enum Category {
  activities,
  accommodation,
  food,
  health,
  shopping,
  transport,
  souvenirs,
  others
}

class Expense {
  int? _id;
  final int _tripId;
  String _title;
  double _cost;
  Currency _currency;
  double _costInBaseCurrency;
  Category _category;
  DateTime _dateTime;

  Expense(
      {int? id,
      required final int tripId,
      required String title,
      required double cost,
      required Currency currency,
      required Category category,
      required DateTime dateTime,
      double costInBaseCurrency = 0.0})
      : _id = id,
        _tripId = tripId,
        _title = title,
        _cost = cost,
        _category = category,
        _dateTime = dateTime,
        _currency = currency,
        _costInBaseCurrency = costInBaseCurrency;

  int get tripId => _tripId;
  String get title => _title;
  double get cost => _cost;
  Category get category => _category;
  DateTime get dateTime => _dateTime;
  Currency get currency => _currency;
  double get costInBaseCurrency => _costInBaseCurrency;

  void setId(int expenseId) {
    if (_id == null) {
      _id = expenseId;
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

  void setTitle(String name) {
    _title = name;
  }

  void setCost(double cost) {
    _cost = cost;
  }

  void setCategory(Category category) {
    _category = category;
  }

  void setDateTime(DateTime dateTime) {
    _dateTime = dateTime;
  }

  void setCostInBaseCurrency(double costInBaseCurrency) {
    _costInBaseCurrency = costInBaseCurrency;
  }

  factory Expense.fromJson(Map<String, dynamic> data, final int tripId) {
    final int id = data['id'];
    final String title = data['title'];
    final double cost = data['cost'].toDouble();
    final Category category = Category.values[data['category']];
    final Currency currency =
        CurrencyService().findByCode(data['currency'] ?? defaultCurrencyCode)!;
    DateTime dateTime = DateTime.parse(data['date']);
    return Expense(
      id: id,
      tripId: tripId,
      title: title,
      cost: cost,
      currency: currency,
      category: category,
      dateTime: dateTime,
    );
  }

  String categoryToString() {
    switch (_category) {
      case Category.activities:
        return 'Activities';
      case Category.accommodation:
        return 'Accommodation';
      case Category.food:
        return 'Food';
      case Category.health:
        return 'Health';
      case Category.shopping:
        return 'Shopping';
      case Category.transport:
        return 'Transport';
      case Category.souvenirs:
        return 'Souvenirs';
      case Category.others:
        return 'Others';
      default:
        return 'Unknown';
    }
  }

  static String staticCategoryToString(Category category) {
    switch (category) {
      case Category.activities:
        return 'Activities';
      case Category.accommodation:
        return 'Accommodation';
      case Category.food:
        return 'Food';
      case Category.health:
        return 'Health';
      case Category.shopping:
        return 'Shopping';
      case Category.transport:
        return 'Transport';
      case Category.souvenirs:
        return 'Souvenirs';
      case Category.others:
        return 'Others';
      default:
        return 'Unknown';
    }
  }

  static Category stringToCategory(String categoryString) {
    switch (categoryString) {
      case 'Activities':
        return Category.activities;
      case 'Accommodation':
        return Category.accommodation;
      case 'Food':
        return Category.food;
      case 'Health':
        return Category.health;
      case 'Shopping':
        return Category.shopping;
      case 'Transport':
        return Category.transport;
      case 'Souvenirs':
        return Category.souvenirs;
      case 'Others':
        return Category.others;
      default:
        throw Exception('Unknown category: $categoryString');
    }
  }

  void printDetails() {
    debugPrint('      Expense Details:');
    debugPrint('      ID: ${_id ?? -1}');
    debugPrint('      TRIP ID: $_tripId');
    debugPrint('      Title: $_title');
    debugPrint('      Cost: $_cost');
    debugPrint('      Category: $_category');
    debugPrint('      DateTime: $_dateTime');
    debugPrint('      --------------------------');
  }

  //No setters - no editable.
}
