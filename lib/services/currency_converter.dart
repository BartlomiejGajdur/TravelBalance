import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/services/hive_service.dart';
import 'package:currency_picker/currency_picker.dart';

class CurrencyConverter {
  static double convertExplicit(double value, Currency fromCurrency,
      Currency toCurrency, DateTime? tripCreationDate) {
    return convertImplicit(
        value, fromCurrency.code, toCurrency.code, tripCreationDate);
  }

  static double convertImplicit(double value, String fromCurrencyCode,
      String toCurrencyCode, DateTime? tripCreationDate) {
    final Map<String, double> currencyRates =
        CurrencyRatesStorage().getCurrencyRates(tripCreationDate);

    if (!currencyRates.containsKey(fromCurrencyCode) ||
        !currencyRates.containsKey(toCurrencyCode)) {
      throw ArgumentError('Currency not found in rates');
    }

    double result = (value / currencyRates[fromCurrencyCode]!) *
        currencyRates[toCurrencyCode]!;

    return result;
  }

  //Always convert to currency in globals.dart
  static double convertToDefaultCurrency(
      double value, Currency fromCurrency, DateTime? tripCreationDate) {
    return convertExplicit(
        value, fromCurrency, defaultCurrency, tripCreationDate);
  }

  static String formatConversionResult(double value, {int decimals = 2}) {
    return value.toStringAsFixed(decimals);
  }
}
