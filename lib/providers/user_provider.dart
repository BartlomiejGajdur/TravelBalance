import 'package:TravelBalance/models/custom_image.dart';
import 'package:TravelBalance/pages/login_page.dart';
import 'package:TravelBalance/services/google_signin_service.dart';
import 'package:TravelBalance/services/secure_storage_service.dart';
import 'package:country_picker/country_picker.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:TravelBalance/models/user.dart';
import 'package:TravelBalance/services/api_service.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;
  String ErrorText = "";

  Future<void> fetchWholeUserData() async {
    ErrorText = "";
    User? fetchedUser;
    try {
      fetchedUser = await ApiService().fetchUserData();
    } catch (e) {
      ErrorText += "Fetch whole data. First Attempt: ${e.toString()}\n";
      debugPrint("Fetch whole data. First Attempt: ${e.toString()}");
      notifyListeners();
    }

    if (fetchedUser == null) {
      //Check if authentication is present (should be)
      final authS = ApiService().auth;
      ErrorText += "TOKENNNNN: ${authS.token}\n";

      if (authS.refreshToken != null)
        ErrorText += "REFRESH TOKEN: ${authS.refreshToken}\n";
      else
        ErrorText += "REFRESH TOKEN: null GG\n";

      try {
        await ApiService().refreshToken();
      } catch (e) {
        debugPrint(e.toString());
        ErrorText += "Refresh token error: ${e.toString()}";
        notifyListeners();
      }
      try {
        fetchedUser = await ApiService().fetchUserData();
      } catch (e) {
        ErrorText += "Fetch whole data. Second Attempt: ${e.toString()}\n";
        debugPrint("Fetch whole data. Second Attempt: ${e.toString()}");
        notifyListeners();
      }
    }

    if (fetchedUser == null) {
      ErrorText += "Failed to fetch. USER JEST NULL \n";
      debugPrint("Failed to fetch user data");
      return;
    }

    try {
      fetchedUser.setPremiumUser(fetchedUser.isPremiumUser);
    } catch (e) {
      debugPrint("Setting premium user failed ${e}\n");
      ErrorText += "Setting premium user failed ${e}";
    }

    _user = fetchedUser;
    _user!.recalculateCostInBaseCurrency();
    notifyListeners();
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

  void logout(BuildContext context) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );

    final loginType = ApiService().loginType;

    if (loginType == LoginType.Email) {
      await ApiService().logout();
    } else if (loginType == LoginType.Google) {
      await GoogleSignInButton.logout();
    } else if (loginType == LoginType.Apple) {/* fill with logout Apple */}

    _user = null;
    ApiService().resetAuthentication();
    SecureStorage().resetAuthentication();
    notifyListeners();
  }
}
