import 'package:car_log/services/Routes.dart';
import 'package:car_log/widgets/theme/app_bar.dart';
import 'package:flutter/material.dart';

class CarNotesScreen extends StatelessWidget {
  const CarNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationBar(
          title: 'Car Notes', userDetailRoute: Routes.userDetail),
      body: Center(
        child: Container(
          width: 100,
          height: 100,
          color: Colors.red,
        ),
      ),
    );
  }
}
