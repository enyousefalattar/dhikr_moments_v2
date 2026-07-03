import 'package:flutter/foundation.dart';

class LastActivityService extends ChangeNotifier {
  static final LastActivityService _instance = LastActivityService._internal();
  factory LastActivityService() => _instance;
  LastActivityService._internal();

  String? _lastAdhkar;
  String? _lastDua;
  String? _lastSurah;
  DateTime? _lastTimestamp;

  String? get lastAdhkar => _lastAdhkar;
  String? get lastDua => _lastDua;
  String? get lastSurah => _lastSurah;
  DateTime? get lastTimestamp => _lastTimestamp;

  void updateAdhkar(String title) {
    _lastAdhkar = title;
    _lastTimestamp = DateTime.now();
    notifyListeners();
  }

  void updateDua(String title) {
    _lastDua = title;
    _lastTimestamp = DateTime.now();
    notifyListeners();
  }

  void updateSurah(String title) {
    _lastSurah = title;
    _lastTimestamp = DateTime.now();
    notifyListeners();
  }
}
