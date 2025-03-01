import 'package:flutter/material.dart';

// Enum for possible donation states
enum DonationStatus {
  initial,
  loading,
  success,
  error,
}

class DonateProvider extends ChangeNotifier {
  // Form field values
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedAmPm = "AM";
  String? _selectedTimeNeeded;
  String? _selectedLocation;

  String? _selectedCampaign;
  List<String> availableCampaigns = ["abara", "bbara", "cbara", "dbara", "ebara", "fbara", "gbara", "hbara", "ibara", "jbara", "kbara", "lbara", "mbara", "nbara", "obara", "pbara", "qbara", "rbara", "sbara", "tbara", "ubara", "vbara", "wbara", "xbara", "ybara", "zbara"];

  String? get selectedCampaign => _selectedCampaign;

  void setSelectedCampaign(String? campaign) {
    _selectedCampaign = campaign;
    notifyListeners();
  }
  
  // Status and error handling
  DonationStatus _status = DonationStatus.initial;
  String _errorMessage = '';

  // Getters
  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;
  String get selectedAmPm => _selectedAmPm;
  String? get selectedTimeNeeded => _selectedTimeNeeded;
  String? get selectedLocation => _selectedLocation;
  DonationStatus get status => _status;
  String get errorMessage => _errorMessage;

  // Check if all required fields are filled
  bool get isFormValid => 
      _selectedDate != null && 
      _selectedTime != null && 
      _selectedTimeNeeded != null && 
      _selectedLocation != null;

  // Formatted time string (e.g. "2:30 PM")
  String? get formattedTime {
    if (_selectedTime == null) return null;
    
    final hour = _selectedAmPm == "PM" && _selectedTime!.hour != 12 
        ? _selectedTime!.hour + 12 
        : (_selectedAmPm == "AM" && _selectedTime!.hour == 12 
            ? 0 
            : _selectedTime!.hour);
    
    final minute = _selectedTime!.minute.toString().padLeft(2, '0');
    return "$hour:$minute $_selectedAmPm";
  }

  // Formatted date string (e.g. "Mar 1, 2025")
  String? get formattedDate {
    if (_selectedDate == null) return null;
    
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return "${months[_selectedDate!.month - 1]} ${_selectedDate!.day}, ${_selectedDate!.year}";
  }

  // Setters
  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setTime(TimeOfDay time) {
    _selectedTime = time;
    notifyListeners();
  }

  void setAmPm(String amPm) {
    _selectedAmPm = amPm;
    notifyListeners();
  }

  void setTimeNeeded(String timeNeeded) {
    _selectedTimeNeeded = timeNeeded;
    notifyListeners();
  }

  void setLocation(String location) {
    _selectedLocation = location;
    notifyListeners();
  }

  // Reset all form fields
  void resetForm() {
    _selectedDate = null;
    _selectedTime = null;
    _selectedAmPm = "AM";
    _selectedTimeNeeded = null;
    _selectedLocation = null;
    _status = DonationStatus.initial;
    _errorMessage = '';
    notifyListeners();
  }

  // Submit donation
  Future<bool> submitDonation() async {
    if (!isFormValid) {
      _status = DonationStatus.error;
      _errorMessage = 'Please fill all required fields';
      notifyListeners();
      return false;
    }
    
    try {
      _status = DonationStatus.loading;
      notifyListeners();
      
      // Here you would typically make an API call to submit the donation
      // For example:
      // await apiService.scheduleDonation(
      //   date: _selectedDate!,
      //   time: formattedTime!,
      //   timeNeeded: _selectedTimeNeeded!,
      //   location: _selectedLocation!,
      // );
      
      // Simulate API call with delay
      await Future.delayed(const Duration(seconds: 1));
      
      _status = DonationStatus.success;
      notifyListeners();
      
      // Reset form after successful submission if needed
      // resetForm();
      
      return true;
    } catch (e) {
      _status = DonationStatus.error;
      _errorMessage = 'Failed to schedule donation: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
}