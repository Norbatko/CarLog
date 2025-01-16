import 'package:car_log/base/filters/expense/date_range_filter.dart';
import 'package:car_log/base/filters/ride/distance_range_filter.dart';
import 'package:car_log/base/filters/ride/user_filter.dart';
import 'package:car_log/base/widgets/buttons/save_or_delete_button.dart';
import 'package:car_log/features/ride/model/ride.dart';
import 'package:flutter/material.dart';

class RideFilterDialog extends StatefulWidget {
  final Set<String> selectedUser;
  final List<Ride> filteredRides;
  final List<Ride> rides;

  const RideFilterDialog({
    super.key,
    required this.selectedUser,
    required this.filteredRides,
    required this.rides,
  });

  @override
  _RideFilterDialogState createState() => _RideFilterDialogState();
}

class _RideFilterDialogState extends State<RideFilterDialog> {
  late Set<String> _users;
  DateTime? _startDate;
  DateTime? _endDate;
  int? _minDistance;
  int? _maxDistance;

  @override
  void initState() {
    super.initState();
    _users = Set<String>.from(widget.selectedUser);
    final distances = widget.filteredRides.map((e) => e.distance).toList();
    _minDistance =
        distances.isNotEmpty ? distances.reduce((a, b) => a < b ? a : b) : 0;
    _maxDistance =
        distances.isNotEmpty ? distances.reduce((a, b) => a > b ? a : b) : 0;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Text(
            'Filter Expenses',
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          SaveOrDeleteButton(
            isDeleteButton: true,
            deleteText: 'Clear all filters',
            onPressed: () {
              setState(() {
                _users.clear();
                _startDate = null;
                _endDate = null;
                _minDistance = widget.rides.isNotEmpty
                    ? widget.rides
                        .map((e) => e.distance)
                        .reduce((a, b) => a < b ? a : b)
                    : 0;
                _maxDistance = widget.rides.isNotEmpty
                    ? widget.rides
                        .map((e) => e.distance)
                        .reduce((a, b) => a > b ? a : b)
                    : 0;
              });
              Navigator.of(context).pop({
                'users': _users.toList(),
                'startDate': _startDate,
                'endDate': _endDate,
                'minDistance': _minDistance,
                'maxDistance': _maxDistance,
              });
            },
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserFilter(
              selectedUsers: _users,
              rides: widget.filteredRides,
              onSelectionChanged: (value) {
                setState(() {
                  _users = value;
                });
              },
            ),
            const SizedBox(height: 16),
            DateRangeFilter(
              initialStartDate: _startDate,
              initialEndDate: _endDate,
              onDateRangeChanged: (startDate, endDate) {
                setState(() {
                  _startDate = startDate;
                  _endDate = endDate;
                });
              },
            ),
            const SizedBox(height: 16),
            DistanceFilter(
              minDistance: _minDistance!,
              maxDistance: _maxDistance!,
              onDistanceRangeChanged: (int? selectedMin, int? selectedMax) {
                setState(() {
                  _minDistance = selectedMin;
                  _maxDistance = selectedMax;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SaveOrDeleteButton(
              saveText: 'Apply',
              saveIcon: Icon(Icons.filter_alt),
              onPressed: () {
                Navigator.of(context).pop({
                  'users': _users.toList(),
                  'startDate': _startDate,
                  'endDate': _endDate,
                  'minAmount': _minDistance,
                  'maxAmount': _maxDistance,
                });
              },
            ),
            SaveOrDeleteButton(
              isDeleteButton: true,
              deleteText: 'Cancel',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ],
    );
  }
}
