import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:car_log/features/car_history/widgets/car_history_constants.dart';

class EmptyState extends StatelessWidget {
  final bool isVisible;

  EmptyState({required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !isVisible,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isVisible)
              Lottie.asset('assets/animations/nothing.json', width: 220, height: 220),
            SIZED_BOX_HEIGHT_24,
            NO_RIDE_HISTORY_TEXT,
            SIZED_BOX_HEIGHT_10,
            ADD_FIRST_RIDE_TEXT,
          ],
        ),
      ),
    );
  }
}
