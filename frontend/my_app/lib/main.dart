import 'package:flutter/material.dart';
import 'package:my_app/provider/donor_provider.dart';
import 'package:my_app/provider/home_screen_provider.dart';
import 'package:my_app/provider/notification_provider.dart';
import 'package:my_app/screens/campaign_screen.dart';
import 'package:my_app/screens/donate_form.dart';
import 'package:my_app/screens/donorlist.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/screens/notification.dart';
import 'package:my_app/screens/profile.dart';
import 'package:my_app/theme/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => NotificationsProvider()),
      ChangeNotifierProvider(create: (_) => SearchResultsProvider()),
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
              '/home': (context) => HomeScreen(),
              '/donate': (context) => DonateScreen(),
              '/campaign': (context) => CampaignsScreen(),
              '/notification': (context) => NotificationsScreen(),
              '/donorlist': (context) => SearchResultsScreen(),
            },
            title: 'Blood Donation App',
            theme: AppTheme.darkTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: const HomeScreen()
          );
        },
      ),
    );
  }
}
