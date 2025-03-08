import 'package:flutter/material.dart';

class FindDonorsProvider extends ChangeNotifier {
  double _distance = 5.0;
  String _selectedBloodType = '';

  double get distance => _distance;
  String get selectedBloodType => _selectedBloodType;

  void updateDistance(double value) {
    _distance = value;
    notifyListeners();
  }

  void selectBloodType(String bloodType) {
    _selectedBloodType = bloodType;
    notifyListeners();
  }
}