import 'package:flutter/material.dart';
import 'package:my_app/provider/register_provider.dart';
import 'package:provider/provider.dart';


class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    
    // Using theme colors as specified
    final primaryColor = Theme.of(context).primaryColor;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    
    // Using MediaQuery for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Determine padding based on screen size
    final horizontalPadding = screenWidth * 0.05;
    final verticalPadding = screenHeight * 0.02;
    final fieldSpacing = screenHeight * 0.018;
    
    // Text field border styling
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );
    
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: primaryColor),
    );
    
    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.red),
    );
    
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with logo
              Center(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    // Blood drop icon
                    
                    SizedBox(height: screenHeight * 0.01),
                    // Register title
                    Text(
                      'Register',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              ),
              
              // Name Field
              _buildLabel('Name', primaryColor, screenWidth),
              SizedBox(height: fieldSpacing * 0.5),
              _buildTextField(
                hintText: 'Your Name',
                errorText: provider.nameError,
                onChanged: provider.setName,
                inputBorder: inputBorder,
                focusedBorder: focusedBorder,
                errorBorder: errorBorder,
              ),
              SizedBox(height: fieldSpacing),
              
              // Phone Field
              _buildLabel('Phone', primaryColor, screenWidth),
              SizedBox(height: fieldSpacing * 0.5),
              _buildTextField(
                hintText: '+91-',
                errorText: provider.phoneError,
                onChanged: provider.setPhone,
                keyboardType: TextInputType.phone,
                inputBorder: inputBorder,
                focusedBorder: focusedBorder,
                errorBorder: errorBorder,
              ),
              SizedBox(height: fieldSpacing),
              
              // Email Field
              _buildLabel('Email', primaryColor, screenWidth),
              SizedBox(height: fieldSpacing * 0.5),
              _buildTextField(
                hintText: 'example@gmail.com',
                errorText: provider.emailError,
                onChanged: provider.setEmail,
                keyboardType: TextInputType.emailAddress,
                inputBorder: inputBorder,
                focusedBorder: focusedBorder,
                errorBorder: errorBorder,
              ),
              SizedBox(height: fieldSpacing),
              
              // Password Field
              _buildLabel('Create a password', primaryColor, screenWidth),
              SizedBox(height: fieldSpacing * 0.5),
              _buildTextField(
                hintText: 'must be 8 characters',
                errorText: provider.passwordError,
                onChanged: provider.setPassword,
                obscureText: !provider.isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    provider.isPasswordVisible 
                      ? Icons.visibility
                      : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: provider.togglePasswordVisibility,
                ),
                inputBorder: inputBorder,
                focusedBorder: focusedBorder,
                errorBorder: errorBorder,
              ),
              SizedBox(height: fieldSpacing),
              
              // Confirm Password Field
              _buildLabel('Confirm password', primaryColor, screenWidth),
              SizedBox(height: fieldSpacing * 0.5),
              _buildTextField(
                hintText: 'repeat password',
                errorText: provider.confirmPasswordError,
                onChanged: provider.setConfirmPassword,
                obscureText: !provider.isConfirmPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    provider.isConfirmPasswordVisible 
                      ? Icons.visibility
                      : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: provider.toggleConfirmPasswordVisibility,
                ),
                inputBorder: inputBorder,
                focusedBorder: focusedBorder,
                errorBorder: errorBorder,
              ),
              SizedBox(height: screenHeight * 0.03),
              
              // Register Button
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  onPressed: () async {
                    if (await provider.register()) {
                      // Navigate to next screen on success
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Registration successful!')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              // Divider with text
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.grey.shade300),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Or Register with',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.grey.shade300),
                    ),
                  ],
                ),
              ),
              
              // Social Media Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton(
                    icon: Icons.facebook,
                    color: Colors.blue,
                    onPressed: () => provider.registerWithSocialMedia(AuthMethod.facebook),
                    screenWidth: screenWidth,
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  _buildSocialButton(
                    icon: Icons.g_mobiledata,
                    color: Colors.red,
                    onPressed: () => provider.registerWithSocialMedia(AuthMethod.google),
                    screenWidth: screenWidth,
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  _buildSocialButton(
                    icon: Icons.apple,
                    color: Colors.white,
                    onPressed: () => provider.registerWithSocialMedia(AuthMethod.apple),
                    screenWidth: screenWidth,
                  ),
                ],
              ),
              
              // Login Link
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.03),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                          // Navigate to login screen
                        },
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildLabel(String text, Color color, double screenWidth) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: screenWidth * 0.035,
        fontWeight: FontWeight.w500,
      ),
    );
  }
  
  Widget _buildTextField({
    required String hintText,
    required Function(String) onChanged,
    String? errorText,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    required OutlineInputBorder inputBorder,
    required OutlineInputBorder focusedBorder,
    required OutlineInputBorder errorBorder,
  }) {
    return TextField(
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        errorText: errorText,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        suffixIcon: suffixIcon,
      ),
    );
  }
  
  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required double screenWidth,
  }) {
    return Container(
      width: screenWidth * 0.15,
      height: screenWidth * 0.12,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: onPressed,
      ),
    );
  }
}

// Blood drop custom painter
class BloodDropPainter extends CustomPainter {
  final Color color;
  
  BloodDropPainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final path = Path();
    
    // Draw a blood drop shape
    path.moveTo(size.width / 2, 0);
    path.quadraticBezierTo(
      size.width * 0.1, size.height * 0.5, 
      size.width / 2, size.height
    );
    path.quadraticBezierTo(
      size.width * 0.9, size.height * 0.5, 
      size.width / 2, 0
    );
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
