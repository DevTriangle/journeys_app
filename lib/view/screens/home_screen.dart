import 'package:flutter/material.dart';
import 'package:journeys_app/view/colors.dart';
import 'package:journeys_app/view/screens/tools_screen.dart';

import 'journey_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Widget> _screens = [JourneyScreen(), ToolsScreen()];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primaryColor,
          selectedFontSize: 12,
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.public_rounded),
              label: "Поездки",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apps_rounded),
              label: "Инструменты",
            ),
          ],
        ),
        body: _screens[_selectedIndex],
      ),
    );
  }
}
