import 'package:flutter/material.dart';
import 'package:wanderer/models/user.dart';
import 'package:wanderer/services/api_service.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void fetchWholeUserData() async {
    _user = await ApiService().fetchWholeUserData();
    notifyListeners();
  }

  void addTrip() {
    _user!.addTrip();
    notifyListeners();
  }
}