import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:media_hub/screens/chart_screen.dart';
import 'package:media_hub/screens/home_screen.dart';
import 'package:media_hub/screens/map_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    MapScreen(),
    ChartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.black,
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        index: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          Icon(
            Icons.home,
            size: 30,
          ),
          Icon(
            Icons.location_on,
            size: 30,
          ),
          Icon(
            Icons.stacked_line_chart,
            size: 30,
          ),
        ],
      ),
    );
  }
}
