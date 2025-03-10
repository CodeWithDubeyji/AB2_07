// provider/blood_donation_provider.dart

import 'package:flutter/material.dart';

// Model class to store our form data
class BloodDonationFormData {
  String? bloodType;
  String? location;
  String? state;
  String? address;
  String? hospitalName;
  DateTime? date;
  String? bloodUseFor;
  bool agreeToTerms = false;
  String? urgency;

  bool get isBloodTypeValid => bloodType != null;
  
  bool get isAddressValid => 
      location != null && 
      location!.isNotEmpty && 
      state != null && 
      state!.isNotEmpty && 
      address != null && 
      address!.isNotEmpty && 
      hospitalName != null && 
      hospitalName!.isNotEmpty;
  
  bool get isRequirementValid => 
      date != null && 
      bloodUseFor != null && 
      bloodUseFor!.isNotEmpty && 
      agreeToTerms;
  
  bool get isUrgencyValid => 
      urgency != null && 
      urgency!.isNotEmpty && 
      agreeToTerms;
}

// Provider to manage form data and UI state
class BloodDonationProvider with ChangeNotifier {
  final BloodDonationFormData formData = BloodDonationFormData();
  
  // Blood type sheet
  void setBloodType(String type) {
    formData.bloodType = type;
    notifyListeners();
  }
  
  // Address sheet
  void setLocation(String location) {
    formData.location = location;
    notifyListeners();
  }
  
  void setState(String state) {
    formData.state = state;
    notifyListeners();
  }
  
  void setAddress(String address) {
    formData.address = address;
    notifyListeners();
  }
  
  void setHospitalName(String hospitalName) {
    formData.hospitalName = hospitalName;
    notifyListeners();
  }
  
  // Requirement sheet
  void setDate(DateTime date) {
    formData.date = date;
    notifyListeners();
  }
  
  void setBloodUseFor(String bloodUseFor) {
    formData.bloodUseFor = bloodUseFor;
    notifyListeners();
  }
  
  void setAgreeToTerms(bool value) {
    formData.agreeToTerms = value;
    notifyListeners();
  }
  
  // Urgency sheet
  void setUrgency(String urgency) {
    formData.urgency = urgency;
    notifyListeners();
  }
  
  // Submit form
  Future<bool> submitForm() async {
    try {
      // Here you would integrate with your backend API
      // For example:
      // final response = await http.post(
      //   Uri.parse('https://your-api.com/blood-donation'),
      //   body: json.encode({
      //     'bloodType': formData.bloodType,
      //     'location': formData.location,
      //     'state': formData.state,
      //     'address': formData.address,
      //     'hospitalName': formData.hospitalName,
      //     'date': formData.date?.toIso8601String(),
      //     'bloodUseFor': formData.bloodUseFor,
      //     'urgency': formData.urgency,
      //   }),
      //   headers: {'Content-Type': 'application/json'},
      // );
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Error submitting form: $e');
      return false;
    }
  }
  
  // For debugging - you can call this to check state
  void printCurrentState() {
    // ignore: avoid_print
    print('Current Form State:');
    // ignore: avoid_print
    print('Blood Type: ${formData.bloodType}');
    // ignore: avoid_print
    print('Location: ${formData.location}');
    // ignore: avoid_print
    print('State: ${formData.state}');
    // ignore: avoid_print
    print('Address: ${formData.address}');
    // ignore: avoid_print
    print('Hospital: ${formData.hospitalName}');
    // ignore: avoid_print
    print('Date: ${formData.date}');
    // ignore: avoid_print
    print('Blood Use: ${formData.bloodUseFor}');
    // ignore: avoid_print
    print('Agree to Terms: ${formData.agreeToTerms}');
    // ignore: avoid_print
    print('Urgency: ${formData.urgency}');
  }
}