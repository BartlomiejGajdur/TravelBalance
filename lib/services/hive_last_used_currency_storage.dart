import 'package:TravelBalance/TravelBalanceComponents/currency_pick.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:hive/hive.dart';

//tests add
class LastUsedCurrencyStorage {
  static final LastUsedCurrencyStorage _instance =
      LastUsedCurrencyStorage._internal();

  late Box<String> _lastUsedCurrencyBox;
  final Map<int, String> _lastUsedCurrencyMap = {};

  LastUsedCurrencyStorage._internal();

  factory LastUsedCurrencyStorage() {
    return _instance;
  }

  Future<void> initialize() async {
    _lastUsedCurrencyBox = await Hive.openBox<String>('lastUsedCurrencyBox');

    _lastUsedCurrencyMap.addAll(
        _lastUsedCurrencyBox.toMap().map((key, value) => MapEntry(key, value)));
  }

  Future<void> setLastUsedCurrency(int tripId, Currency currency) async {
    _lastUsedCurrencyMap[tripId] = currency.code;
    await _lastUsedCurrencyBox.put(tripId, currency.code);
  }

  Currency? getLastUsedCurrency(int tripId) {
    if (_lastUsedCurrencyMap[tripId] == null) return null;

    return currency(_lastUsedCurrencyMap[tripId]!);
  }
}
