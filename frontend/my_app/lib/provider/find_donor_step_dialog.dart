import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum DonorFlowStep {
  bloodType,
  address,
  requirement,
  urgency,
  complete,
}

class DonorDataProvider extends ChangeNotifier {
  // Current step in the donor flow
  DonorFlowStep _currentStep = DonorFlowStep.bloodType;

  // Blood type selection
  String? _selectedBloodType;

  // Address information
  String _location = '';
  String _state = '';
  String _address = '';
  String _hospitalName = '';

  // Requirement information
  DateTime? _requirementDate;
  String _bloodUsedFor = '';
  bool _agreedToTerms = false;

  // Urgency information
  String _urgencyLevel = '';

  // Getters
  DonorFlowStep get currentStep => _currentStep;
  String? get selectedBloodType => _selectedBloodType;
  String get location => _location;
  String get state => _state;
  String get address => _address;
  String get hospitalName => _hospitalName;
  DateTime? get requirementDate => _requirementDate;
  String get bloodUsedFor => _bloodUsedFor;
  bool get agreedToTerms => _agreedToTerms;
  String get urgencyLevel => _urgencyLevel;

  // Move to next step
  void goToNextStep() {
    if (_currentStep == DonorFlowStep.bloodType) {
      _currentStep = DonorFlowStep.address;
    } else if (_currentStep == DonorFlowStep.address) {
      _currentStep = DonorFlowStep.requirement;
    } else if (_currentStep == DonorFlowStep.requirement) {
      _currentStep = DonorFlowStep.urgency;
    } else if (_currentStep == DonorFlowStep.urgency) {
      _currentStep = DonorFlowStep.complete;
    }
    notifyListeners();
  }

  // Go to previous step
  void goToPreviousStep() {
    if (_currentStep == DonorFlowStep.address) {
      _currentStep = DonorFlowStep.bloodType;
    } else if (_currentStep == DonorFlowStep.requirement) {
      _currentStep = DonorFlowStep.address;
    } else if (_currentStep == DonorFlowStep.urgency) {
      _currentStep = DonorFlowStep.requirement;
    }
    notifyListeners();
  }

  // Update blood type
  void selectBloodType(String bloodType) {
    _selectedBloodType = bloodType;
    notifyListeners();
  }

  // Update address information
  void updateLocation(String location) {
    _location = location;
    notifyListeners();
  }

  void updateState(String state) {
    _state = state;
    notifyListeners();
  }

  void updateAddress(String address) {
    _address = address;
    notifyListeners();
  }

  void updateHospitalName(String hospitalName) {
    _hospitalName = hospitalName;
    notifyListeners();
  }

  // Update requirement information
  void updateRequirementDate(DateTime date) {
    _requirementDate = date;
    notifyListeners();
  }

  void updateBloodUsedFor(String purpose) {
    _bloodUsedFor = purpose;
    notifyListeners();
  }

  void toggleTermsAgreement(bool agreed) {
    _agreedToTerms = agreed;
    notifyListeners();
  }

  // Update urgency level
  void updateUrgencyLevel(String level) {
    _urgencyLevel = level;
    notifyListeners();
  }

  // Submit data to backend
  Future<bool> submitDonorData() async {
    // This will be implemented to connect with your backend
    // For now, it just returns true to simulate success
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  // Reset data
  void resetData() {
    _currentStep = DonorFlowStep.bloodType;
    _selectedBloodType = null;
    _location = '';
    _state = '';
    _address = '';
    _hospitalName = '';
    _requirementDate = null;
    _bloodUsedFor = '';
    _agreedToTerms = false;
    _urgencyLevel = '';
    notifyListeners();
  }
}
