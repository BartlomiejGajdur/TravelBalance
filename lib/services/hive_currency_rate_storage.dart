import 'dart:convert';

import 'package:TravelBalance/Utils/date_picker.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class CurrencyRatesStorage {
  static final CurrencyRatesStorage _instance =
      CurrencyRatesStorage._internal();

  late Box<Map<String, double>> _currencyBox;
  final Map<DateTime, Map<String, double>> _currencyRates = {};
  late Map<String, double> _defaultCurrencyRates;

  Map<String, double> get defaultCurrencyRates => _defaultCurrencyRates;
  CurrencyRatesStorage._internal();

  factory CurrencyRatesStorage() {
    return _instance;
  }

  Future<Map<String, double>> _loadDefaultCurrencyRates() async {
    final String response = await rootBundle
        .loadString('lib/assets/jsonData/countries_code_to_rate.json');
    final Map<String, dynamic> jsonMap = json.decode(response);
    final Map<String, double> currencyRates =
        jsonMap.map((key, value) => MapEntry(key, value.toDouble()));

    return currencyRates;
  }

  Future<void> initialize() async {
    _currencyBox = await Hive.openBox<Map<String, double>>('currencyRatesBox');

    //Load Default data
    _defaultCurrencyRates = await _loadDefaultCurrencyRates();

    //Load data from Hive
    for (var entry in _currencyBox.toMap().entries) {
      DateTime date = formattedStringInDateTime(entry.key);
      _currencyRates[date] = entry.value;
    }
  }

  // Add new currency rates after trip Creation
  Future<void> addCurrencyRates(
      DateTime date, Map<String, double> rates) async {
    if (_currencyRates[date] == null) {
      _currencyRates[date] = rates;
      await _currencyBox.put(formattedDateTimeInString(date), rates);
    }
  }

  Map<String, double> getCurrencyRates(DateTime? date) {
    if (date == null) return _defaultCurrencyRates;

    Map<String, double>? associatedCurrencies =
        _currencyBox.get(formattedDateTimeInString(date));

    return associatedCurrencies ?? _defaultCurrencyRates;
  }
}
