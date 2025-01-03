import 'package:car_log/screens/car_history/widgets/add_ride_button.dart';
import 'package:car_log/services/Routes.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/widgets/builders/stream_custom_builder.dart';
import 'package:flutter/material.dart';
import 'package:car_log/services/ride_service.dart';
import 'package:car_log/model/ride.dart';
import 'package:car_log/set_up_locator.dart';

const _NO_RIDE_HISTORY = Center(child: Text('No ride history found'));
const _CAR_HISTORY_TITLE = 'Car History';

class CarHistoryScreen extends StatelessWidget {
  final RideService rideService = get<RideService>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final activeCar = get<CarService>().getActiveCar();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _CAR_HISTORY_TITLE,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: StreamCustomBuilder<List<Ride>>(
        stream: rideService.getRides(activeCar.id),
        builder: (context, rides) {
          return _buildRideList(rides);
        },
      ),
      floatingActionButton: AddRideButton(),
    );
  }

  Widget _buildRideList(List<Ride> rides) {
    if (rides.isEmpty) return _NO_RIDE_HISTORY;

    return ListView.builder(
      itemCount: rides.length,
      itemBuilder: (context, index) {
        String formattedDate =
            '${rides[index].finishedAt.day.toString().padLeft(2, '0')}.${rides[index].finishedAt.month.toString().padLeft(2, '0')}.${rides[index].finishedAt.year.toString().substring(2)}';
        return ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  formattedDate,
                  textAlign: TextAlign.start,
                ),
              ),
              Expanded(
                child: Text(
                  rides[index].userName,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  '${rides[index].distance} km',
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.carDetail,
              arguments: rides[index],
            );
          },
        );
      },
    );
  }
}