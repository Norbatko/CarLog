
import 'package:car_log/features/ride/ride_edit/utils/ride_form_constants.dart';
import 'package:car_log/features/ride/ride_edit/widget/ride_form/location_details_section.dart';
import 'package:car_log/features/ride/ride_edit/widget/ride_form/ride_details_section.dart';
import 'package:car_log/features/ride/ride_edit/widget/ride_form/time_details_section.dart';
import 'package:car_log/features/ride/services/location_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;

class RideFormFieldList extends StatefulWidget {
  final TextEditingController distanceController;
  final TextEditingController locationStartController;
  final TextEditingController locationEndController;
  final TextEditingController rideTypeController;
  final flutterMap.MapController mapController;
  final DateTime? selectedStartDateTime;
  final DateTime? selectedFinishDateTime;
  final void Function(DateTime? start, DateTime? finish) onDatesChanged;

  const RideFormFieldList({
    super.key,
    required this.locationStartController,
    required this.locationEndController,
    required this.distanceController,
    required this.mapController,
    required this.rideTypeController,
    required this.onDatesChanged,
    this.selectedStartDateTime,
    this.selectedFinishDateTime,
  });

  @override
  State<RideFormFieldList> createState() => _RideFormFieldListState();
}

class _RideFormFieldListState extends State<RideFormFieldList> {
  final LocationService locationService = get<LocationService>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LocationDetailsSection(
          locationService: locationService,
          locationStartController: widget.locationStartController,
          locationEndController: widget.locationEndController,
          mapController: widget.mapController,
        ),
        RideDetailsSection(
          distanceController: widget.distanceController,
          rideTypeController: widget.rideTypeController,
        ),
        TimeDetailsSection(
          selectedStartDateTime: widget.selectedStartDateTime,
          selectedFinishDateTime: widget.selectedFinishDateTime,
          onDatesChanged: widget.onDatesChanged,
          selectDateTime: _selectDateTime,
        ),
      ],
    );
  }

  Future<void> _selectDateTime(BuildContext context, bool isStartDateTime) async {
    final initialDate = isStartDateTime ? widget.selectedStartDateTime : widget.selectedFinishDateTime;
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(RideFormConstants.FIRST_YEAR),
      lastDate: DateTime(RideFormConstants.LAST_YEAR),
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

    if (isStartDateTime) {
      widget.onDatesChanged(selectedDateTime, widget.selectedFinishDateTime);
    } else {
      widget.onDatesChanged(widget.selectedStartDateTime, selectedDateTime);
    }
  }
}