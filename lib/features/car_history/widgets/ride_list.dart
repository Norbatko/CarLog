import 'package:car_log/base/filters/name_filter.dart';
import 'package:car_log/base/filters/ride/ride_filter_dialog.dart';
import 'package:car_log/features/car_expenses/utils/car_expense_constants.dart';
import 'package:car_log/features/car_history/widgets/car_history_constants.dart'
    as history_constants;
import 'package:flutter/material.dart';
import 'package:car_log/features/ride/model/ride.dart';
import 'package:car_log/features/car_history/widgets/ride_card.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class RideList extends StatefulWidget {
  final List<Ride> rides;
  final bool isVisible;

  RideList({required this.rides, required this.isVisible});

  @override
  State<RideList> createState() => _RideListState();
}

class _RideListState extends State<RideList> {
  late List<Ride> filteredRides;
  Set<String> selectedUser = {};
  int minDistance = -1;
  int maxDistance = -1;
  DateTime? startDate = null;
  DateTime? endDate = null;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    _applyFilters();
    if (filteredRides.isEmpty && searchQuery.isNotEmpty) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: NameFilter(
                  hintText: "Name or License Plate",
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query;
                      _applyFilters();
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.filter_alt),
                  label: Text(
                    "Filters",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 12.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                  ),
                  onPressed: _openFilterDialog,
                ),
              ),
            ],
          ),
          const Center(child: Text('No expenses found')),
        ],
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: NameFilter(
                hintText: "Date, Name or Distance",
                onChanged: (query) {
                  setState(() {
                    searchQuery = query;
                    _applyFilters();
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                icon: Icon(Icons.filter_alt),
                label: Text(
                  "Filters",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 12.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      12.0,
                    ),
                  ),
                ),
                onPressed: _openFilterDialog,
              ),
            ),
          ],
        ),
        Expanded(
          child: filteredRides.isEmpty
              ? _buildEmptyState(context, widget.isVisible)
              : ListView.builder(
                  itemCount: filteredRides.length,
                  padding:
                      const EdgeInsets.symmetric(vertical: SECTION_PADDING),
                  itemBuilder: (context, index) {
                    String formattedDate =
                        '${filteredRides[index].finishedAt.day.toString().padLeft(2, '0')}.${filteredRides[index].finishedAt.month.toString().padLeft(2, '0')}.${widget.rides[index].finishedAt.year.toString().substring(2)}';
                    return RideCard(
                        ride: filteredRides[index],
                        formattedDate: formattedDate);
                  },
                ),
        )
      ],
    );
  }

  void _openFilterDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => RideFilterDialog(
        selectedUser: selectedUser,
        filteredRides: filteredRides,
        rides: widget.rides,
      ),
    );

    if (result != null) {
      setState(() {
        selectedUser =
            result['users'] != null ? Set.from(result['users']) : selectedUser;
        startDate = result['startDate'];
        endDate = result['endDate'];
        minDistance = result['minDistance'] ?? -1;
        maxDistance = result['maxDistance'] ?? -1;
        _applyFilters();
      });
    }
  }

  void _applyFilters() {
    filteredRides = widget.rides.where((ride) {
      return (selectedUser.isEmpty || selectedUser.contains(ride.userName)) &&
          (startDate == null || startDate!.isBefore(ride.finishedAt)) &&
          (endDate == null || endDate!.isAfter(ride.finishedAt)) &&
          (minDistance == -1 || minDistance <= ride.distance) &&
          (maxDistance == -1 || maxDistance >= ride.distance) &&
          (ride.userName.toLowerCase().contains(searchQuery.toLowerCase()) ||
              ride.distance
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              DateFormat(DATE_FORMAT)
                  .format(ride.startedAt)
                  .contains(searchQuery) ||
              DateFormat(DATE_FORMAT)
                  .format(ride.finishedAt)
                  .contains(searchQuery));
    }).toList();

    // print("--------");
    // for (var i in filteredRides) {
    //   print("Ride => ${i.distance}, username => ${i.userName}");
    // }
    // print("--------");
    filteredRides.sort((a, b) {
      return b.finishedAt
          .compareTo(a.finishedAt); // Descending order: newest dates first
    });
  }

  Widget _buildEmptyState(BuildContext context, bool isVisible) {
    return Offstage(
      offstage: !isVisible,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isVisible)
              Lottie.asset('assets/animations/nothing.json',
                  width: 220, height: 220),
            history_constants.SIZED_BOX_HEIGHT_24,
            history_constants.NO_RIDE_HISTORY_TEXT,
            history_constants.SIZED_BOX_HEIGHT_10,
            history_constants.ADD_FIRST_RIDE_TEXT,
          ],
        ),
      ),
    );
  }
}
