import 'package:TravelBalance/models/AdManager/banner_ad_manager.dart';
import 'package:TravelBalance/models/AdManager/interstitial_ad_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class IAdManager {
  Future<void> initialize();
  void onCreateTrip(int tripsSize);
  void onCreateExpense(int expensesSize);
  Widget bannerAd();
  void disposeBannerAd();
}

class AdManager extends IAdManager {
  static final AdManager _instance = AdManager._internal();
  factory AdManager() => _instance;
  AdManager._internal();

  final int maxTripsWithoutAds = 2;
  final int showAdAfterAddingExpensesCount = 5;
  final InterstitialAdManager _interstitialAdManager = InterstitialAdManager();
  final BannerAdManager _bannerAdManager = BannerAdManager();

  InterstitialAdManager get interstitialAdManager => _interstitialAdManager;
  BannerAdManager get bannerAdManager => _bannerAdManager;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    debugPrint("Real Ad Manager: Initialize / load Interstitial / load Banner");
    _interstitialAdManager.loadAd();
    _bannerAdManager.loadAd();
  }

  void onCreateTrip(int tripsSize) async {
    debugPrint("Real Ad Manager: On Create Trip");
    if (tripsSize >= maxTripsWithoutAds) {
      await _interstitialAdManager.showInterstitialAd();
    }
  }

  void onCreateExpense(int expensesSize) async {
    debugPrint("Real Ad Manager: On Create Expense");
    if (expensesSize > 0 &&
        expensesSize % showAdAfterAddingExpensesCount == 0) {
      await _interstitialAdManager.showInterstitialAd();
    }
  }

  Widget bannerAd() {
    debugPrint("Real Ad Manager: Banner AD");
    return _bannerAdManager.getAdWidget();
  }

  void disposeBannerAd() {
    debugPrint("Real Ad Manager: Banner AD dispose");
    _bannerAdManager.disposeAd();
  }
}

class DummyAdManager extends IAdManager {
  Future<void> initialize() async {
    debugPrint("Initialize Dummy Ad Manager");
  }

  void onCreateTrip(int tripsSize) {
    debugPrint("Dummy Ad Manager: On Create Trip");
  }

  void onCreateExpense(int expensesSize) {
    debugPrint("Dummy Ad Manager: On Create Expense");
  }

  Widget bannerAd() {
    debugPrint("Dummy Ad Manager: Banner AD");
    return SizedBox();
  }

  void disposeBannerAd() {
    debugPrint("Dummy Ad Manager: Banner AD dispose");
  }
}
