import 'package:flutter/material.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/screens/profile.dart';


class NavigationUtils {
  // Navigate to home screen
  static void navigateToHome(BuildContext context, {bool replace = false}) {
    if (replace) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }
  
  // Navigate to profile screen
  static void navigateToProfile(BuildContext context, {bool replace = false}) {
    if (replace) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }
}