import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_app/provider/emergency_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyHelpScreen extends StatefulWidget {
  const EmergencyHelpScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyHelpScreen> createState() => _EmergencyHelpScreenState();
}

class _EmergencyHelpScreenState extends State<EmergencyHelpScreen> {
  Timer? _timer;
  ThemeData get theme => Theme.of(context);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handleSOSPress(EmergencyProvider provider) {
    provider.startSOS();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      provider.decrementCountdown();
      if (provider.countdownValue == 0) {
        timer.cancel();
        provider.sendEmergencyAlert();
        showTopAlert(context);
      }
    });
  }

  void _handleSOSRelease(EmergencyProvider provider) {
    if (provider.isSOSActive && provider.countdownValue > 0) {
      _timer?.cancel();
      provider.cancelSOS();
    }
  }

  void showTopAlert(BuildContext context) {
  OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 20, // Adjust based on status bar
      left: MediaQuery.of(context).size.width * 0.1,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                spreadRadius: 1,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "SOS Sent Successfully!",
                style: TextStyle(color: theme.textTheme.bodyLarge!.color, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  // Insert into overlay
  Overlay.of(context).insert(overlayEntry);

  // Remove it after 2 seconds
  Future.delayed(Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final provider = Provider.of<EmergencyProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Emergency Help'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
            padding: EdgeInsets.all(size.width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              SizedBox(height: size.height * 0.02),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                decoration: BoxDecoration(
                border: Border.all(color: theme.primaryColor, width: 0.5),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3,
                  offset: Offset(0, 5),
                  ),
                ],
                color: theme.scaffoldBackgroundColor,
                ),
                child: Text(
                'Press and hold the SOS button for 3 seconds to send an emergency alert to nearby donors and your emergency contacts.',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: size.height * 0.06),
              GestureDetector(
                onLongPressStart: (_) => _handleSOSPress(provider),
                onLongPressEnd: (_) => _handleSOSRelease(provider),
                child: Container(
                width: size.width * 0.5,
                height: size.width * 0.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: provider.isSOSActive 
                  ? theme.primaryColor.withOpacity(0.8)
                  : theme.primaryColor,
                  boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                  ],
                ),
                child: Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 40,
                    ),
                    SizedBox(height: 10),
                    Text(
                    provider.isSOSActive
                      ? provider.countdownValue.toString()
                      : 'PRESS AND\nHOLD FOR\n3 SECONDS',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.scaffoldBackgroundColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    ),
                  ],
                  ),
                ),
                ),
              ),
              SizedBox(height: size.height * 0.04),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Checkbox(
                  value: provider.useCurrentLocation,
                  onChanged: (value) {
                  if (value != null) {
                    provider.setUseCurrentLocation(value);
                  }
                  },
                  activeColor: theme.primaryColor,
                ),
                Text(
                  'Use your current location',
                  style: theme.textTheme.titleMedium,
                ),
                ],
              ),
              SizedBox(height: size.height * 0.04),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                'Emergency Contacts',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              _buildEmergencyContactCard(
                context,
                'Police',
                provider.policeNumber,
                Icons.local_police_outlined,
                () => provider.callEmergencyContact(provider.policeNumber),
              ),
              SizedBox(height: size.height * 0.02),
              _buildEmergencyContactCard(
                context,
                'Ambulance',
                provider.ambulanceNumber,
                Icons.medical_services_outlined,
                () => provider.callEmergencyContact(provider.ambulanceNumber),
              ),
              SizedBox(height: size.height * 0.02),
              _buildEmergencyContactCard(
                context,
                'Personal Emergency Contact',
                provider.personalEmergencyContact,
                Icons.person_outline,
                () => provider.callEmergencyContact(provider.personalEmergencyContact),
              ),
              SizedBox(height: size.height * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyContactCard(
    BuildContext context,
    String title,
    String number,
    IconData icon,
    VoidCallback onCallPressed,
  ) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: theme.primaryColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    number,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.call, color: Colors.green),
              onPressed: () {
                
                _launchDialer(number);
              },
              tooltip: 'Call $title',
            ),
          ],
        ),
      ),
    );
  }

  void _launchDialer(String number) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: number,
  );

  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  } else {
    throw 'Could not launch $launchUri';
  }
}
}