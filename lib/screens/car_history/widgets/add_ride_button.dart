import 'package:car_log/model/ride.dart';
import 'package:car_log/services/Routes.dart';
import 'package:car_log/services/ride_service.dart';
import 'package:car_log/services/user_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';

class AddRideButton extends StatelessWidget {
  AddRideButton({Key? key}) : super(key: key);

  final RideService rideService = get<RideService>();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        final activeUser = get<UserService>().currentUser;

        Navigator.pushNamed(
          context,
          Routes.rideAdd,
          arguments: Ride(
            userId: activeUser?.id ?? '',
            userName: activeUser?.name ?? 'Unknown',
          ),
        );
      },
      child: const Icon(Icons.add),
      heroTag: 'addRideFAB',
    );
  }
}
