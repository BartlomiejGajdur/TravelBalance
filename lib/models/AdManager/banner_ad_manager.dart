import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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