import 'package:car_log/features/car_history/widgets/add_ride_button.dart';
import 'package:car_log/features/car_history/widgets/ride_list.dart';
import 'package:car_log/routes.dart';
import 'package:car_log/base/services/car_service.dart';
import 'package:car_log/base/builders/stream_custom_builder.dart';
import 'package:car_log/base/theme/application_bar.dart';
import 'package:flutter/material.dart';
import 'package:car_log/features/ride/services/ride_service.dart';
import 'package:car_log/features/ride/model/ride.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:car_log/features/car_history/widgets/car_history_constants.dart';

class CarHistoryScreen extends StatelessWidget {
  final RideService rideService = get<RideService>();
  final bool isVisible;

  CarHistoryScreen({Key? key, required this.isVisible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activeCar = get<CarService>().getActiveCar();

    return Scaffold(
      appBar: ApplicationBar(
          title: CAR_HISTORY_TITLE, userDetailRoute: Routes.userDetail),
      body: StreamCustomBuilder<List<Ride>>(
        stream: rideService.getRides(activeCar.id),
        builder: (context, rides) {
          return RideList(rides: rides, isVisible: isVisible);
        },
      ),
      floatingActionButton: AddRideButton(),
    );
  }
}
