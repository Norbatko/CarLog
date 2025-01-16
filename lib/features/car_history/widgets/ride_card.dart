import 'package:car_log/features/car_history/widgets/ride_info.dart';
import 'package:flutter/material.dart';
import 'package:car_log/features/ride/model/ride.dart';
import 'package:car_log/features/ride/ride_edit/ride_edit_screen.dart';
import 'package:car_log/features/car_history/widgets/car_history_constants.dart';

class RideCard extends StatelessWidget {
  final Ride ride;
  final String formattedDate;

  RideCard({required this.ride, required this.formattedDate});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: RIDE_CARD_EDGE_SYMMETRIC,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CARD_RADIUS),
      ),
      elevation: CARD_ELEVATION,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RideEditScreen(ride: ride),
            ),
          );
        },
        borderRadius: BorderRadius.circular(CARD_RADIUS),
        child: Padding(
          padding: const EdgeInsets.all(SPACING_VERTICAL),
          child: Row(
            children: [
              RideInfo(icon: Icons.calendar_today, label: formattedDate),
              RideInfo(icon: Icons.person, label: ride.userName),
              RideInfo(icon: Icons.directions_car, label: '${ride.distance} km', iconColor: Colors.green),
            ],
          ),
        ),
      ),
    );
  }
}