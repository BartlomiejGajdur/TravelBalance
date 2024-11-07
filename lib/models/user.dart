import 'package:TravelBalance/models/custom_image.dart';
import 'package:TravelBalance/models/statistics.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:TravelBalance/models/trip.dart';

enum SortOrder { ascending, descending }

class User {
  List<Trip> _trips;
  Statistics _statistics;

  User({required List<Trip> trips, required Statistics statistics})
      : _trips = trips,
        _statistics = statistics {
    sortTrips(SortOrder.ascending);
  }

  List<Trip> get trips => _trips;
  Statistics get statistics => _statistics;

  factory User.fromJson(Map<String, dynamic> json) {
    List<Trip> trips = (json['trips'] as List)
        .map((jsonData) => Trip.fromJson(jsonData))
        .toList();
    Statistics statistics = Statistics.fromJson(json['statistics']);
    return User(trips: trips, statistics: statistics);
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
      totalCost += trip.tripCost;
    }
    return totalCost;
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
        tripCost: 0.0,
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

  printDetails() {
    debugPrint('User Trips:');
    for (var trip in _trips) {
      trip.printDetails();
    }
  }
}
