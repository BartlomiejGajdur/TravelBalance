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
  final int _id;
  final int _tripId;
  String _title;
  double _cost;
  Category _category;
  DateTime _dateTime;

  Expense({
    required final int id,
    required final int tripId,
    required String title,
    required double cost,
    required Category category,
    required DateTime dateTime,
  })  : _id = id,
        _tripId = tripId,
        _title = title,
        _cost = cost,
        _category = category,
        _dateTime = dateTime;

  int get id => _id;
  int get tripId => _tripId;
  String get title => _title;
  double get cost => _cost;
  Category get category => _category;
  DateTime get dateTime => _dateTime;

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

  factory Expense.fromJson(Map<String, dynamic> data, final int tripId) {
    final int id = data['id'];
    final String title = data['title'];
    final double cost = data['cost'].toDouble();
    final Category category = Category.values[data['category']];
    //Might cause problems.
    DateTime dateTime = DateTime.parse(data['date']);
    return Expense(
      id: id,
      tripId: tripId,
      title: title,
      cost: cost,
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

  void printDetails() {
    debugPrint('      Expense Details:');
    debugPrint('      ID: $_id');
    debugPrint('      Title: $_title');
    debugPrint('      Cost: $_cost');
    debugPrint('      Category: $_category');
    debugPrint('      DateTime: $_dateTime');
    debugPrint('      --------------------------');
  }

  //No setters - no editable.
}
