import 'package:car_log/screens/car_detail/car_detail_screen.dart';
import 'package:car_log/screens/car_expenses/car_expenses_screen.dart';
import 'package:car_log/screens/car_history/car_history_screen.dart';
import 'package:car_log/screens/car_notes/car_notes_screen.dart';
import 'package:flutter/material.dart';
import 'package:car_log/screens/car_ride/car_ride_screen.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class CarTabManager extends StatefulWidget {
  const CarTabManager({Key? key}) : super(key: key);

  @override
  State<CarTabManager> createState() => _CarTabManagerState();
}

class _CarTabManagerState extends State<CarTabManager> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    CarDetailScreen(),
    CarExpensesScreen(),
    CarRideScreen(),
    CarnHistoryScreen(),
    CarNotesScreen(),
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
      currentIndex: _currentIndex,
      items: [
        BottomBarItem(
          icon: const Icon(Icons.directions_car_outlined),
          selectedIcon: const Icon(Icons.directions_car_rounded),
          selectedColor: Theme.of(context).colorScheme.primary,
          unSelectedColor: Colors.grey,
          title: const Text('Detail'),
        ),
        BottomBarItem(
          icon: const Icon(Icons.attach_money_outlined),
          selectedIcon: const Icon(Icons.attach_money_rounded),
          selectedColor: Theme.of(context).colorScheme.primary,
          unSelectedColor: Colors.grey,
          title: const Text('Expenses'),
        ),
        BottomBarItem(
          icon: const Icon(Icons.speed_outlined),
          selectedIcon: const Icon(Icons.speed_rounded),
          selectedColor: Theme.of(context).colorScheme.primary,
          unSelectedColor: Colors.grey,
          title: const Text('Ride'),
        ),
        BottomBarItem(
          icon: const Icon(Icons.history_outlined),
          selectedIcon: const Icon(Icons.history_rounded),
          selectedColor: Theme.of(context).colorScheme.primary,
          unSelectedColor: Colors.grey,
          title: const Text('History'),
        ),
        BottomBarItem(
          icon: const Icon(Icons.message_outlined),
          selectedIcon: const Icon(Icons.message_rounded),
          selectedColor: Theme.of(context).colorScheme.primary,
          unSelectedColor: Colors.grey,
          title: const Text('Notes'),
          badge: const Text('9+'),
          showBadge: _currentIndex ==
                  _screens.indexWhere((screen) => screen is CarNotesScreen)
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
