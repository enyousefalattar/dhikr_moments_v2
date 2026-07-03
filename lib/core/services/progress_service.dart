import 'package:flutter/foundation.dart';

class ProgressService extends ChangeNotifier {
  static final ProgressService _instance = ProgressService._internal();
  factory ProgressService() => _instance;
  ProgressService._internal();

  int _adhkarCount = 0;
  int _duasCount = 0;

  int get adhkarCount => _adhkarCount;
  int get duasCount => _duasCount;

  void incrementAdhkar() {
    _adhkarCount++;
    notifyListeners();
  }

  void incrementDuas() {
    _duasCount++;
    notifyListeners();
  }

  void resetDaily() {
    _adhkarCount = 0;
    _duasCount = 0;
    notifyListeners();
  }
}
