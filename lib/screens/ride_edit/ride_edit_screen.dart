import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:car_log/model/ride.dart';
import 'package:car_log/services/ride_service.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/set_up_locator.dart';

class RideEditScreen extends StatefulWidget {
  final Ride ride;

  const RideEditScreen({
    Key? key,
    required this.ride,
  }) : super(key: key);

  @override
  _RideEditScreenState createState() => _RideEditScreenState();
}

class _RideEditScreenState extends State<RideEditScreen> {
  late TextEditingController _rideTypeController;
  late TextEditingController _distanceController;
  late TextEditingController _userNameController;

  DateTime? _selectedStartDateTime;
  DateTime? _selectedFinishDateTime;

  bool updateOdometer = false;
  int initialDistance = 0;
  final RideService rideService = get<RideService>();

  @override
  void initState() {
    super.initState();
    _rideTypeController = TextEditingController(text: widget.ride.rideType);
    _distanceController =
        TextEditingController(text: widget.ride.distance.toString());
    _userNameController = TextEditingController(text: widget.ride.userName);

    _selectedStartDateTime = widget.ride.startedAt;
    _selectedFinishDateTime = widget.ride.finishedAt;
    initialDistance = widget.ride.distance;
  }

  @override
  void dispose() {
    _rideTypeController.dispose();
    _distanceController.dispose();
    _userNameController.dispose();
    super.dispose();
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

  void saveOrUpdateRide() {
    if (_distanceController.text.isEmpty || !isValidTime()) return;

    final updatedRide = widget.ride.copyWith(
      startedAt: _selectedStartDateTime,
      finishedAt: _selectedFinishDateTime,
      rideType: _rideTypeController.text,
      distance: int.parse(_distanceController.text),
    );

    rideService.saveRide(updatedRide, get<CarService>().activeCar.id).listen((_) {
      showSnackBar(context, 'Ride saved successfully');
      Navigator.pop(context);
    });
  }

  bool isValidTime() {
    if (_selectedStartDateTime != null &&
        _selectedFinishDateTime != null &&
        _selectedStartDateTime!.isBefore(_selectedFinishDateTime!)) {
      return true;
    }
    _showErrorDialog('Invalid Time', 'Start time must be before finish time.');
    return false;
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.ride.id.isEmpty ? 'Create Ride' : 'Edit Ride',
          style: TextStyle(color: theme.colorScheme.onPrimary),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Driver: ${widget.ride.userName}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDateTimeTile(
                      'Started at',
                      _selectedStartDateTime,
                          () => _selectDateTime(context, true),
                    ),
                  ),
                  Expanded(
                    child: _buildDateTimeTile(
                      'Finished at',
                      _selectedFinishDateTime,
                          () => _selectDateTime(context, false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _distanceController,
                decoration: const InputDecoration(labelText: 'Distance (km)'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Update Odometer'),
                value: updateOdometer,
                onChanged: (value) {
                  setState(() {
                    updateOdometer = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: saveOrUpdateRide,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeTile(
      String label, DateTime? dateTime, VoidCallback onTap) {
    return ListTile(
      title: Text('$label\n${dateTime != null ? DateFormat('dd.MM - HH:mm').format(dateTime) : ''}'),
      onTap: onTap,
      trailing: const Icon(Icons.edit_calendar),
    );
  }
}
