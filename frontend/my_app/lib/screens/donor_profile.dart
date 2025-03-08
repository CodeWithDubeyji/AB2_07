import 'package:flutter/material.dart';
import 'package:my_app/provider/donor_provider.dart';
import 'package:provider/provider.dart';


class DonorProfileScreen extends StatelessWidget {
  final String donorId;

  const DonorProfileScreen({
    Key? key,
    required this.donorId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;
    final provider = Provider.of<SearchResultsProvider>(context);
    
    // Get the donor data using the ID
    final donor = provider.getDonorById(donorId);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'DONOR PROFILE',
          style: theme.textTheme.titleMedium,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 4,
              backgroundColor: theme.primaryColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.02),
              // Profile Image
              CircleAvatar(
                radius: width * 0.15,
                backgroundImage: AssetImage(donor.profileImageUrl),
              ),
              SizedBox(height: height * 0.02),
              // Donor Name
              Text(
                donor.name,
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(height: height * 0.02),
              // Availability Indicator
              Container(
                width: double.infinity,
                height: height * 0.06,
                decoration: BoxDecoration(
                  color: donor.isAvailableForDonate 
                      ? const Color.fromRGBO(141, 198, 63, 1) 
                      : theme.disabledColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: width * 0.05,
                    ),
                    SizedBox(width: width * 0.02),
                    Text(
                      'AVAILABLE FOR DONATE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.035,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.04),
              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatColumn(
                    context,
                    donor.bloodType,
                    'BLOOD TYPE',
                  ),
                  _buildStatColumn(
                    context,
                    donor.donated.toString(),
                    'DONATED',
                  ),
                  _buildStatColumn(
                    context,
                    donor.requested.toString().padLeft(2, '0'),
                    'REQUESTED',
                  ),
                ],
              ),
              SizedBox(height: height * 0.04),
              // Address Section
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: theme.primaryColor,
                    size: width * 0.07,
                  ),
                  SizedBox(width: width * 0.02),
                  Expanded(
                    child: Text(
                      '${donor.address} ${donor.city},\n${donor.state} ${donor.zipCode}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.06),
              // Chat Button
              _buildActionButton(
                context,
                'CHAT NOW',
                Icons.chat_bubble,
                theme.primaryColor,
                width,
                height,
                () {
                  // Implement chat functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Starting chat with ${donor.name}')),
                  );
                },
              ),
              SizedBox(height: height * 0.02),
              // Call Button
              _buildActionButton(
                context,
                'CALL NOW',
                Icons.call,
                theme.primaryColor,
                width,
                height,
                () {
                  // Implement call functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Calling ${donor.name} at ${donor.phoneNumber}')),
                  );
                },
                isCallButton: true,
              ),
              SizedBox(height: height * 0.04),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, String value, String label) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: theme.primaryColor,
            fontSize: width * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    double width,
    double height,
    VoidCallback onPressed, {
    bool isCallButton = false,
  }) {
    return Container(
      width: double.infinity,
      height: height * 0.06,
      margin: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isCallButton ? color : Colors.white,
          foregroundColor: isCallButton ? Colors.white : color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: isCallButton
                ? BorderSide.none
                : BorderSide(color: color),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: width * 0.05),
            SizedBox(width: width * 0.02),
            Text(
              label,
              style: TextStyle(
                fontSize: width * 0.035,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}