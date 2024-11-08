import 'package:TravelBalance/TravelBalanceComponents/currency_pick.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:TravelBalance/services/hive_service.dart';
import 'package:TravelBalance/services/currency_converter.dart';
import 'package:hive_test/hive_test.dart';

final DateTime mockDateTime = DateTime(2024, 2, 14);
final Map<String, double> mockData = {
  "USD": 1,
  "EUR": 0.98772,
  "GBP": 0.83,
  "ANG": 1.797501,
  "AOA": 912.504613,
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await setUpTestHive();
    await CurrencyRatesStorage().initialize();
    await CurrencyRatesStorage().addCurrencyRates(mockDateTime, mockData);
  });

  tearDownAll(() async {
    await tearDownTestHive();
  });

  group('CurrencyConverter tests', () {
    test('convert currency code to Currency class - Throws', () {
      expect(
        () => currency("INVALID"),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('convertExplicit should convert from USD to EUR correctly', () {
      final fromCurrency = currency('USD');
      final toCurrency = currency('EUR');

      final result = CurrencyConverter.convertExplicit(
          100.0, fromCurrency, toCurrency, mockDateTime);

      // 100 USD * 0.98772 = 98.772 EUR
      expect(result, 98.772);
    });

    test('convertImplicit should convert from USD to EUR correctly', () {
      const value = 100.0;
      const fromCurrencyCode = 'USD';
      const toCurrencyCode = 'EUR';

      final result = CurrencyConverter.convertImplicit(
          value, fromCurrencyCode, toCurrencyCode, mockDateTime);

      // 100 USD * 0.98772 = 98.772 EUR
      expect(result, 98.772);
    });

    test(
        'convertToDefaultCurrency should convert from GBP to default currency (USD)',
        () {
      final fromCurrency = currency('GBP');
      const value = 100.0;

      final result = CurrencyConverter.convertToDefaultCurrency(
          value, fromCurrency, mockDateTime);

      // 100 GBP * (1 / 0.83) = 120.48 USD
      expect(result, 120.48192771084338);
    });

    test('Convert without Base Currency', () {
      final fromCurrency = currency('GBP');
      final toCurrency = currency('AOA');
      const value = 10.0;

      final result = CurrencyConverter.convertExplicit(
          value, fromCurrency, toCurrency, mockDateTime);

      // (value GBP/ rate GBP to USD ) * rate AOA to USD
      // (10/0.83) * 912.504613 = 10994.031 AOA
      expect(result, 10994.03148192771);
    });

    test(
        'formatConversionResult should format the result correctly with default decimals',
        () {
      const value = 98.772;
      final formattedResult = CurrencyConverter.formatConversionResult(value);

      expect(formattedResult, '98.77');
    });

    test(
        'formatConversionResult should format the result correctly with custom decimals',
        () {
      const value = 98.772;
      final formattedResult =
          CurrencyConverter.formatConversionResult(value, decimals: 3);

      expect(formattedResult, '98.772');
    });
  });
}
