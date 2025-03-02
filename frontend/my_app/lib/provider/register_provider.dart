import 'package:flutter/material.dart';

enum AuthMethod { email, facebook, google, apple }

class RegistrationProvider extends ChangeNotifier {
  String _name = "";
  String _phone = "";
  String _email = "";
  String _password = "";
  String _confirmPassword = "";
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  
  // Error messages
  String? _nameError;
  String? _phoneError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  
  // Getters
  String get name => _name;
  String get phone => _phone;
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  
  String? get nameError => _nameError;
  String? get phoneError => _phoneError;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get confirmPasswordError => _confirmPasswordError;
  
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
  
  bool validateAll() {
    bool isNameValid = validateName();
    bool isPhoneValid = validatePhone();
    bool isEmailValid = validateEmail();
    bool isPasswordValid = validatePassword();
    bool isConfirmPasswordValid = validateConfirmPassword();
    
    notifyListeners();
    
    return isNameValid && isPhoneValid && isEmailValid && 
           isPasswordValid && isConfirmPasswordValid;
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
    _isPasswordVisible = false;
    _isConfirmPasswordVisible = false;
    _nameError = null;
    _phoneError = null;
    _emailError = null;
    _passwordError = null;
    _confirmPasswordError = null;
    notifyListeners();
  }
}