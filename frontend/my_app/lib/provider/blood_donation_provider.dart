import 'package:flutter/material.dart';

class BloodDonationRequest {
  String? bloodType;
  String? location;
  String? state;
  String? address;
  String? hospitalName;
  String? date;
  String? bloodUsedFor;
  bool agreeToTerms = false;

  bool get isBloodTypeValid => bloodType != null && bloodType!.isNotEmpty;
  bool get isLocationValid => location != null && location!.isNotEmpty;
  bool get isStateValid => state != null && state!.isNotEmpty;
  bool get isAddressValid => address != null && address!.isNotEmpty;
  bool get isHospitalNameValid => hospitalName != null && hospitalName!.isNotEmpty;
  bool get isDateValid => date != null && date!.isNotEmpty;
  bool get isBloodUsedForValid => bloodUsedFor != null && bloodUsedFor!.isNotEmpty;
  
  bool get isStep1Valid => isBloodTypeValid;
  bool get isStep2Valid => isLocationValid && isStateValid && isAddressValid && isHospitalNameValid;
  bool get isStep3Valid => isDateValid && isBloodUsedForValid && agreeToTerms;
}

// Step 2: Create a provider for managing state across screens
class BloodDonationProvider extends ChangeNotifier {
  final BloodDonationRequest _request = BloodDonationRequest();
  int _currentStep = 0;
  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final List<String> _bloodUsages = ['Surgery', 'Accident', 'Cancer Treatment', 'Childbirth', 'Anemia', 'Other'];
  
  String? _step1Error;
  String? _step2Error;
  String? _step3Error;
  bool _isSubmitting = false;

  // Getters
  BloodDonationRequest get request => _request;
  int get currentStep => _currentStep;
  List<String> get bloodTypes => _bloodTypes;
  List<String> get bloodUsages => _bloodUsages;
  String? get step1Error => _step1Error;
  String? get step2Error => _step2Error;
  String? get step3Error => _step3Error;
  bool get isSubmitting => _isSubmitting;

  // Setters
  void setBloodType(String type) {
    _request.bloodType = type;
    _step1Error = null;
    notifyListeners();
  }

  void setLocation(String location) {
    _request.location = location;
    notifyListeners();
  }

  void setState(String state) {
    _request.state = state;
    notifyListeners();
  }

  void setAddress(String address) {
    _request.address = address;
    notifyListeners();
  }

  void setHospitalName(String name) {
    _request.hospitalName = name;
    notifyListeners();
  }

  void setDate(String date) {
    _request.date = date;
    notifyListeners();
  }

  void setBloodUsedFor(String purpose) {
    _request.bloodUsedFor = purpose;
    notifyListeners();
  }

  void setAgreeToTerms(bool value) {
    _request.agreeToTerms = value;
    notifyListeners();
  }

  bool validateStep1() {
    if (!_request.isBloodTypeValid) {
      _step1Error = 'Please select a blood type';
      notifyListeners();
      return false;
    }
    
    _step1Error = null;
    notifyListeners();
    return true;
  }

  bool validateStep2() {
    if (!_request.isLocationValid) {
      _step2Error = 'Please enter a location';
      notifyListeners();
      return false;
    }
    
    if (!_request.isStateValid) {
      _step2Error = 'Please enter a state';
      notifyListeners();
      return false;
    }
    
    if (!_request.isAddressValid) {
      _step2Error = 'Please enter an address';
      notifyListeners();
      return false;
    }
    
    if (!_request.isHospitalNameValid) {
      _step2Error = 'Please enter a hospital name';
      notifyListeners();
      return false;
    }
    
    _step2Error = null;
    notifyListeners();
    return true;
  }

  bool validateStep3() {
    if (!_request.isDateValid) {
      _step3Error = 'Please select a date';
      notifyListeners();
      return false;
    }
    
    if (!_request.isBloodUsedForValid) {
      _step3Error = 'Please select blood usage purpose';
      notifyListeners();
      return false;
    }
    
    if (!_request.agreeToTerms) {
      _step3Error = 'Please agree to terms and conditions';
      notifyListeners();
      return false;
    }
    
    _step3Error = null;
    notifyListeners();
    return true;
  }

  void nextStep() {
    bool isValid = false;
    
    switch (_currentStep) {
      case 0:
        isValid = validateStep1();
        break;
      case 1:
        isValid = validateStep2();
        break;
      default:
        isValid = false;
    }
    
    if (isValid) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  Future<bool> submitRequest() async {
    if (!validateStep3()) {
      return false;
    }
    
    _isSubmitting = true;
    notifyListeners();
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Reset everything after successful submission
      _request.bloodType = null;
      _request.location = null;
      _request.state = null;
      _request.address = null;
      _request.hospitalName = null;
      _request.date = null;
      _request.bloodUsedFor = null;
      _request.agreeToTerms = false;
      _currentStep = 0;
      _isSubmitting = false;
      
      notifyListeners();
      return true;
    } catch (e) {
      _step3Error = 'Failed to submit request: ${e.toString()}';
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _request.bloodType = null;
    _request.location = null;
    _request.state = null;
    _request.address = null;
    _request.hospitalName = null;
    _request.date = null;
    _request.bloodUsedFor = null;
    _request.agreeToTerms = false;
    _currentStep = 0;
    _step1Error = null;
    _step2Error = null;
    _step3Error = null;
    _isSubmitting = false;
    notifyListeners();
  }
}
