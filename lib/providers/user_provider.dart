import 'package:TravelBalance/models/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:TravelBalance/models/user.dart';
import 'package:TravelBalance/services/api_service.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<void> fetchWholeUserData() async {
    _user = await ApiService().fetchUserData();
    notifyListeners();
  }

  void addTrip(String tripName, CustomImage customImage) {
    _user!.addTrip(tripName, customImage);
    notifyListeners();
  }

  void setTripIdOfLastAddedTrip(int tripId) {
    assert(_user!.trips.isNotEmpty, "Trips can't be empty");
    _user!.trips[0].setId(tripId);
  }

  void deleteLastAddedTrip() {
    assert(_user!.trips.isNotEmpty, "Trips can't be empty");
    _user!.trips.removeAt(0);
    notifyListeners();
  }

  void deleteTrip(int tripId) {
    _user!.deleteTrip(tripId);
    notifyListeners();
  }

  void logout() async {
    _user = null;
    notifyListeners();
    await ApiService().logout();
  }
}
