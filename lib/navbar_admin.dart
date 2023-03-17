import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sppnekat/screen/profile/profile.dart';

import 'screen/home_admin/home_admin.dart';
import 'shared/color.dart';

class NavBarAdmin extends StatefulWidget {
  const NavBarAdmin({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NavBarAdminState createState() => _NavBarAdminState();
}

class _NavBarAdminState extends State<NavBarAdmin> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[HomeAdmin(), Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              lightBlue,
              darkBlue,
            ],
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: GNav(
              // rippleColor: darkBlue,
              // hoverColor: darkBlue,
              gap: 8,
              activeColor: darkBlue,
              iconSize: 24,
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              duration: const Duration(milliseconds: 300),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.white,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Beranda',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Akun',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
