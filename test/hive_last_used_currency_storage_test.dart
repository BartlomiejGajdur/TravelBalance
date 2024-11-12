import 'package:TravelBalance/TravelBalanceComponents/currency_pick.dart';
import 'package:TravelBalance/services/hive_last_used_currency_storage.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await setUpTestHive();
    await LastUsedCurrencyStorage().initialize();
  });

  tearDownAll(() async {
    await tearDownTestHive();
  });

  group('LastUsedCurrencyStorage tests', () {
    test('getLastUsedCurrency should return rates when date is null', () {
      Currency usdCurrency = currency("USD");
      LastUsedCurrencyStorage().setLastUsedCurrency(0, usdCurrency);
      final Currency? getLastUsedCurrency =
          LastUsedCurrencyStorage().getLastUsedCurrency(0);
      expect(getLastUsedCurrency!.code, usdCurrency.code);
    });
  });
}
