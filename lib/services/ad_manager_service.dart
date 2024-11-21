import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';

// Konfiguracja limitów reklam
const int maxTripsWithoutAds = 2;
const int showAdAfterAddingExpensesCount = 5;

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

class BannerAdManager {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  void loadAd() {
    final String adUnitId = Platform.isAndroid
        ? 'ca-app-pub-7301667226211856/2946740920'
        : 'ca-app-pub-7301667226211856/4168323258';

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _isAdLoaded = true;
          debugPrint("Reklama banerowa załadowana.");
        },
        onAdFailedToLoad: (ad, error) {
          _isAdLoaded = false;
          ad.dispose();
          debugPrint("Nie udało się załadować reklamy banerowej: $error");
        },
      ),
    );

    _bannerAd!.load();
  }

  // Funkcja zwracająca widżet reklamy banerowej
  Widget getAdWidget() {
    if (_isAdLoaded && _bannerAd != null) {
      return Container(
        alignment: Alignment.center,
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    } else {
      debugPrint("Reklama banerowa nie jest jeszcze gotowa.");
      return const SizedBox();
    }
  }

  // Funkcja usuwająca zasoby związane z reklamą
  void disposeAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _isAdLoaded = false;
    debugPrint("Reklama banerowa została usunięta.");
  }
}

// Klasa zarządzająca logiką wyświetlania reklam
class AdManagerService {
  static final AdManagerService _instance = AdManagerService._internal();
  final InterstitialAdManager _interstitialAdManager = InterstitialAdManager();
  final BannerAdManager _bannerAdManager = BannerAdManager();

  AdManagerService._internal();

  factory AdManagerService() => _instance;

  InterstitialAdManager get interstitialAdManager => _interstitialAdManager;
  BannerAdManager get bannerAdManager => _bannerAdManager;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    debugPrint("Google Mobile Ads zainicjalizowane.");
    _interstitialAdManager.loadAd();
    _bannerAdManager.loadAd();
  }

  void adOnCreateTrip(BuildContext context, int tripsSize) async {
    if (tripsSize >= maxTripsWithoutAds) {
      await _interstitialAdManager.showInterstitialAd();
    }
  }

  void adOnCreateExpense(BuildContext context, int expensesSize) async {
    if (expensesSize > 0 &&
        expensesSize % showAdAfterAddingExpensesCount == 0) {
      await _interstitialAdManager.showInterstitialAd();
    }
  }
}
