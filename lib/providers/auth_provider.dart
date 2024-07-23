import 'package:flutter/foundation.dart';
import 'package:TravelBalance/services/api_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    setLoading(true);
    bool success = await ApiService().login(username, password);
    setLoading(false);
    return success;
  }
}
