import 'package:flutter/foundation.dart';

class ProfileProvider extends ChangeNotifier {
  bool _isAvailable = false;
  String _activeTab = 'active_requests';
  int _expandedCardIndex = -1;

  bool get isAvailable => _isAvailable;
  String get activeTab => _activeTab;
  int get expandedCardIndex => _expandedCardIndex;

  void toggleAvailability() {
    _isAvailable = !_isAvailable;
    notifyListeners();
  }

  void setActiveTab(String tabId) {
    _activeTab = tabId;
    notifyListeners();
  }

  void expandCard(int index) {
    if (_expandedCardIndex == index) {
      _expandedCardIndex = -1;
    } else {
      _expandedCardIndex = index;
    }
    notifyListeners();
  }
}
