import 'package:car_log/screens/user_detail/user_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:car_log/screens/car_ride/car_ride_screen.dart';
import 'package:car_log/screens/cars_list/cars_list_screen.dart';
import 'package:car_log/screens/users_list/users_list_screen.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class CarTabManager extends StatefulWidget {
  const CarTabManager({Key? key}) : super(key: key);

  @override
  State<CarTabManager> createState() => _CarTabManagerState();
}

class _CarTabManagerState extends State<CarTabManager> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    UsersListScreen(),
    CarsListScreen(),
    CarRideScreen(),
    UsersListScreen(),
    UserDetailScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = _screens.indexWhere((screen) => screen is CarRideScreen);
  }

  void _onNavItemTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  Widget _buildBody() {
    return IndexedStack(
      index: _currentIndex,
      children: _screens,
    );
  }

  Widget _buildBottomNavigationBar() {
    return StylishBottomBar(
      currentIndex: _currentIndex, // Important!
      items: [
        BottomBarItem(
          icon: const Icon(Icons.house_outlined),
          selectedIcon: const Icon(Icons.house_rounded),
          selectedColor: Theme.of(context).colorScheme.primary,
          unSelectedColor: Colors.grey,
          title: const Text('Home'),
        ),
        BottomBarItem(
          icon: const Icon(Icons.directions_car_outlined),
          selectedIcon: const Icon(Icons.directions_car_rounded),
          selectedColor: Theme.of(context).colorScheme.primary,
          unSelectedColor: Colors.grey,
          title: const Text('Cars'),
        ),
        BottomBarItem(
          icon: const Icon(Icons.people_outline),
          selectedIcon: const Icon(Icons.people),
          selectedColor: Theme.of(context).colorScheme.primary,
          unSelectedColor: Colors.grey,
          title: const Text('Users'),
        ),
        BottomBarItem(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          selectedColor: Theme.of(context).colorScheme.primary,
          unSelectedColor: Colors.grey,
          title: const Text('Settings'),
        ),
        BottomBarItem(
          icon: const Icon(Icons.info_outline),
          selectedIcon: const Icon(Icons.info),
          selectedColor: Theme.of(context).colorScheme.primary,
          unSelectedColor: Colors.grey,
          title: const Text('About'),
          badge: const Text('9+'),
          showBadge: _currentIndex ==
                  _screens.indexWhere((screen) => screen is UserDetailScreen)
              ? false
              : true,
        ),
      ],
      option: BubbleBarOptions(
          barStyle: BubbleBarStyle.vertical,
          bubbleFillStyle: BubbleFillStyle.fill),
      onTap: (index) => _onNavItemTapped(index),
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
