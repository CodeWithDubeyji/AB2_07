import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

enum AuthMethod { email, facebook, google, apple }

class RegistrationProvider extends ChangeNotifier {
  String _name = "";
  String _phone = "";
  String _email = "";
  String _password = "";
  String _confirmPassword = "";
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _bloodType = "";
  String _location = "";

  // Error messages
  String? _nameError;
  String? _phoneError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _bloodTypeError;

  // Getters
  String get name => _name;
  String get phone => _phone;
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  String get bloodType => _bloodType;

  String? get nameError => _nameError;
  String? get phoneError => _phoneError;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get confirmPasswordError => _confirmPasswordError;
  String? get bloodTypeError => _bloodTypeError;

  // Setters with validation
  void setName(String value) {
    _name = value;
    validateName();
    notifyListeners();
  }

  void setPhone(String value) {
    _phone = value;
    validatePhone();
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    validateEmail();
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    validatePassword();
    validateConfirmPassword();
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    validateConfirmPassword();
    notifyListeners();
  }

  void setBloodType(String value) {
    _bloodType = value;
    validateBloodType();
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  // Validation methods
  bool validateName() {
    if (_name.isEmpty) {
      _nameError = "Name is required";
      return false;
    }
    _nameError = null;
    return true;
  }

  bool validatePhone() {
    if (_phone.isEmpty) {
      _phoneError = "Phone number is required";
      return false;
    }

    final phoneRegExp = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegExp.hasMatch(_phone)) {
      _phoneError = "Enter a valid phone number";
      return false;
    }

    _phoneError = null;
    return true;
  }

  bool validateEmail() {
    if (_email.isEmpty) {
      _emailError = "Email is required";
      return false;
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(_email)) {
      _emailError = "Enter a valid email address";
      return false;
    }

    _emailError = null;
    return true;
  }

  bool validatePassword() {
    if (_password.isEmpty) {
      _passwordError = "Password is required";
      return false;
    }

    if (_password.length < 8) {
      _passwordError = "Password must be at least 8 characters";
      return false;
    }

    _passwordError = null;
    return true;
  }

  bool validateConfirmPassword() {
    if (_confirmPassword.isEmpty) {
      _confirmPasswordError = "Please confirm your password";
      return false;
    }

    if (_confirmPassword != _password) {
      _confirmPasswordError = "Passwords do not match";
      return false;
    }

    _confirmPasswordError = null;
    return true;
  }

  bool validateBloodType() {
    if (_bloodType.isEmpty) {
      _bloodTypeError = "Blood type is required";
      return false;
    }

    final validBloodTypes = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];
    if (!validBloodTypes.contains(_bloodType)) {
      _bloodTypeError = "Enter a valid blood type";
      return false;
    }

    _bloodTypeError = null;
    return true;
  }

  bool validateAll() {
    bool isNameValid = validateName();
    bool isPhoneValid = validatePhone();
    bool isEmailValid = validateEmail();
    bool isPasswordValid = validatePassword();
    bool isConfirmPasswordValid = validateConfirmPassword();
    bool isBloodTypeValid = validateBloodType();

    notifyListeners();

    return isNameValid &&
        isPhoneValid &&
        isEmailValid &&
        isPasswordValid &&
        isConfirmPasswordValid &&
        isBloodTypeValid;
  }

  Future<bool> register() async {
    if (!validateAll()) {
      return false;
    }

    // Implement actual registration logic here
    // This would typically involve an API call

    // For now, just simulate success
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> registerWithSocialMedia(AuthMethod method) async {
    // Implement social media login
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  void reset() {
    _name = "";
    _phone = "";
    _email = "";
    _password = "";
    _confirmPassword = "";
    _bloodType = "";
    _isPasswordVisible = false;
    _isConfirmPasswordVisible = false;
    _nameError = null;
    _phoneError = null;
    _emailError = null;
    _passwordError = null;
    _confirmPasswordError = null;
    _bloodTypeError = null;
    notifyListeners();
  }

  Future<bool> postRegistrationData() async {
    if (!validateAll()) {
      return false;
    }

    const String apiUrl =
        "https://ab2-07-1.onrender.com/api/users/register"; // Adjust endpoint if needed

    Map<String, dynamic> requestBody = {
      "name": _name,
      "phone": _phone,
      "email": _email,
      "password": _password,
      "bloodType": _bloodType,
      "location": {
      "type": "Point",
      "coordinates": [
        50.5946,
        10.9716
      ]
    }, // Include if needed
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Registration successful: ${response.body}");
        return true;
      } else {
        print("Registration failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error in registration: $e");
      return false;
    }
  }

  Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permission denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print(
          'Location permission permanently denied. Please enable it in settings.');
      return false;
    }
    return true;

    print('Location permission granted');
  }
}
