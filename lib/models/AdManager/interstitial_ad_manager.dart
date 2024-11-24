import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdManager {
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  // Funkcja ładująca reklamę pełnoekranową
  void loadAd() {
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
          debugPrint("Reklama pełnoekranowa załadowana.");
        },
        onAdFailedToLoad: (error) {
          _isAdLoaded = false;
          debugPrint("Nie udało się załadować reklamy: $error");
        },
      ),
    );
  }

  // Funkcja wyświetlająca reklamę pełnoekranową
  Future<void> showInterstitialAd() async {
    if (_isAdLoaded && _interstitialAd != null) {
      final completer = Completer<void>();

      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          debugPrint("Reklama pełnoekranowa wyświetlona.");
        },
        onAdDismissedFullScreenContent: (ad) {
          debugPrint("Reklama pełnoekranowa zamknięta.");
          ad.dispose();
          loadAd(); // Ładowanie nowej reklamy
          completer.complete();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          debugPrint("Nie udało się wyświetlić reklamy: $error");
          ad.dispose();
          loadAd();
          completer.complete();
        },
      );

      _interstitialAd!.show();
      _isAdLoaded = false;
      _interstitialAd = null;

      await completer.future;
      debugPrint("Kontynuacja po zamknięciu reklamy.");
    } else {
      debugPrint("Reklama nie jest jeszcze załadowana.");
    }
  }
}