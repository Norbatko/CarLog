import 'package:car_log/base/widgets/top_snack_bar.dart';
import 'package:car_log/features/ride/model/ride.dart';
import 'package:car_log/features/ride/model/ride_type.dart';
import 'package:car_log/features/ride/main_car_ride/widgets/ride_add_field_list.dart';
import 'package:car_log/base/services/car_service.dart';
import 'package:car_log/features/ride/services/ride_service.dart';
import 'package:car_log/base/services/user_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';

class AddNewRideDialog extends StatefulWidget {
  final DateTime startOfRide;
  final DateTime endOfRide;
  final String startPosition;
  final String endPosition;

  const AddNewRideDialog({
    super.key,
    required this.startOfRide,
    required this.endOfRide,
    required this.startPosition,
    required this.endPosition,
  });

  @override
  State<AddNewRideDialog> createState() => _AddNewRideDialogState();
}

class _AddNewRideDialogState extends State<AddNewRideDialog> {
  final _rideService = get<RideService>();
  final _carService = get<CarService>();
  final _userService = get<UserService>();

  String _selectedRideType = 'Business';
  late int _odometerStatus;
  late Map<String, TextEditingController> _controllers;
  late Map<String, String?> _errorMessages = {};

  final Map<String, RideType> _rideTypes = {
    'Business': RideType.Business,
    'Personal': RideType.Personal,
    'Commute': RideType.Commute,
    'Delivery': RideType.Delivery,
    'Leisure': RideType.Leisure,
    'Other': RideType.Other,
  };

  @override
  void initState() {
    super.initState();
    _odometerStatus = int.parse(_carService.activeCar.odometerStatus);
    _controllers = {
      'Odometer': TextEditingController(text: _odometerStatus.toString()),
    };
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("One last thing..."),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RideAddFieldList(
              digitsControllers: _controllers,
              errorMessages: _errorMessages,
              selectedRideType: _selectedRideType,
              rideTypes: _rideTypes.keys.toList(),
              onRideTypeChanged: (newValue) {
                setState(() {
                  _selectedRideType = newValue!;
                });
              }),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              _buildIncreaseButton(1),
              _buildIncreaseButton(5),
              _buildIncreaseButton(10),
              _buildIncreaseButton(50),
            ],
          )
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              _saveRide();
            });
          },
          child: Text("Add Ride"),
        ),
        ElevatedButton(
          onPressed: () {
            _clearAllErrorMessages();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: Text("Cancel Ride"),
        )
      ],
    );
  }

  Widget _buildIncreaseButton(int increase) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(3),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _odometerStatus += increase;
              _controllers['Odometer']!.text = _odometerStatus.toString();
            });
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 4,
            ),
          ),
          child: Text(
            '+$increase',
          ),
        ),
      ),
    );
  }

  void _saveRide() {
    _clearAllErrorMessages();

    _odometerStatus = int.parse(_controllers['Odometer']!.text);

    if (int.parse(_carService.activeCar.odometerStatus) >= _odometerStatus) {
      _errorMessages['Odometer'] = 'Odometer must show an increase.';
    }

    int distance =
        _odometerStatus - int.parse(_carService.activeCar.odometerStatus);

    Ride newRide = Ride(
        userId: _userService.currentUser!.id,
        userName: _userService.currentUser!.name,
        startedAt: widget.startOfRide,
        finishedAt: widget.endOfRide,
        rideType: _controllers['Odometer']!.text,
        distance: distance,
        locationStart: widget.startPosition,
        locationEnd: widget.endPosition);

    if (_errorMessages.isEmpty) {
      _rideService.saveRide(newRide, _carService.activeCar.id).listen((_) {
        _carService.updateOdometer(_odometerStatus);
      });
      Navigator.of(context).pop();
      TopSnackBar.show(context, 'Ride added successfully');
    }
  }

  void _clearAllErrorMessages() {
    _errorMessages.clear();
  }
}
