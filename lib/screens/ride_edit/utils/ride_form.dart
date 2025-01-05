import 'dart:async';
import 'package:car_log/screens/ride_edit/widget/date_time_picker_tile.dart';
import 'package:car_log/screens/ride_edit/widget/dialog_helper.dart';
import 'package:car_log/screens/ride_edit/widget/location_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:car_log/model/ride.dart';
import 'package:car_log/services/ride_service.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/services/location_service.dart';
import 'package:car_log/set_up_locator.dart';

class RideForm extends StatefulWidget {
  final Ride ride;

  const RideForm({Key? key, required this.ride}) : super(key: key);

  @override
  _RideFormState createState() => _RideFormState();
}

class _RideFormState extends State<RideForm> {
  late TextEditingController _rideTypeController;
  late TextEditingController _distanceController;
  late TextEditingController _userNameController;
  late TextEditingController _locationStartController;
  late TextEditingController _locationEndController;
  DateTime? _selectedStartDateTime;
  DateTime? _selectedFinishDateTime;

  final RideService rideService = get<RideService>();
  final LocationService locationService = get<LocationService>();
  late StreamSubscription<String> _locationSubscription;

  @override
  void initState() {
    super.initState();
    _rideTypeController = TextEditingController(text: widget.ride.rideType);
    _distanceController =
        TextEditingController(text: widget.ride.distance.toString());
    _userNameController = TextEditingController(text: widget.ride.userName);
    _locationStartController =
        TextEditingController(text: widget.ride.locationStart);
    _locationEndController =
        TextEditingController(text: widget.ride.locationEnd);

    _selectedStartDateTime = widget.ride.startedAt;
    _selectedFinishDateTime = widget.ride.finishedAt;

    _locationSubscription =
        locationService.locationStream.listen((location) {
          if (mounted) {
            setState(() {
              if (_isUpdatingStartLocation) {
                _locationStartController.text = location;
              } else {
                _locationEndController.text = location;
              }
            });
            DialogHelper.showSnackBar(context, 'Location updated.');
          }
        });
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    _rideTypeController.dispose();
    _distanceController.dispose();
    _userNameController.dispose();
    _locationStartController.dispose();
    _locationEndController.dispose();
    super.dispose();
  }

  void saveOrUpdateRide() {
    if (_distanceController.text.isEmpty || !_isValidTime()) return;

    final updatedRide = widget.ride.copyWith(
      startedAt: _selectedStartDateTime,
      finishedAt: _selectedFinishDateTime,
      rideType: _rideTypeController.text,
      distance: int.parse(_distanceController.text),
      locationStart: _locationStartController.text,
      locationEnd: _locationEndController.text,
    );

    rideService.saveRide(updatedRide, get<CarService>().activeCar.id).listen((_) {
      DialogHelper.showSnackBar(context, 'Ride saved successfully');
      Navigator.pop(context);
    });
  }

  bool _isValidTime() {
    if (_selectedStartDateTime != null &&
        _selectedFinishDateTime != null &&
        _selectedStartDateTime!.isBefore(_selectedFinishDateTime!)) {
      return true;
    }
    DialogHelper.showErrorDialog(context, 'Invalid Time',
        'Start time must be before finish time.');
    return false;
  }

  bool _isUpdatingStartLocation = true;

  void _requestStartLocation() {
    _isUpdatingStartLocation = true;
    locationService.requestLocation();
  }

  void _requestEndLocation() {
    _isUpdatingStartLocation = false;
    locationService.requestLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LocationField(
          controller: _locationStartController,
          label: 'Start Location',
          onPressed: _requestStartLocation,
          onLocationReceived: (location) {
            _locationStartController.text = location;
          },
        ),
        const SizedBox(height: 16),
        LocationField(
          controller: _locationEndController,
          label: 'End Location',
          onPressed: _requestEndLocation,
          onLocationReceived: (location) {
            _locationEndController.text = location;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _distanceController,
          decoration: const InputDecoration(labelText: 'Distance (km)'),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 16),
        DateTimePickerTile(
          label: 'Started at',
          dateTime: _selectedStartDateTime,
          onTap: () => _selectDateTime(context, true),
        ),
        DateTimePickerTile(
          label: 'Finished at',
          dateTime: _selectedFinishDateTime,
          onTap: () => _selectDateTime(context, false),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: saveOrUpdateRide,
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _selectDateTime(
      BuildContext context, bool isStartDateTime) async {
    final initialDate =
    isStartDateTime ? _selectedStartDateTime : _selectedFinishDateTime;
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate ?? DateTime.now()),
      );
      if (selectedTime != null) {
        final selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        setState(() {
          if (isStartDateTime) {
            _selectedStartDateTime = selectedDateTime;
          } else {
            _selectedFinishDateTime = selectedDateTime;
          }
        });
      }
    }
  }
}
