import 'package:TravelBalance/models/statistics.dart';
import 'package:flutter/material.dart';
import 'package:TravelBalance/models/trip.dart';

class User {
  List<Trip> _trips;
  Statistics _statistics;

  User({required List<Trip> trips, required Statistics statistics})
      : _trips = trips,
        _statistics = statistics;

  List<Trip> get trips => _trips;
  Statistics get statistics => _statistics;

  factory User.fromJson(Map<String, dynamic> json) {
    List<Trip> trips = (json['trips'] as List)
        .map((jsonData) => Trip.fromJson(jsonData))
        .toList();
    Statistics statistics = Statistics.fromJson(json['statistics']);
    return User(trips: trips, statistics: statistics);
  }

  void addTrip(int id, String tripName) {
    Trip newTrip = Trip(
        id: id,
        name: tripName,
        image:
            "https://cdn.dribbble.com/users/476251/screenshots/2619255/attachments/523315/placeholder.png",
        tripCost: 0.0,
        expenses: []);
    _trips.insert(0, newTrip);
  }

  void deleteTrip(int index) {
    _trips.removeAt(index);
  }

  printDetails() {
    debugPrint('User Trips:');
    for (var trip in _trips) {
      trip.printDetails();
    }
  }
}
