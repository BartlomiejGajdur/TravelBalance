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
    final fetchedUser = await ApiService().fetchUserData();

    if (fetchedUser != null) {
      _user = fetchedUser;
      _user!.recalculateCostInBaseCurrency();
      notifyListeners();
    } else {
      debugPrint("Failed to fetch user data");
    }
  }

  void addTrip(
      String tripName, CustomImage customImage, List<Country> countries) {
    if (_user == null) return;
    _user!.addTrip(tripName, customImage, countries);
    notifyListeners();
  }

  void setTripIdOfLastAddedTrip(int tripId) {
    if (_user == null || _user!.trips.isEmpty) return;
    _user!.trips[0].setId(tripId);
  }

  void deleteLastAddedTrip() {
    if (_user == null || _user!.trips.isEmpty) return;
    _user!.trips.removeAt(0);
    notifyListeners();
  }

  void setBaseCurrency(Currency newCurrency) {
    if (_user == null) return;
    _user!.setBaseCurrency(newCurrency);
    _user!.recalculateCostInBaseCurrency();
    notifyListeners();
  }

  void deleteTrip(int tripId) {
    if (_user == null) return;
    _user!.deleteTrip(tripId);
    notifyListeners();
  }

  void logout() async {
    _user = null;
    notifyListeners();
    await ApiService().logout();
  }
}
