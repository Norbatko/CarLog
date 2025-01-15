import 'package:car_log/base/widgets/buttons/floating_add_action_button.dart';
import 'package:car_log/features/ride/model/ride.dart';
import 'package:car_log/routes.dart';
import 'package:car_log/features/ride/services/ride_service.dart';
import 'package:car_log/base/services/user_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';

class AddRideButton extends StatelessWidget {
  AddRideButton({Key? key}) : super(key: key);

  final RideService rideService = get<RideService>();

  @override
  Widget build(BuildContext context) {
    return FloatingAddActionButton(
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
    );
  }
}
