import 'package:flutter/material.dart';
import 'package:my_app/provider/login_provider.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);
    
    // Using theme colors as specified
    final primaryColor = Theme.of(context).primaryColor;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    
    // Using MediaQuery for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Determine padding based on screen size
    final horizontalPadding = screenWidth * 0.05;
    final verticalPadding = screenHeight * 0.02;
    final fieldSpacing = screenHeight * 0.02;
    
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
              SizedBox(height: screenHeight * 0.18),
              
              // Login title
              Text(
                'Log in',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              
              // Email Field
              _buildLabel('Email address', screenWidth),
              SizedBox(height: 8),
              _buildTextField(
                value: provider.email,
                hintText: 'helloworld@gmail.com',
                errorText: provider.emailError,
                onChanged: provider.setEmail,
                keyboardType: TextInputType.emailAddress,
                suffixIcon: provider.email.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.check_circle, color: Colors.grey),
                        onPressed: () {},
                      )
                    : null,
                inputBorder: inputBorder,
                focusedBorder: focusedBorder,
                errorBorder: errorBorder,
              ),
              SizedBox(height: fieldSpacing),
              
              // Password Field
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabel('Password', screenWidth),
                ],
              ),
              SizedBox(height: 8),
              _buildTextField(
                value: provider.password,
                hintText: '••••••••',
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
              
              // Forgot Password Link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Navigate to forgot password screen
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                ),
              ),
              SizedBox(height: fieldSpacing),
              
              // General Error Message (if any)
              if (provider.generalError != null)
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    provider.generalError!,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                ),
              
              // Login Button
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.06,
                child: ElevatedButton(
                  onPressed: provider.isLoading
                      ? null
                      : () async {
                          if (await provider.login()) {
                            // Navigate to home screen on success
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Login successful!')),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    disabledBackgroundColor: primaryColor.withOpacity(0.5),
                  ),
                  child: provider.isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Log in',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              
              // Divider with text
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.grey.shade300),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Or Login with',
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSocialButton(
                    icon: Icons.facebook,
                    color: Colors.blue,
                    onPressed: () => provider.loginWithSocialMedia(AuthMethod.facebook),
                    screenWidth: screenWidth,
                  ),
                  _buildSocialButton(
                    icon: Icons.g_mobiledata,
                    color: Colors.red,
                    onPressed: () => provider.loginWithSocialMedia(AuthMethod.google),
                    screenWidth: screenWidth,
                  ),
                  _buildSocialButton(
                    icon: Icons.apple,
                    color: Colors.white,
                    onPressed: () => provider.loginWithSocialMedia(AuthMethod.apple),
                    screenWidth: screenWidth,
                  ),
                ],
              ),
              
              // Register Link
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.05),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('/register');
                          // Navigate to registration screen
                        },
                        child: Text(
                          'Register',
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
  
  Widget _buildLabel(String text, double screenWidth) {
    return Text(
      text,
      style: TextStyle(
        fontSize: screenWidth * 0.035,
        fontWeight: FontWeight.w500,
      ),
    );
  }
  
  Widget _buildTextField({
    required String value,
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
      controller: TextEditingController(text: value)..selection = TextSelection.fromPosition(
        TextPosition(offset: value.length),
      ),
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
      width: screenWidth * 0.25,
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

// Blood drop custom painter (same as in registration screen)
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
