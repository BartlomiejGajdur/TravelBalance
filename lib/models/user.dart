import 'package:TravelBalance/models/statistics.dart';
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

  void addTrip(String tripName) {
    Trip newTrip = Trip(
        name: tripName,
        dateTime: DateTime.now(),
        image:
            "https://cdn.dribbble.com/users/476251/screenshots/2619255/attachments/523315/placeholder.png",
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
