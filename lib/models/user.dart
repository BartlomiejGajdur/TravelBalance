import 'package:TravelBalance/TravelBalanceComponents/currency_pick.dart';
import 'package:TravelBalance/Utils/globals.dart';
import 'package:TravelBalance/models/custom_image.dart';
import 'package:TravelBalance/models/statistics.dart';
import 'package:TravelBalance/services/ad_manager_service.dart';
import 'package:country_picker/country_picker.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:TravelBalance/models/trip.dart';
import 'package:flutter/material.dart';

enum SortOrder { ascending, descending }

class User {
  List<Trip> _trips;
  Statistics _statistics;
  Currency _baseCurrency;
  bool _isPremiumUser;
  User(
      {required List<Trip> trips,
      required Statistics statistics,
      required Currency baseCurrency,
      bool isPremiumUser = false})
      : _trips = trips,
        _statistics = statistics,
        _baseCurrency = baseCurrency,
        _isPremiumUser = isPremiumUser {
    sortTrips(SortOrder.ascending);
  }

  List<Trip> get trips => _trips;
  Statistics get statistics => _statistics;
  Currency get baseCurrency => _baseCurrency;
  bool get isPremiumUser => _isPremiumUser;

  factory User.fromJson(
      Map<String, dynamic> fetchTripJson, Map<String, dynamic> userDataJson) {
    List<Trip> trips = (fetchTripJson['trips'] as List)
        .map((jsonData) => Trip.fromJson(jsonData))
        .toList();
    Statistics statistics = Statistics.fromJson(fetchTripJson['statistics']);
    Currency baseCurrency =
        currency(userDataJson['base_currency'] ?? defaultCurrencyCode);
    bool isPremium = userDataJson['is_premium'] ?? false;
    return User(
        trips: trips,
        statistics: statistics,
        baseCurrency: baseCurrency,
        isPremiumUser: isPremium);
  }

  void setPremiumUser(bool isPremium) {
    _isPremiumUser = isPremium;
    AdManagerService().configure(isPremium);
    debugPrint(isPremium ? "User set as PREMIUM" : "Non premium user!");
  }

  void setBaseCurrency(Currency newCurrency) {
    _baseCurrency = newCurrency;
  }

  void sortTrips(SortOrder sortOrder) {
    DateTime now = DateTime.now();

    _trips.sort((lhs, rhs) {
      int result = (lhs.dateTime.difference(now))
          .abs()
          .compareTo((rhs.dateTime.difference(now)).abs());
      return sortOrder == SortOrder.ascending ? result : -result;
    });
  }

  double getWholeExpenses() {
    double totalCost = 0.0;
    for (var trip in _trips) {
      totalCost += trip.calculateTripCost();
    }
    return totalCost;
  }

  double getWholeExpensesInBaseCurrency() {
    double totalCost = 0.0;
    for (var trip in _trips) {
      totalCost += trip.sumOfEachExpenseCostInBaseCurrency();
    }
    return totalCost;
  }

  void recalculateCostInBaseCurrency() {
    for (var trip in trips) {
      trip.recalculateEachCostInBaseCurrency(_baseCurrency.code);
    }
  }

  List<Country> getVisitedCountries() {
    Set<Country> countries = {};
    for (var trip in _trips) {
      countries.addAll(trip.countries);
    }
    final sortedList = countries.toList();
    sortedList.sort((a, b) => a.displayName.compareTo(b.countryCode));

    return sortedList;
  }

  void addTrip(
      String tripName, CustomImage customImage, List<Country> countries) {
    Trip newTrip = Trip(
        name: tripName,
        customImage: customImage,
        dateTime: DateTime.now(),
        countries: countries,
        rates: {},
        expenses: []);
    _trips.insert(0, newTrip);
  }

  void deleteTrip(int tripId) {
    final int index = trips.indexWhere((trip) => trip.getId() == tripId);
    if (index != -1) {
      _trips.removeAt(index);
    } else {
      throw ("Something went wrong with Trip delete, cannot find trip of given id!");
    }
  }
}
