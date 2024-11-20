import 'dart:io';

import 'package:TravelBalance/Utils/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';

final int maxTripsWithoutAds = 2;
final int showAdAfterAddingExpensesCount = 5;

class AdManagerService {
  static final AdManagerService _instance = AdManagerService._internal();
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  AdManagerService._internal();

  factory AdManagerService() {
    return _instance;
  }

  // Inicjalizacja Google Mobile Ads
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    print("Google Mobile Ads zainicjalizowane.");
  }

  void adOnCreateTrip(BuildContext context, int tripsSize) async {
    if (tripsSize >= maxTripsWithoutAds) {
      await showInterstitialAd(context);
    }
  }

  void adOnCreateExpense(BuildContext context, int expensesSize) async {
    if (expensesSize > 0 &&
        expensesSize % showAdAfterAddingExpensesCount == 0) {
      await showInterstitialAd(context);
    }
  }

  // Funkcja ładująca reklamę pełnoekranową
  void loadInterstitialAd(BuildContext context) {
    final String adUnitId = Platform.isAndroid
        ? 'ca-app-pub-7301667226211856/9994692556'
        : 'ca-app-pub-7301667226211856/6111950571';

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
          // showCustomSnackBar(
          //   context: context,
          //   message: "Reklama pełnoekranowa załadowana.",
          //   type: SnackBarType.correct,
          // );
        },
        onAdFailedToLoad: (error) {
          _isAdLoaded = false;
          // showCustomSnackBar(
          //   context: context,
          //   message: "Nie udało się załadować reklamy: $error",
          //   type: SnackBarType.error,
          // );
        },
      ),
    );
  }

  // Funkcja wyświetlająca reklamę pełnoekranową
  Future<void> showInterstitialAd(BuildContext context) async {
    if (_isAdLoaded && _interstitialAd != null) {
      // Użyj Completer, aby czekać na zamknięcie reklamy
      final completer = Completer<void>();

      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          // showCustomSnackBar(
          //   context: context,
          //   message: "Reklama pełnoekranowa wyświetlona.",
          //   type: SnackBarType.information,
          // );
        },
        onAdDismissedFullScreenContent: (ad) {
          // showCustomSnackBar(
          //   context: context,
          //   message: "Reklama pełnoekranowa zamknięta.",
          //   type: SnackBarType.information,
          // );
          ad.dispose();
          loadInterstitialAd(context); // Ładuj nową reklamę po zamknięciu
          completer.complete(); // Uzupełnij Completer po zamknięciu reklamy
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          // showCustomSnackBar(
          //   context: context,
          //   message: "Nie udało się wyświetlić reklamy: $error",
          //   type: SnackBarType.error,
          // );
          ad.dispose();
          loadInterstitialAd(context);
          completer.complete(); // Uzupełnij Completer w przypadku błędu
        },
      );

      // Wyświetl reklamę
      _interstitialAd!.show();
      _isAdLoaded = false;
      _interstitialAd = null;

      // Oczekuj na zamknięcie reklamy
      await completer.future;
      // showCustomSnackBar(
      //   context: context,
      //   message: "Kontynuuj działanie po zamknięciu reklamy.",
      //   type: SnackBarType.correct,
      // );
    } else {
      // showCustomSnackBar(
      //   context: context,
      //   message: "Reklama nie jest jeszcze załadowana.",
      //   type: SnackBarType.error,
      // );
    }
  }
}
