import 'dart:convert';

import 'package:TravelBalance/Utils/date_picker.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class CurrencyRatesStorage {
  static final CurrencyRatesStorage _instance =
      CurrencyRatesStorage._internal();

  late Box<Map<dynamic, dynamic>> _currencyBox;
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
    _currencyBox =
        await Hive.openBox<Map<dynamic, dynamic>>('currencyRatesBox');

    _defaultCurrencyRates = await _loadDefaultCurrencyRates();
  }

  Future<void> addCurrencyRates(
      DateTime date, Map<String, double> rates) async {
    String dateKey = formattedDateTimeInString(date);

    Map<dynamic, dynamic> convertedRates = rates.map(
      (key, value) => MapEntry(key, value),
    );

    if (_currencyBox.get(dateKey) == null) {
      await _currencyBox.put(dateKey, convertedRates);
    }
  }

  Map<String, double> getCurrencyRates(DateTime? date) {
    if (date == null) return _defaultCurrencyRates;

    Map<dynamic, dynamic>? associatedCurrencies =
        _currencyBox.get(formattedDateTimeInString(date));

    if (associatedCurrencies != null) {
      return associatedCurrencies.map(
        (key, value) => MapEntry(key.toString(), (value as num).toDouble()),
      );
    }

    return _defaultCurrencyRates;
  }
}
//43418.1