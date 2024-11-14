import 'package:TravelBalance/Utils/globals.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Currency currency(String currencyCode) {
  Currency? currency = CurrencyService().findByCode(currencyCode);
  if (currency == null) {
    throw ArgumentError("Cannot find Currency with given currency Code");
  }
  return currency;
}

class CurrencyPick extends StatefulWidget {
  final Currency currency;
  final Function(Currency) onCurrencyChanged;
  const CurrencyPick(
      {super.key, required this.currency, required this.onCurrencyChanged});

  @override
  State<CurrencyPick> createState() => _CurrencyPickState();
}

class _CurrencyPickState extends State<CurrencyPick> {
  late Currency _currency;
  @override
  void initState() {
    _currency = widget.currency;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCurrencyPicker(
            context: context,
            theme: CurrencyPickerThemeData(
              inputDecoration: InputDecoration(
                labelText: 'Search currency',
                hintText: 'Entry currency name',
                labelStyle: TextStyle(color: primaryColor),
                prefixIcon: Icon(Icons.search, color: primaryColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
              ),
            ),
            onSelect: (Currency newCurrency) {
              setState(() {
                _currency = newCurrency;
              });
              widget.onCurrencyChanged(newCurrency);
            });
      },
      child: Card(
        shadowColor: Colors.grey,
        elevation: 3,
        color: Colors.grey[200],
        margin: EdgeInsets.fromLTRB(10.w, 0, horizontalPadding, 0),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                CurrencyUtils.currencyToEmoji(_currency),
                style: const TextStyle(fontSize: 15),
              ),
              Text(
                " ${_currency.code}",
                style: const TextStyle(fontSize: 15),
              ),
              const Icon(Icons.arrow_drop_up),
            ],
          ),
        ),
      ),
    );
  }
}
