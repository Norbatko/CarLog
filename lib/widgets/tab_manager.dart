import 'package:flutter/material.dart';
import 'package:car_log/screens/cars_list/cars_list_screen.dart';
import 'package:car_log/screens/users_list/users_list_screen.dart';

class TabManager extends StatefulWidget {
  const TabManager({Key? key}) : super(key: key);

  @override
  State<TabManager> createState() => _TabManagerState();
}

class _TabManagerState extends State<TabManager> {
  int _currentIndex = 1;

  final List<Widget> _screens = [
    UsersListScreen(),
    CarsListScreen(),
  ];

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildBody() {
    return IndexedStack(
      index: _currentIndex,
      children: _screens,
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onNavItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Users',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_car),
          label: 'Cars',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
