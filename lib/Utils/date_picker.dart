import 'package:flutter/material.dart';

Future<void> showCustomDatePicker(BuildContext context, DateTime? time,
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

  if (parts.length < 3) {
    throw "Wrong date format";
  }

  int year = int.parse(parts[0]);
  int month = int.parse(parts[1]);
  int day = int.parse(parts[2]);

  return DateTime(year, month, day);
}

DateTime getDateTimeWithCurrentTime(String dateTime) {
  DateTime date = formattedStringInDateTime(dateTime);
  DateTime now = DateTime.now();

  return DateTime(
    date.year,
    date.month,
    date.day,
    now.hour,
    now.minute,
    now.second,
  );
}

String formatDate(DateTime dateTime) {
  const List<String> monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  String month = monthNames[dateTime.month - 1]; 
  String day = dateTime.day.toString().padLeft(2, '0'); 
  String year = dateTime.year.toString();
  return '$month $day $year';
}
