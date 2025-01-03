import 'package:flutter/material.dart';
import 'package:car_log/services/ride_service.dart';
import 'package:car_log/services/user_service.dart';
import 'package:car_log/model/ride.dart';
import 'package:car_log/set_up_locator.dart';

class CarHistoryScreen extends StatelessWidget {
  final RideService rideService = get<RideService>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final activeCar = get<UserService>().currentUser?.favoriteCars.first;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Car History',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: StreamBuilder<List<Ride>>(
        stream: rideService.getRides(activeCar ?? ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No ride history found'));
          } else {
            List<Ride> rides = snapshot.data!;
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
                      '/ride/detail',
                      arguments: rides[index],
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: AddRideButton(),
    );
  }
}

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
          '/ride/add',
          arguments: Ride(
            userId: activeUser?.id ?? '',
            userName: activeUser?.name ?? 'Unknown',
          ),
        );
      },
      child: const Icon(Icons.add),
      heroTag: 'addRideFAB', // Unique hero tag to avoid conflicts
    );
  }
}
