// donor_model.dart
import 'package:flutter/material.dart';
import 'package:my_app/screens/donor_profile.dart';
import 'package:provider/provider.dart';

class Donor {
  final String name;
  final String bloodType;
  final String phoneNumber;

  Donor({
    required this.name,
    required this.bloodType,
    required this.phoneNumber,
  });
}

// donor_provider.dart

class DonorProvider extends ChangeNotifier {
  final List<Donor> _allDonors = [
    Donor(
        name: 'Jorge Stephens',
        bloodType: 'B+',
        phoneNumber: '+1 555-123-4567'),
    Donor(
        name: 'Mabel Peterson',
        bloodType: 'B+',
        phoneNumber: '+1 555-234-5678'),
    Donor(
        name: 'Thelma Powers', bloodType: 'B+', phoneNumber: '+1 555-345-6789'),
    Donor(
        name: 'Dolores Berry', bloodType: 'B+', phoneNumber: '+1 555-456-7890'),
    Donor(name: 'Gail Day', bloodType: 'B+', phoneNumber: '+1 555-567-8901'),
    Donor(
        name: 'Michael Elliott',
        bloodType: 'B+',
        phoneNumber: '+1 555-678-9012'),
    Donor(
        name: 'Harry Hawkins', bloodType: 'B+', phoneNumber: '+1 555-789-0123'),
    Donor(
        name: 'Roberto Keller',
        bloodType: 'B+',
        phoneNumber: '+1 555-890-1234'),
    Donor(
        name: 'Mathew Willis', bloodType: 'B+', phoneNumber: '+1 555-901-2345'),
    Donor(
        name: 'Diana Johnson', bloodType: 'B+', phoneNumber: '+1 555-012-3456'),
    Donor(
        name: 'Lisa Campbell', bloodType: 'B+', phoneNumber: '+1 555-123-4567'),
    Donor(
        name: 'Sarah Gonzalez',
        bloodType: 'B+',
        phoneNumber: '+1 555-234-5678'),
    Donor(name: 'Omar Patel', bloodType: 'B+', phoneNumber: '+1 555-345-6789'),
    Donor(
        name: 'Kevin Wright', bloodType: 'B+', phoneNumber: '+1 555-456-7890'),
    Donor(
        name: 'Brandon Cooper',
        bloodType: 'B+',
        phoneNumber: '+1 555-567-8901'),
    Donor(name: 'Rachel Kim', bloodType: 'B+', phoneNumber: '+1 555-678-9012'),
    Donor(
        name: 'Victor Martinez',
        bloodType: 'B+',
        phoneNumber: '+1 555-789-0123'),
    Donor(
        name: 'Teresa Chang', bloodType: 'B+', phoneNumber: '+1 555-890-1234'),
    Donor(
        name: 'Paul Anderson', bloodType: 'B+', phoneNumber: '+1 555-901-2345'),
    Donor(name: 'Sophia Lee', bloodType: 'B+', phoneNumber: '+1 555-012-3456'),
  ];

  String _currentBloodType = 'B+';

  List<Donor> get filteredDonors {
    return _allDonors
        .where((donor) => donor.bloodType == _currentBloodType)
        .toList();
  }

  int get donorCount => filteredDonors.length;

  String get currentBloodType => _currentBloodType;

  void setBloodType(String bloodType) {
    _currentBloodType = bloodType;
    notifyListeners();
  }

  void callDonor(String phoneNumber) {
    // In a real app, this would launch a phone call
    print('Calling donor at $phoneNumber');
  }

  void getDonorInfo(String name) {
    // In a real app, this would show detailed info
    print('Getting info for donor: $name');
  }
}

// blood_donor_search_screen.dart

class BloodDonorSearchScreen extends StatelessWidget {
  const BloodDonorSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final donorProvider = Provider.of<DonorProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search header
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: theme.textTheme.titleMedium?.color,
                      size: 22,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Text(
                    'SEARCH',
                    style: theme.textTheme.titleMedium,
                  ),
                  const Spacer(),
                  Container(
                    width: screenWidth * 0.03,
                    height: screenWidth * 0.03,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),

            // Blood type header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.015,
              ),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text:
                              '${donorProvider.donorCount} RESULT(S) FOUND FOR BLOOD TYPE ',
                        ),
                        TextSpan(
                          text: donorProvider.currentBloodType,
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Donor list
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                itemCount: donorProvider.filteredDonors.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: theme.brightness == Brightness.light
                      ? Colors.grey[300]
                      : Colors.grey[700],
                ),
                itemBuilder: (context, index) {
                  final donor = donorProvider.filteredDonors[index];
                  return Container(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.015,
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: screenWidth * 0.02),
                        Expanded(
                          child: Text(
                            donor.name.toUpperCase(),
                            style: theme.textTheme.titleSmall,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        _buildInfoButton(context, donor.name, theme,
                            screenWidth, donorProvider),
                        SizedBox(width: screenWidth * 0.03),
                        _buildCallButton(context, donor.phoneNumber, theme,
                            screenWidth, donorProvider),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Blood Banks button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                children: [
                  Divider(
                    color: theme.brightness == Brightness.light
                        ? Colors.grey[300]
                        : Colors.grey[700],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/bloodbank');
                      // Navigate to blood banks screen
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: theme.cardColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.08,
                        vertical: screenHeight * 0.015,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_hospital,
                          color: theme.primaryColor,
                          size: 22,
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          'GO TO BLOOD BANKS',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoButton(BuildContext context, String donorName,
      ThemeData theme, double screenWidth, DonorProvider provider) {
    return Container(
      width: screenWidth * 0.12,
      height: screenWidth * 0.12,
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
          icon: Icon(
            Icons.info_outline,
            color: Colors.white,
            size: screenWidth * 0.06,
          ),
            onPressed: () {
            provider.getDonorInfo(donorName);
            
            }
      ),
    
      
          );
      }
    
  }

  Widget _buildCallButton(BuildContext context, String phoneNumber,
      ThemeData theme, double screenWidth, DonorProvider provider) {
    return Container(
      width: screenWidth * 0.12,
      height: screenWidth * 0.12,
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(
          Icons.phone,
          color: Colors.white,
          size: screenWidth * 0.06,
        ),
        onPressed: () => provider.callDonor(phoneNumber),
      ),
    );
  }


// main.dart (example usage)
