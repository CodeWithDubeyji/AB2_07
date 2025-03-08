import 'package:flutter/material.dart';
import 'package:my_app/provider/nav_bar_provider.dart';
import 'package:my_app/screens/donate_form.dart';
import 'package:my_app/screens/home_screen.dart';

import 'package:my_app/screens/profile_screen.dart';
import 'package:my_app/theme/theme.dart';

import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    DonateScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index, BuildContext context) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomNavProvider = Provider.of<BottomNavProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: _screens[bottomNavProvider.selectedIndex],
      bottomNavigationBar: Container(
        height: size.height * 0.08, // 8% of screen height
        width: size.width * 0.9, // 90% of screen width
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(size.width * 0.07),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: size.width * 0.02,
              spreadRadius: size.width * 0.005,
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(
            horizontal: size.width * 0.05, vertical: size.height * 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                Icons.home_outlined,
                color: bottomNavProvider.selectedIndex == 0
                    ? AppTheme.primaryColor
                    : theme.textTheme.bodySmall?.color,
                size: size.width * 0.07,
              ),
              onPressed: () => bottomNavProvider.setSelectedIndex(0),
            ),
            Container(
              width: size.width * 0.15,
              height: size.width * 0.15,
              decoration: const BoxDecoration(
                color: Color(0xFF333333),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  bottomNavProvider.selectedIndex == 1
                      ? Icons.water_drop
                      : Icons.water_drop_outlined,
                  color: theme.scaffoldBackgroundColor,
                  size: size.width * 0.08,
                ),
                onPressed: () => bottomNavProvider.setSelectedIndex(1),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.person_outline,
                color: bottomNavProvider.selectedIndex == 2
                    ? AppTheme.primaryColor
                    : theme.textTheme.bodySmall?.color,
                size: size.width * 0.07,
              ),
              onPressed: () => bottomNavProvider.setSelectedIndex(2),
            ),
          ],
        ),
      ),
    );
  }
}
