import 'package:flutter/material.dart';
import 'package:my_app/provider/blood_donation_provider.dart';
import 'package:my_app/provider/blood_inventory_provider.dart';
import 'package:my_app/provider/donor_provider.dart';
import 'package:my_app/provider/emergency_provider.dart';
import 'package:my_app/provider/find_donors_provider.dart';
import 'package:my_app/provider/home_screen_provider.dart';
import 'package:my_app/provider/login_provider.dart';
import 'package:my_app/provider/nav_bar_provider.dart';
import 'package:my_app/provider/notification_provider.dart';
import 'package:my_app/provider/register_provider.dart';
import 'package:my_app/screens/bloodbank_list.dart';
import 'package:my_app/screens/bottom_sheet_blood_request.dart' as bottomSheet;
import 'package:my_app/screens/campaign_screen.dart';
import 'package:my_app/screens/chatbot.dart';
import 'package:my_app/screens/donate_form.dart';
import 'package:my_app/screens/donor_profile.dart';
import 'package:my_app/screens/donorlist.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/screens/login.dart';
import 'package:my_app/screens/navbar.dart';
import 'package:my_app/screens/notification.dart';

import 'package:my_app/screens/profile_screen.dart';
import 'package:my_app/screens/register_page.dart';
import 'package:my_app/screens/sos_screen.dart';

import 'package:my_app/screens/splash_screen.dart';
import 'package:my_app/theme/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => NotificationsProvider()),
      ChangeNotifierProvider(create: (_) => SearchResultsProvider()),
      ChangeNotifierProvider(create: (_) => LoginProvider()),
      ChangeNotifierProvider(create: (_) => RegistrationProvider()),
      ChangeNotifierProvider(create: (_) => BottomNavProvider()),
      ChangeNotifierProvider(create: (_) => BloodDonationProvider()),
      ChangeNotifierProvider(create: (_) => FindDonorsProvider()),
      ChangeNotifierProvider(create: (_) => EmergencyProvider()),
      ChangeNotifierProvider(create: (_) => BloodBankProvider()),

    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      child: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            routes: {
              '/profile': (context) => ProfileScreen(),
              //'/home': (context) => HomeScreen(),
              '/donate': (context) => DonateScreen(),
              '/campaign': (context) => CampaignsScreen(),
              '/notification': (context) => NotificationsScreen(),
              '/donorlist': (context) => FindDonorsContent(),
              '/register': (context) => RegistrationScreen(),
              '/login': (context) => LoginScreen(),
              '/navbar': (context) => BottomNavBar(),
              '/sos': (context) => EmergencyHelpScreen(),
            },
            title: 'Blood Donation App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            home: BloodBanksScreen(),
          );
        },
      ),
    );
  }
}
