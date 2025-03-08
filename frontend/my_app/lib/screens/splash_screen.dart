import 'package:flutter/material.dart';
import 'package:my_app/provider/login_provider.dart';
import 'package:my_app/screens/login.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'home_screen.dart'; // Import your home screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );
    
    // Start animation
    _animationController.forward();
    
    // Timer to navigate to home screen after splash screen
    Timer(const Duration(seconds: 3), () async {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            final loginProvider = Provider.of<LoginProvider>(context, listen: false);
            return loginProvider.isUserLoggedIn ? HomeScreen() : LoginScreen();
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get theme from provider
    final theme = Theme.of(context);
    
    // Get screen size for responsive design
    final screenSize = MediaQuery.of(context).size;
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    
    // Determine if the device is a tablet
    final isTablet = shortestSide >= 600;
    
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Container(
              width: screenSize.width,
              height: screenSize.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primaryContainer,
                  ],
                ),
              ),
              child: Center(
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo and app icon
                        Container(
                          width: isTablet ? 200 : 150,
                          height: isTablet ? 200 : 150,
                          padding: EdgeInsets.all(isTablet ? 20 : 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.volunteer_activism,
                              size: isTablet ? 100 : 80,
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ),
                        SizedBox(height: isTablet ? 40 : 30),
                        // App name
                        Text(
                          'RAKTVEER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 36 : 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                        SizedBox(height: isTablet ? 20 : 15),
                        // App tagline
                        Text(
                          'Connecting Blood Donors & Recipients',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: isTablet ? 18 : 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: isTablet ? 60 : 40),
                        // Loading indicator
                        SizedBox(
                          width: isTablet ? 40 : 30,
                          height: isTablet ? 40 : 30,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}