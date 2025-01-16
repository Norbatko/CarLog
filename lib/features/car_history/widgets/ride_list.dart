import 'package:car_log/features/car_expenses/utils/car_expense_constants.dart';
import 'package:flutter/material.dart';
import 'package:car_log/features/ride/model/ride.dart';
import 'package:car_log/features/car_history/widgets/ride_card.dart';
import 'package:car_log/features/car_history/widgets/empty_state.dart';

class RideList extends StatelessWidget {
  final List<Ride> rides;
  final bool isVisible;

  RideList({required this.rides, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    if (rides.isEmpty) return EmptyState(isVisible: isVisible);

    return ListView.builder(
      itemCount: rides.length,
      padding: const EdgeInsets.symmetric(vertical: SECTION_PADDING),
      itemBuilder: (context, index) {
        String formattedDate =
            '${rides[index].finishedAt.day.toString().padLeft(2, '0')}.${rides[index].finishedAt.month.toString().padLeft(2, '0')}.${rides[index].finishedAt.year.toString().substring(2)}';
        return RideCard(ride: rides[index], formattedDate: formattedDate);
      },
    );
  }
}