import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

// Emergency Provider
class EmergencyProvider with ChangeNotifier {
  bool _useCurrentLocation = true;
  bool _isSOSActive = false;
  int _countdownValue = 3;
  String _policeNumber = "100";
  String _ambulanceNumber = "108";
  String _personalEmergencyContact = "9876543210";
  
  bool get useCurrentLocation => _useCurrentLocation;
  bool get isSOSActive => _isSOSActive;
  int get countdownValue => _countdownValue;
  String get policeNumber => _policeNumber;
  String get ambulanceNumber => _ambulanceNumber;
  String get personalEmergencyContact => _personalEmergencyContact;
  
  void setUseCurrentLocation(bool value) {
    _useCurrentLocation = value;
    notifyListeners();
  }
  
  void startSOS() {
    _isSOSActive = true;
    _countdownValue = 3;
    notifyListeners();
  }
  
  void cancelSOS() {
    _isSOSActive = false;
    _countdownValue = 3;
    notifyListeners();
  }
  
  void decrementCountdown() {
    if (_countdownValue > 0) {
      _countdownValue--;
      notifyListeners();
    }
  }
  
  void sendEmergencyAlert() {
    // Here you would implement your API call to backend
    print('Emergency alert sent with location: $_useCurrentLocation');
    _isSOSActive = false;
    _countdownValue = 3;
    notifyListeners();
  }
  
  Future<void> callEmergencyContact(String number) async {
    // Here you would implement your call functionality
    print('Calling emergency number: $number');
  }
}

