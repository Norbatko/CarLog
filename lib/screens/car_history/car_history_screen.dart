import 'package:car_log/screens/car_history/widgets/add_ride_button.dart';
import 'package:car_log/services/Routes.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/widgets/builders/stream_custom_builder.dart';
import 'package:flutter/material.dart';
import 'package:car_log/services/ride_service.dart';
import 'package:car_log/model/ride.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:lottie/lottie.dart';
import 'package:car_log/screens/car_history/widgets/car_history_constants.dart';

class CarHistoryScreen extends StatelessWidget {
  final RideService rideService = get<RideService>();
  final bool isVisible;

  CarHistoryScreen({Key? key, required this.isVisible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final activeCar = get<CarService>().getActiveCar();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          CAR_HISTORY_TITLE,
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: StreamCustomBuilder<List<Ride>>(
        stream: rideService.getRides(activeCar.id),
        builder: (context, rides) {
          return _buildRideList(rides, context);
        },
      ),
      floatingActionButton: AddRideButton(),
    );
  }

  Widget _buildRideList(List<Ride> rides, BuildContext context) {
    if (rides.isEmpty) return _buildEmptyState(context, isVisible);

    return ListView.builder(
      itemCount: rides.length,
      padding: const EdgeInsets.symmetric(vertical: SECTION_PADDING),
      itemBuilder: (context, index) {
        String formattedDate =
            '${rides[index].finishedAt.day.toString().padLeft(2, '0')}.${rides[index].finishedAt.month.toString().padLeft(2, '0')}.${rides[index].finishedAt.year.toString().substring(2)}';
        return _buildRideCard(context, rides[index], formattedDate);
      },
    );
  }

  Widget _buildRideCard(BuildContext context, Ride ride, String formattedDate) {
    return Card(
      margin: RIDE_CARD_EDGE_SYMMETRIC,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CARD_RADIUS),
      ),
      elevation: CARD_ELEVATION,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.carDetail,
            arguments: ride,
          );
        },
        borderRadius: BorderRadius.circular(CARD_RADIUS),
        child: Padding(
          padding: const EdgeInsets.all(SPACING_VERTICAL),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRideInfo(
                icon: Icons.calendar_today,
                label: formattedDate,
                alignment: TextAlign.start,
              ),
              _buildRideInfo(
                icon: Icons.person,
                label: ride.userName,
                alignment: TextAlign.center,
              ),
              _buildRideInfo(
                icon: Icons.directions_car,
                label: '${ride.distance} km',
                alignment: TextAlign.end,
                iconColor: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRideInfo({
    required IconData icon,
    required String label,
    TextAlign alignment = TextAlign.start,
    Color iconColor = Colors.blue,
  }) {
    return Expanded(
      child: Row(
        mainAxisAlignment: alignment == TextAlign.start
            ? MainAxisAlignment.start
            : alignment == TextAlign.end
            ? MainAxisAlignment.end
            : MainAxisAlignment.center,
        children: [
          Icon(icon, size: ICON_SIZE, color: iconColor),
          SIZED_BOX_WIDTH_12,
          Text(label, style: TEXT_STYLE),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isVisible) {
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
