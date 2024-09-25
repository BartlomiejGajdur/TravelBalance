import 'package:flutter/material.dart';
import 'package:TravelBalance/models/trip.dart';

class User {
  List<Trip> _trips;

  User({required List<Trip> trips}) : _trips = trips;

  List<Trip> get trips => _trips;

  factory User.fromJson(List<dynamic> jsonList) {
    List<Trip> trips =
        jsonList.map((jsonData) => Trip.fromJson(jsonData)).toList();
    return User(trips: trips);
  }

  void addTrip(String tripName) {
    Trip newTrip =
        Trip(id: 2, name: tripName, image: null, tripCost: 0.0, expenses: []);
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
