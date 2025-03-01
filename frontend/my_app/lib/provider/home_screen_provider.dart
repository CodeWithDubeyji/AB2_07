import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  // User info
  final String userName = "DHRUV CHAUHAN";
  final String bloodGroup = "B-";
  
  // Profile info - added new section for profile data
  final String userProfileName = "FELIX GORDON"; // Used in profile screen
  final String userProfilePhoto = ""; // Would contain URL in real app
  
  // Data for carousel cards
  final List<Map<String, dynamic>> carouselItems = [
    {
      'type': 'message',
      'title': 'YOUR BLOOD',
      'subtitle': 'MAKE SOMEONE HAPPY',
      'actionText': 'READ STORY',
      'hasImage': true,
    },
    {
      'type': 'event',
      'title': 'BLOOD DONATION DRIVE',
      'date': '31 JULY',
      'time': '10:00 AM ONWARDS',
      'hasImage': false,
    }
  ];
  
  // Data for donation requests
  final List<Map<String, dynamic>> donationRequests = [
    {
      'name': 'DHRUV CHAUHAN',
      'hospital': 'RAJHANS MULTI SPECIALITY HOSPITAL',
      'bloodGroup': 'B-',
      'timeAgo': '5 MIN AGO',
    },
    {
      'name': 'ANJALI SHARMA',
      'hospital': 'CITY CARE HOSPITAL',
      'bloodGroup': 'A+',
      'timeAgo': '15 MIN AGO',
    },
    {
      'name': 'ROHIT PATEL',
      'hospital': 'METRO HOSPITAL',
      'bloodGroup': 'O-',
      'timeAgo': '30 MIN AGO',
    },
  ];
  
  // Selected tab index
  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;
  
  // Theme mode
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;
  
  // Current carousel page
  int _currentCarouselPage = 0;
  int get currentCarouselPage => _currentCarouselPage;
  
  // Getters for carousel
  int get carouselItemCount => carouselItems.length;
  
  // Functions
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
  
  void setSelectedTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }
  
  void setCurrentCarouselPage(int index) {
    _currentCarouselPage = index;
    notifyListeners();
  }
  
  // Exception handling
  String? errorMessage;
  bool isLoading = false;
  
  // Mock function to fetch data
  Future<void> fetchData() async {
    try {
      isLoading = true;
      notifyListeners();
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Reset error message if successful
      errorMessage = null;
    } catch (e) {
      errorMessage = "Failed to load data: ${e.toString()}";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  // Mock function to handle donation request
  Future<void> handleDonationRequest(int index) async {
    try {
      isLoading = true;
      notifyListeners();
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Reset error message if successful
      errorMessage = null;
    } catch (e) {
      errorMessage = "Failed to process request: ${e.toString()}";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}