import 'package:flutter/material.dart';
import 'package:TravelBalance/models/user.dart';
import 'package:TravelBalance/services/api_service.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<void> fetchWholeUserData() async {
    _user = await ApiService().fetchUserData();
    _user!.printDetails();
    notifyListeners();
  }

  void addTrip(String tripName) {
    _user!.addTrip(tripName);
    notifyListeners();
  }

  void deleteTrip(int index) {
    _user!.deleteTrip(index);
    notifyListeners();
  }

  void logout() async {
    _user = null;
    notifyListeners();
    await ApiService().logout();
  }
}
