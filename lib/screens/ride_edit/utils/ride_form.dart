import 'dart:async';

import 'package:car_log/model/ride.dart';
import 'package:car_log/screens/ride_edit/utils/build_card_section.dart';
import 'package:car_log/screens/ride_edit/widget/date_time_picker_tile.dart';
import 'package:car_log/screens/ride_edit/widget/dialog_helper.dart';
import 'package:car_log/screens/ride_edit/widget/location_field.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/services/location_service.dart';
import 'package:car_log/services/ride_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  bool _isUpdatingStartLocation = true;

  @override
  void initState() {
    super.initState();
    _rideTypeController = TextEditingController(text: widget.ride.rideType);
    _distanceController = TextEditingController(text: widget.ride.distance.toString());
    _userNameController = TextEditingController(text: widget.ride.userName);
    _locationStartController = TextEditingController(text: widget.ride.locationStart);
    _locationEndController = TextEditingController(text: widget.ride.locationEnd);
    _selectedStartDateTime = widget.ride.startedAt;
    _selectedFinishDateTime = widget.ride.finishedAt;
    _locationSubscription = locationService.locationStream.listen((location) {
      if (mounted) {
        setState(() => _isUpdatingStartLocation
            ? _locationStartController.text = location
            : _locationEndController.text = location
        );
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

    rideService
        .saveRide(updatedRide, get<CarService>().activeCar.id)
        .listen((_) {
      DialogHelper.showSnackBar(context, 'Ride saved successfully');
      Navigator.pop(context);
    });
  }

  bool _isValidTime() {
    if (_selectedStartDateTime != null && _selectedFinishDateTime != null &&
        _selectedStartDateTime!.isBefore(_selectedFinishDateTime!)) {
      return true;
    }
    DialogHelper.showErrorDialog(context, 'Invalid Time', 'Start time must be before finish time.');
    return false;
  }

  void _requestLocation(bool isStartLocation) {
    isStartLocation ? _isUpdatingStartLocation = true : _isUpdatingStartLocation = false;
    locationService.requestLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BuildCardSection(
              context: context,
              title: 'Location Details',
              children: [
                LocationField(
                  controller: _locationStartController,
                  label: 'Start Location',
                  onPressed: () => _requestLocation(true),
                ),
                const SizedBox(height: 16),
                LocationField(
                  controller: _locationEndController,
                  label: 'End Location',
                  onPressed: () => _requestLocation(false),
                ),
              ]),
          BuildCardSection(context: context, title: 'Ride Details', children: [
            TextFormField(
              controller: _distanceController,
              decoration: const InputDecoration(
                labelText: 'Distance (km)',
                prefixIcon: Icon(Icons.directions_car),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ]),
          BuildCardSection(context: context, title: 'Time', children: [
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
          ]),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('Save Ride'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: saveOrUpdateRide,
          ),
        ],
      ),
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
    if (selectedDate == null) return;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate ?? DateTime.now()),
    );
    if (selectedTime == null) return;

    final selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    setState(() => isStartDateTime
        ? _selectedStartDateTime = selectedDateTime
        : _selectedFinishDateTime = selectedDateTime);
  }
}
