import 'package:TravelBalance/Utils/date_picker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Date formatting tests', () {
    test('formattedDateTimeInString returns correct format', () {
      final dateTime = DateTime(2024, 11, 7);
      final formatted = formattedDateTimeInString(dateTime);
      expect(formatted, '2024-11-07');
    });

    test('formattedStringInDateTime parses date correctly', () {
      final dateString = '2024-11-07';
      final dateTime = formattedStringInDateTime(dateString);
      expect(dateTime.year, 2024);
      expect(dateTime.month, 11);
      expect(dateTime.day, 7);
    });

    test('formattedStringInDateTime throws error on invalid format', () {
      expect(
          () => formattedStringInDateTime('2024-11'), throwsA(isA<String>()));
    });
  });
}
