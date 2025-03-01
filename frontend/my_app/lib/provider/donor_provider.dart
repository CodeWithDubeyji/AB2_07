import 'package:flutter/material.dart';

class Donor {
  final String name;
  final String bloodType;

  Donor({
    required this.name,
    required this.bloodType,
  });
}

// search_results_provider.dart


class SearchResultsProvider extends ChangeNotifier {
  String _searchQuery = "";
  String _selectedBloodType = "B+";
  
  List<Donor> _allDonors = [
    Donor(name: "JORGE STEPHENS", bloodType: "B+"),
    Donor(name: "MABEL PETERSON", bloodType: "B+"),
    Donor(name: "THELMA POWERS", bloodType: "B+"),
    Donor(name: "DOLORES BERRY", bloodType: "B+"),
    Donor(name: "GAIL DAY", bloodType: "B+"),
    Donor(name: "MICHAEL ELLIOTT", bloodType: "B+"),
    Donor(name: "HARRY HAWKINS", bloodType: "B+"),
    Donor(name: "ROBERTO KELLER", bloodType: "B+"),
    Donor(name: "MATHEW WILLIS", bloodType: "B+"),
    // Add more donors as needed
  ];
  
  String get searchQuery => _searchQuery;
  String get selectedBloodType => _selectedBloodType;
  
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
  
  void setSelectedBloodType(String bloodType) {
    _selectedBloodType = bloodType;
    notifyListeners();
  }
  
  List<Donor> get filteredDonors {
    return _allDonors.where((donor) {
      final matchesQuery = _searchQuery.isEmpty || 
          donor.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesBloodType = donor.bloodType == _selectedBloodType;
      return matchesQuery && matchesBloodType;
    }).toList();
  }
  
  int get resultCount => filteredDonors.length;
}