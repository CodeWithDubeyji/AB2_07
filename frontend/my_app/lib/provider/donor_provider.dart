import 'package:flutter/material.dart';



class Donor {
  final String id;
  final String name;
  final String bloodType;
  final int donated;
  final int requested;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String profileImageUrl;
  final bool isAvailableForDonate;
  final String phoneNumber;

  Donor({
    required this.id,
    required this.name,
    required this.bloodType,
    this.donated = 0,
    this.requested = 0,
    this.address = '',
    this.city = '',
    this.state = '',
    this.zipCode = '',
    this.profileImageUrl = 'assets/images/default_profile.jpg',
    this.isAvailableForDonate = true,
    this.phoneNumber = '',
  });
}



class SearchResultsProvider extends ChangeNotifier {
  String _searchQuery = "";
  String _selectedBloodType = "B+";
  Donor? _selectedDonor;

  // Expanded donor data with all required information
  List<Donor> _allDonors = [
    Donor(
      id: '1',
      name: "JORGE STEPHENS",
      bloodType: "B+",
      donated: 15,
      requested: 3,
      address: "4782 Broadway Ave.",
      city: "Los Angeles",
      state: "California",
      zipCode: "90021",
      profileImageUrl: "assets/images/jorge.jpg",
      isAvailableForDonate: true,
      phoneNumber: "+1 (213) 555-1234",
    ),
    Donor(
      id: '2',
      name: "MABEL PETERSON",
      bloodType: "B+",
      donated: 20,
      requested: 2,
      address: "3891 Ranchview Dr.",
      city: "Richardson",
      state: "California",
      zipCode: "62639",
      profileImageUrl: "assets/images/mabel.jpg",
      isAvailableForDonate: true,
      phoneNumber: "+1 (310) 555-9876",
    ),
    Donor(
      id: '3',
      name: "THELMA POWERS",
      bloodType: "B+",
      donated: 8,
      requested: 1,
      address: "1642 Parkway St.",
      city: "San Francisco",
      state: "California",
      zipCode: "94107",
      profileImageUrl: "assets/images/thelma.jpg",
      isAvailableForDonate: false,
      phoneNumber: "+1 (415) 555-3421",
    ),
    Donor(
      id: '4',
      name: "DOLORES BERRY",
      bloodType: "B+",
      donated: 12,
      requested: 0,
      address: "7821 Cedar Ln.",
      city: "Oakland",
      state: "California",
      zipCode: "94601",
      profileImageUrl: "assets/images/dolores.jpg",
      isAvailableForDonate: true,
      phoneNumber: "+1 (510) 555-7890",
    ),
    Donor(
      id: '5',
      name: "GAIL DAY",
      bloodType: "B+",
      donated: 5,
      requested: 1,
      address: "2351 Maple Ave.",
      city: "Sacramento",
      state: "California",
      zipCode: "95814",
      profileImageUrl: "assets/images/gail.jpg",
      isAvailableForDonate: true,
      phoneNumber: "+1 (916) 555-2345",
    ),
    Donor(
      id: '6', 
      name: "MICHAEL ELLIOTT",
      bloodType: "B+",
      donated: 18,
      requested: 4,
      address: "914 Sunset Blvd.",
      city: "San Diego",
      state: "California",
      zipCode: "92101",
      profileImageUrl: "assets/images/michael.jpg",
      isAvailableForDonate: true,
      phoneNumber: "+1 (619) 555-4567",
    ),
    Donor(
      id: '7',
      name: "HARRY HAWKINS",
      bloodType: "B+",
      donated: 9,
      requested: 2,
      address: "5432 Ocean View Dr.",
      city: "Santa Monica",
      state: "California",
      zipCode: "90401",
      profileImageUrl: "assets/images/harry.jpg",
      isAvailableForDonate: false,
      phoneNumber: "+1 (424) 555-6789",
    ),
    Donor(
      id: '8',
      name: "ROBERTO KELLER",
      bloodType: "B+",
      donated: 14,
      requested: 1,
      address: "2701 Mission St.",
      city: "San Francisco",
      state: "California",
      zipCode: "94110",
      profileImageUrl: "assets/images/roberto.jpg",
      isAvailableForDonate: true,
      phoneNumber: "+1 (415) 555-8901",
    ),
    Donor(
      id: '9',
      name: "MATHEW WILLIS",
      bloodType: "B+",
      donated: 7,
      requested: 0,
      address: "3589 Wilshire Blvd.",
      city: "Los Angeles",
      state: "California",
      zipCode: "90010",
      profileImageUrl: "assets/images/mathew.jpg",
      isAvailableForDonate: true,
      phoneNumber: "+1 (213) 555-2109",
    ),
  ];

  String get searchQuery => _searchQuery;
  String get selectedBloodType => _selectedBloodType;
  Donor? get selectedDonor => _selectedDonor;

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

  // New methods for donor profile functionality
  void selectDonor(String donorId) {
    _selectedDonor = _allDonors.firstWhere(
      (donor) => donor.id == donorId,
      orElse: () => _allDonors.first, // Default to first donor if not found
    );
    notifyListeners();
  }

  Donor getDonorById(String donorId) {
    return _allDonors.firstWhere(
      (donor) => donor.id == donorId,
      orElse: () => _allDonors.first, // Default to first donor if not found
    );
  }

  // Method to update donor's availability status
  void updateDonorAvailability(String donorId, bool isAvailable) {
    final index = _allDonors.indexWhere((donor) => donor.id == donorId);
    
    if (index != -1) {
      final donor = _allDonors[index];
      _allDonors[index] = Donor(
        id: donor.id,
        name: donor.name,
        bloodType: donor.bloodType,
        donated: donor.donated,
        requested: donor.requested,
        address: donor.address,
        city: donor.city,
        state: donor.state,
        zipCode: donor.zipCode,
        profileImageUrl: donor.profileImageUrl,
        isAvailableForDonate: isAvailable,
        phoneNumber: donor.phoneNumber,
      );
      
      // Update selected donor if it's the one being modified
      if (_selectedDonor?.id == donorId) {
        _selectedDonor = _allDonors[index];
      }
      
      notifyListeners();
    }
  }
}