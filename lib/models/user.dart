import 'package:flutter/material.dart';
import 'package:wanderer/models/trip.dart';

class User {
  List<Trip>? _trips;

  User({required List<Trip> trips}) : _trips = trips;

  List<Trip>? get trips => _trips;

  factory User.fromJson(List<dynamic> jsonList) {
    List<Trip> trips =
        jsonList.map((jsonData) => Trip.fromJson(jsonData)).toList();
    return User(trips: trips);
  }

  void addTrip() {
    Trip newTrip = Trip(
        id: 2,
        name: "NOWY",
        image: "hakis Path",
        tripCost: 23.23,
        expenses: []);
    _trips!.insert(0, newTrip);
  }

  void deleteTrip(int index) {
    _trips?.removeAt(index);
  }

  printDetails() {
    debugPrint('User Trips:');
    for (var trip in _trips!) {
      trip.printDetails();
    }
  }
}
