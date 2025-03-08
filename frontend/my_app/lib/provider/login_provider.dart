import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthMethod { email, facebook, google, apple }

class LoginProvider extends ChangeNotifier {
  String _email = "";
  String _password = "";
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isUserLoggedIn = false;

  // Error messages
  String? _emailError;
  String? _passwordError;
  String? _generalError;
  
  // Getters
  String get email => _email;
  String get password => _password;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isLoading => _isLoading;
  bool get isUserLoggedIn => _isUserLoggedIn;

  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get generalError => _generalError;

  LoginProvider() {
    _loadUserLoginStatus();
  }

  // Setters with validation
  void setEmail(String value) {
    _email = value;
    validateEmail();
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    validatePassword();
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  // Validation methods
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

    _passwordError = null;
    return true;
  }

  bool validateAll() {
    bool isEmailValid = validateEmail();
    bool isPasswordValid = validatePassword();

    notifyListeners();

    return isEmailValid && isPasswordValid;
  }

  Future<bool> login() async {
    if (!validateAll()) {
      return false;
    }

    try {
      _isLoading = true;
      _generalError = null;
      notifyListeners();

      // Mock email and password for testing
      const mockEmail = "test@example.com";
      const mockPassword = "password123";

      // Simulate a network delay
      await Future.delayed(const Duration(seconds: 1));

      // Check if the provided email and password match the mock credentials
      if (_email == mockEmail && _password == mockPassword) {
        _isUserLoggedIn = true;
        await _saveUserLoginStatus(true); // Save login status
        notifyListeners();
        return true;
      } else {
        _generalError = "Invalid email or password";
        return false;
      }
    } catch (e) {
      _generalError = "Failed to login: ${e.toString()}";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> loginWithSocialMedia(AuthMethod method) async {
    try {
      _isLoading = true;
      _generalError = null;
      notifyListeners();

      // Implement social media login logic here
      await Future.delayed(const Duration(seconds: 1));

      _isUserLoggedIn = true;
      await _saveUserLoginStatus(true); // Save login status
      notifyListeners();
      return true;
    } catch (e) {
      _generalError = "Failed to login with social media: ${e.toString()}";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveUserLoginStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isUserLoggedIn", status);
  }

  Future<bool> _loadUserLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isUserLoggedIn = prefs.getBool("isUserLoggedIn") ?? false;
    notifyListeners();
    return _isUserLoggedIn;
  }

  void logout() async {
    _isUserLoggedIn = false;
    await _saveUserLoginStatus(false); // Clear login status
    reset();
  }

  void reset() {
    _email = "";
    _password = "";
    _isPasswordVisible = false;
    _isLoading = false;
    _emailError = null;
    _passwordError = null;
    _generalError = null;
    notifyListeners();
  }
}
