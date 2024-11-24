import 'package:TravelBalance/models/AdManager/ad_manager.dart';

class AdManagerService {
  static final AdManagerService _instance = AdManagerService._internal();
  factory AdManagerService() => _instance;

  late IAdManager _adManager;
  bool _isInitialized = false;

  AdManagerService._internal() {
    _adManager = AdManager();
  }

  void configure(bool isPremium) {
    _adManager = isPremium ? DummyAdManager() : AdManager();
    _adManager.initialize();
    _isInitialized = true;
  }

  IAdManager manager() {
    if (!_isInitialized) throw Exception("AdManager is not initialized!");
    return _adManager;
  }
}
