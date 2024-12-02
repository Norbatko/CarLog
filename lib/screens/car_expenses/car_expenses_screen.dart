import 'package:car_log/services/Routes.dart';
import 'package:car_log/widgets/theme/app_bar.dart';
import 'package:flutter/material.dart';

const _CONTAINER_WIDTH = 100.0;
const _CONTAINER_HEIGHT = 100.0;

class CarExpensesScreen extends StatelessWidget {
  const CarExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationBar(
          title: 'Car Expenses', userDetailRoute: Routes.userDetail),
      body: Center(
        child: Container(
          width: _CONTAINER_WIDTH,
          height: _CONTAINER_HEIGHT,
          color: Colors.red,
        ),
      ),
    );
  }
}
