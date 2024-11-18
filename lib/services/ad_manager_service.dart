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

  void adOnCreateTrip(int tripsSize) async {
    if (tripsSize >= maxTripsWithoutAds) {
      await showInterstitialAd();
    }
  }

  void adOnCreateExpense(int expensesSize) async {
    if (expensesSize > 0 &&
        expensesSize % showAdAfterAddingExpensesCount == 0) {
      await showInterstitialAd();
    }
  }

  // Funkcja ładująca reklamę pełnoekranową
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-7301667226211856/9994692556',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
          print("Reklama pełnoekranowa załadowana.");
        },
        onAdFailedToLoad: (error) {
          print("Nie udało się załadować reklamy: $error");
          _isAdLoaded = false;
        },
      ),
    );
  }

  // Funkcja wyświetlająca reklamę pełnoekranową
  Future<void> showInterstitialAd() async {
    if (_isAdLoaded && _interstitialAd != null) {
      // Użyj Completer, aby czekać na zamknięcie reklamy
      final completer = Completer<void>();

      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          print("Reklama pełnoekranowa wyświetlona.");
        },
        onAdDismissedFullScreenContent: (ad) {
          print("Reklama pełnoekranowa zamknięta.");
          ad.dispose();
          loadInterstitialAd(); // Ładuj nową reklamę po zamknięciu
          completer.complete(); // Uzupełnij Completer po zamknięciu reklamy
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print("Nie udało się wyświetlić reklamy: $error");
          ad.dispose();
          loadInterstitialAd();
          completer.complete(); // Uzupełnij Completer w przypadku błędu
        },
      );

      // Wyświetl reklamę
      _interstitialAd!.show();
      _isAdLoaded = false;
      _interstitialAd = null;

      // Oczekuj na zamknięcie reklamy
      await completer.future;
      print("Kontynuuj działanie po zamknięciu reklamy.");
    } else {
      print("Reklama nie jest jeszcze załadowana.");
    }
  }
}
