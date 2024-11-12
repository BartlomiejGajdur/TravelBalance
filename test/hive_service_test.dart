import 'package:TravelBalance/services/hive_currency_rate_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await setUpTestHive();
    await CurrencyRatesStorage().initialize();
  });

  tearDownAll(() async {
    await tearDownTestHive();
  });

  group('CurrencyRatesStorage tests', () {
    test('getCurrencyRates should return default rates when date is null', () {
      final rates = CurrencyRatesStorage().getCurrencyRates(null);
      expect(rates.isNotEmpty, true);
    });

    test('getCurrencyRates should return default rates for unknown date', () {
      final unknownDate = DateTime(2000, 1, 1);
      final rates = CurrencyRatesStorage().getCurrencyRates(unknownDate);
      expect(rates, CurrencyRatesStorage().defaultCurrencyRates);
    });

    test('addCurrencyRates should store rates correctly', () async {
      final date = DateTime.now();
      final rates = {'USD': 1.0, 'EUR': 0.85};

      await CurrencyRatesStorage().addCurrencyRates(date, rates);
      final storedRates = CurrencyRatesStorage().getCurrencyRates(date);

      expect(storedRates, rates);
    });

    test('getCurrencyRates should return stored rates for existing date',
        () async {
      final date = DateTime(2024, 11, 7);
      final rates = {'USD': 1.0, 'PLN': 4.5};

      await CurrencyRatesStorage().addCurrencyRates(date, rates);
      final storedRates = CurrencyRatesStorage().getCurrencyRates(date);

      expect(storedRates, rates);
    });

    test('getCurrencyRates should return stored rates for unknown data',
        () async {
      final date = DateTime(2024, 11, 7);
      final rates = {'USD': 1.0, 'PLN': 4.5};
      final unknownData = DateTime(2023, 11, 7);

      await CurrencyRatesStorage().addCurrencyRates(date, rates);
      final storedRates = CurrencyRatesStorage().getCurrencyRates(unknownData);

      expect(storedRates, CurrencyRatesStorage().defaultCurrencyRates);
    });
  });
}
