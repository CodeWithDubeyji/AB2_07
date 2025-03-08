// hospital_model.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Hospital {
  final String name;
  final String address;
  final String history;
  final String imageUrl;
  final String phoneNumber;

  Hospital({
    required this.name,
    required this.address,
    required this.history,
    required this.imageUrl,
    required this.phoneNumber,
  });
}

// hospital_provider.dart


class HospitalProvider extends ChangeNotifier {
  final List<Hospital> _hospitals = [
    Hospital(
      name: 'COOPER HOSPITAL',
      address: 'WARD NO.456,COOPER HOSPITAL,VILE PARLE (W),MUMBAI,MAHARASHTRA,INDIA.',
      history: 'THE MADUMAN GROUP, A PROMINENT FAMILY GROUP FROM PADUBIDRI, ORGANIZED A SUCCESSFUL BLOOD DONATION DRIVE AT AL MANA HOSPITAL IN JUBAIL, SAUDI ARABIA. THIS INITIATIVE SHOWCASED THE GROUP\'S COMMITMENT TO SOCIAL SERVICE AND HUMANITARIAN CAUSES, REINFORCING THE VALUES OF UNITY AND COMPASSION',
      imageUrl: 'assets/images/cooper_hospital.jpg',
      phoneNumber: '+91 22 2626 7500',
    ),
    Hospital(
      name: 'LILAVATI HOSPITAL',
      address: 'A-791, Bandra Reclamation, Bandra West, Mumbai, Maharashtra, India.',
      history: 'Founded in 1978 by Kirtilal Manilal Mehta, Lilavati Hospital has grown to become one of Mumbai\'s premier medical institutions. The hospital offers state-of-the-art healthcare services with a commitment to providing quality medical care to all sections of society.',
      imageUrl: 'assets/images/lilavati_hospital.jpg',
      phoneNumber: '+91 22 2675 1000',
    ),
    Hospital(
      name: 'APOLLO HOSPITAL',
      address: 'Plot #1A, Bhat GIDC Estate, Gandhinagar, Gujarat, India.',
      history: 'Founded by Dr. Prathap C. Reddy in 1983, Apollo Hospitals is India\'s first corporate hospital. The institution pioneered private healthcare in India and has consistently introduced international quality healthcare services and cutting-edge technology to the country.',
      imageUrl: 'assets/images/apollo_hospital.jpg',
      phoneNumber: '+91 79 6670 1800',
    ),
  ];

  Hospital _currentHospital = Hospital(
    name: 'COOPER HOSPITAL',
    address: 'WARD NO.456,COOPER HOSPITAL,VILE PARLE (W),MUMBAI,MAHARASHTRA,INDIA.',
    history: 'THE MADUMAN GROUP, A PROMINENT FAMILY GROUP FROM PADUBIDRI, ORGANIZED A SUCCESSFUL BLOOD DONATION DRIVE AT AL MANA HOSPITAL IN JUBAIL, SAUDI ARABIA. THIS INITIATIVE SHOWCASED THE GROUP\'S COMMITMENT TO SOCIAL SERVICE AND HUMANITARIAN CAUSES, REINFORCING THE VALUES OF UNITY AND COMPASSION',
    imageUrl: 'assets/images/cooper_hospital.jpg',
    phoneNumber: '+91 22 2626 7500',
  );

  Hospital get currentHospital => _currentHospital;

  void setCurrentHospital(String hospitalName) {
    final hospital = _hospitals.firstWhere(
      (hospital) => hospital.name == hospitalName,
      orElse: () => _hospitals[0],
    );
    _currentHospital = hospital;
    notifyListeners();
  }

  void callHospital() {
    // In a real app, this would launch a phone call
    print('Calling hospital at ${_currentHospital.phoneNumber}');
  }

  List<Hospital> get allHospitals => _hospitals;
}



class HospitalDetailsScreen extends StatefulWidget {
  const HospitalDetailsScreen({Key? key}) : super(key: key);

  @override
  State<HospitalDetailsScreen> createState() => _HospitalDetailsScreenState();
}

class _HospitalDetailsScreenState extends State<HospitalDetailsScreen> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final hospital = Provider.of<HospitalProvider>(context).currentHospital;
    
    // For demo purposes, create a list of images (in a real app, the model would have multiple images)
    final List<String> demoImages = [
      'assets/images/blood_donation1.jpg',
      'assets/images/blood_donation2.jpg',
      'assets/images/blood_donation3.jpg',
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with back button
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            color: theme.textTheme.titleMedium?.color,
                            size: 20,
                          ),
                          Text(
                            'DETAILS',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: screenWidth * 0.08,
                      height: screenWidth * 0.08,
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: screenHeight * 0.02),
              
              // Hospital icon
              Icon(
                Icons.local_hospital,
                size: screenWidth * 0.15,
                color: theme.brightness == Brightness.light ? 
                    Colors.black54 : 
                    Colors.white70,
              ),
              
              SizedBox(height: screenHeight * 0.01),
              
              // Hospital name
              Text(
                hospital.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  letterSpacing: 1.2,
                  color: theme.brightness == Brightness.light ? 
                    Colors.black87 : 
                    Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: screenHeight * 0.02),
              
              // Call now button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<HospitalProvider>(context, listen: false).callHospital();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.015,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.call,
                        color: Colors.white,
                        size: screenWidth * 0.05,
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        'CALL NOW',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: screenHeight * 0.02),
              
              // Address
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: theme.brightness == Brightness.light ? 
                          Colors.grey[700] : 
                          Colors.grey[400],
                      size: screenWidth * 0.06,
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Expanded(
                      child: Text(
                        hospital.address,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.brightness == Brightness.light ? 
                              Colors.grey[700] : 
                              Colors.grey[400],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: screenHeight * 0.03),
              
              // Image carousel
              Container(
                height: screenHeight * 0.25,
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      // Images
                      PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        itemCount: demoImages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            color: theme.cardColor,
                            child: Center(
                              child: Image.asset(
                                'assets/images/blood_donation.jpg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    'https://via.placeholder.com/400x200?text=Blood+Donation',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      
                      // Carousel navigation arrows
                      Positioned.fill(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left arrow
                            GestureDetector(
                              onTap: () {
                                if (_currentImageIndex > 0) {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(screenWidth * 0.02),
                                color: Colors.transparent,
                                child: const Icon(
                                  Icons.chevron_left,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            ),
                            
                            // Right arrow
                            GestureDetector(
                              onTap: () {
                                if (_currentImageIndex < demoImages.length - 1) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(screenWidth * 0.02),
                                color: Colors.transparent,
                                child: const Icon(
                                  Icons.chevron_right,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Indicator dots
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            demoImages.length,
                            (index) => Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentImageIndex == index ? 
                                    theme.primaryColor : 
                                    Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: screenHeight * 0.03),
              
              // History section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'HISTORY:',
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      hospital.history,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: screenHeight * 0.04),
              
              // Services section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'SERVICES:',
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    _buildServiceItem(
                      context, 
                      'Blood Donation', 
                      Icons.bloodtype, 
                      theme,
                      screenWidth,
                      screenHeight
                    ),
                    _buildServiceItem(
                      context, 
                      'Laboratory Services', 
                      Icons.science, 
                      theme,
                      screenWidth,
                      screenHeight
                    ),
                    _buildServiceItem(
                      context, 
                      'Emergency Care', 
                      Icons.emergency, 
                      theme,
                      screenWidth,
                      screenHeight
                    ),
                    _buildServiceItem(
                      context, 
                      'Consultation', 
                      Icons.person, 
                      theme,
                      screenWidth,
                      screenHeight
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: screenHeight * 0.04),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildServiceItem(
    BuildContext context, 
    String title, 
    IconData icon, 
    ThemeData theme,
    double screenWidth,
    double screenHeight
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.01),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(screenWidth * 0.02),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: theme.primaryColor,
              size: screenWidth * 0.05,
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
          Text(
            title,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

// main.dart (example usage)
