import 'package:TravelBalance/Utils/globals.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Currencypick extends StatefulWidget {
  Currency currency;
  final Function(Currency) onCurrencyChanged;
  Currencypick(
      {super.key, required this.currency, required this.onCurrencyChanged});

  @override
  State<Currencypick> createState() => _CurrencypickState();
}

class _CurrencypickState extends State<Currencypick> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCurrencyPicker(
            context: context,
            onSelect: (Currency newCurrency) {
              setState(() {
                widget.currency = newCurrency;
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
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                CurrencyUtils.currencyToEmoji(widget.currency),
                style: TextStyle(fontSize: 15),
              ),
              Text(
                " ${widget.currency.code}",
                style: TextStyle(fontSize: 15),
              ),
              Icon(Icons.arrow_drop_up),
            ],
          ),
        ),
      ),
    );
  }
}
