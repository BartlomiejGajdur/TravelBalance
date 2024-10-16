import 'package:flutter/material.dart';

Future<void> showCustomDatePicker(BuildContext context, DateTime time,
    TextEditingController textController) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: time,
    firstDate: DateTime.now().subtract(const Duration(days: 365)),
    lastDate: DateTime.now(),
  );

  if (pickedDate != null) {
    textController.text = "${pickedDate.toLocal()}".split(' ')[0];
  }
}

String formattedDateTimeInString(DateTime dateTime) {
  return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
}

DateTime formattedStringInDateTime(String dateTime) {
  List<String> parts = dateTime.split('-');

  if (parts.length != 3) {
    throw const FormatException("Niepoprawny format daty");
  }

  int year = int.parse(parts[0]);
  int month = int.parse(parts[1]);
  int day = int.parse(parts[2]);

  return DateTime(year, month, day);
}
