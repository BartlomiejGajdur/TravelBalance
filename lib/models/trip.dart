import 'package:TravelBalance/Utils/country_picker.dart';
import 'package:TravelBalance/Utils/custom_snack_bar.dart';
import 'package:TravelBalance/models/custom_image.dart';
import 'package:TravelBalance/services/currency_converter.dart';
import 'package:TravelBalance/services/hive_currency_rate_storage.dart';
import 'package:country_picker/country_picker.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:TravelBalance/models/expense.dart';
import 'dart:convert';

class Trip {
  int? _id;
  String _name;
  CustomImage _customImage;
  List<Country> _countries;
  DateTime _dateTime;
  List<Expense> _expenses;
  Trip(
      {int? id,
      required String name,
      CustomImage customImage = CustomImage.defaultLandscape,
      required List<Country> countries,
      required DateTime dateTime,
      required Map<String, double> rates,
      required List<Expense> expenses})
      : _id = id,
        _name = name,
        _customImage = customImage,
        _dateTime = dateTime,
        _expenses = expenses,
        _countries = countries;

  String get name => _name;
  CustomImage get customImage => _customImage;
  DateTime get dateTime => _dateTime;
  List<Country> get countries => _countries;
  List<Expense> get expenses => _expenses;

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
    final String name = utf8.decode(data['name'].runes.toList()); // TEST ON PROD
    final int image = data['image_id'] ?? 0;
    DateTime dateTime = DateTime.parse(data['date']);
    final List<Expense> expenses = (data['expenses'] as List)
        .map((expenseData) => Expense.fromJson(expenseData, id))
        .toList();
    final Map<String, double> rates =
        (data['currencies_rates']['rates'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, value.toDouble()));
    final List<Country> countries =
        (data['countries'] as List).map((countryData) {
      final int id = countryData['id'];
      return CountryPicker.getCountryById(id)!;
    }).toList();

    CurrencyRatesStorage().addCurrencyRates(dateTime, rates);

    return Trip(
        id: id,
        name: name,
        customImage: getImageById(image),
        dateTime: dateTime,
        rates: rates,
        countries: countries,
        expenses: expenses);
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
  }

  void deleteExpense(int expenseId) {
    int index = expenses.indexWhere((expense) => expense.getId() == expenseId);

    if (index != -1) {
      expenses.removeAt(index);
    } else {
      throw ("Something went wrong with Expense delete, cannot find expense of given id!");
    }
  }

  void setName(String newName) {
    _name = newName;
  }

  void editTrip(String newName, CustomImage newImage, List<Country> countries) {
    _name = newName;
    _customImage = newImage;
    _countries = countries;
  }

  Map<DateTime, List<Expense>> groupExpensesByDate() {
    Map<DateTime, List<Expense>> expensesByDate = {};

    for (var expense in _expenses) {
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

  Map<Category, double> groupCategoriesWithMoneyInBaseCurrency() {
    Map<Category, double> categoriesWithMoney = {};
    for (var expense in expenses) {
      if (categoriesWithMoney.containsKey(expense.category)) {
        categoriesWithMoney[expense.category] =
            categoriesWithMoney[expense.category]! + expense.costInBaseCurrency;
      } else {
        categoriesWithMoney[expense.category] = expense.costInBaseCurrency;
      }
    }

    return categoriesWithMoney;
  }
}
