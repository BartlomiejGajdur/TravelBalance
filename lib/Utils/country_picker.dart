import 'package:TravelBalance/Utils/globals.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class CountryPicker extends StatefulWidget {
  final List<Country>? countries;
  final Function(List<Country>)? onCountriesChanged;
  final double? listHeight;

  static Map<String, int> nameToId = {};
  static Map<int, String> idToName = {};

  static Future<void> loadCountryData() async {
    final String response = await rootBundle
        .loadString('lib/assets/jsonData/countries_name_to_id.json');
    final data = json.decode(response) as Map<String, dynamic>;

    nameToId = data.map((key, value) => MapEntry(key, value as int));
    idToName = {for (var entry in nameToId.entries) entry.value: entry.key};
  }

  static int? getIdByCountry(Country country) {
    return nameToId[country.name];
  }

  static Country? getCountryById(int id) {
    String? countryName = idToName[id];
    if (countryName == null) {
      return null;
    }
    return Country.tryParse(countryName);
  }

  const CountryPicker(
      {super.key, this.countries, this.onCountriesChanged, this.listHeight});

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  List<Country> countries = [];

  @override
  void initState() {
    if (widget.countries != null) {
      countries = widget.countries!;
    }

    super.initState();
  }

  void _addCountry(Country country) {
    setState(() {
      if (!countries.contains(country)) {
        countries.add(country);
        widget.onCountriesChanged?.call(countries);
        print(CountryPicker.getIdByCountry(country)!.toInt());
      }
    });
  }

  void _removeCountry(Country country) {
    setState(() {
      countries.remove(country);
      widget.onCountriesChanged?.call(countries);
    });
  }

  @override
  Widget build(BuildContext context) {
    double listHeight = widget.listHeight ?? 300.h;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => showCountryPicker(
            context: context,
            countryListTheme: CountryListThemeData(
              inputDecoration: InputDecoration(
                labelText: 'Search country',
                hintText: 'Entry country name',
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
            onSelect: (Country country) {
              _addCountry(country);
            },
          ),
          child: Container(
            width: 200.w,
            height: 50.h,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: primaryColor),
                borderRadius: BorderRadius.circular(12)),
            child: const Center(child: Text("Pick a Country")),
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        SizedBox(
          height: listHeight,
          child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: countries.length,
              itemBuilder: (context, index) {
                final Country country = countries[index];
                return Card(
                  color: thirdColor.withOpacity(0.4),
                  child: ListTile(
                    leading: Text(
                      country.flagEmoji,
                      style: TextStyle(fontSize: 24.sp),
                    ),
                    title: Text(country.displayNameNoCountryCode),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeCountry(country),
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }
}
