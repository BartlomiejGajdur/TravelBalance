import 'package:TravelBalance/models/custom_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:currency_picker/currency_picker.dart';
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

  void addTrip(
      String tripName, CustomImage customImage, List<Country> countries) {
    _user!.addTrip(tripName, customImage, countries);
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

  void setBaseCurrency(Currency newCurrency) {
    _user!.setBaseCurrency(newCurrency);
    _user!.recalculateCostInBaseCurrency();
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
