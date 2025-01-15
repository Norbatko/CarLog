import 'package:car_log/features/ride/model/ride_type.dart';
import 'package:car_log/features/ride/ride_edit/ride_map/ride_map_selector.dart';
import 'package:car_log/features/ride/ride_edit/utils/build_card_section.dart';
import 'package:car_log/features/ride/ride_edit/utils/ride_form_constants.dart';
import 'package:car_log/features/ride/ride_edit/widget/date_time_picker_tile.dart';
import 'package:car_log/features/ride/services/location_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:latlong2/latlong.dart';

class RideFormFieldList extends StatefulWidget {
  final TextEditingController distanceController;
  final TextEditingController locationStartController;
  final TextEditingController locationEndController;
  final TextEditingController rideTypeController;
  final flutterMap.MapController mapController;
  final DateTime? selectedStartDateTime;
  final DateTime? selectedFinishDateTime;
  final void Function(DateTime? start, DateTime? finish) onDatesChanged;

  const RideFormFieldList(
      {super.key,
      required this.locationStartController,
      required this.locationEndController,
      required this.distanceController,
      required this.mapController,
      required this.rideTypeController,
      required this.onDatesChanged,
      this.selectedStartDateTime,
      this.selectedFinishDateTime});

  @override
  State<RideFormFieldList> createState() => _RideFormFieldListState();
}

class _RideFormFieldListState extends State<RideFormFieldList> {
  final LocationService locationService = get<LocationService>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BuildCardSection(
          context: context,
          title: RideFormConstants.LOCATION_DETAILS_TITLE,
          children: [
            RideFormMapField(
              controller: widget.locationStartController,
              mapController: widget.mapController,
              label: RideFormConstants.START_LOCATION_LABEL,
              isStartLocation: true,
              onLocationSelected: (LatLng point) {
                locationService.reverseGeocode(point).then((address) {
                  widget.locationStartController.text = address;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Start location updated to $address.')),
                  );
                }).catchError((_) {
                  widget.locationStartController.text =
                      '${point.latitude}, ${point.longitude}';
                });
              },
            ),
            const SizedBox(height: RideFormConstants.FIELD_SPACING),
            RideFormMapField(
              controller: widget.locationEndController,
              mapController: widget.mapController,
              label: RideFormConstants.END_LOCATION_LABEL,
              isStartLocation: false,
              onLocationSelected: (LatLng point) {
                locationService.reverseGeocode(point).then((address) {
                  widget.locationEndController.text = address;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('End location updated to $address.')),
                  );
                }).catchError((_) {
                  widget.locationEndController.text =
                      '${point.latitude}, ${point.longitude}';
                });
              },
            ),
          ],
        ),
        BuildCardSection(
          context: context,
          title: RideFormConstants.RIDE_DETAILS_TITLE,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: widget.distanceController,
                    decoration: const InputDecoration(
                      labelText: RideFormConstants.DISTANCE_LABEL,
                      prefixIcon: Icon(Icons.directions_car),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<RideType>(
                    value: stringToRideType(widget.rideTypeController
                        .text), // Convert initial string to enum
                    decoration: const InputDecoration(
                      labelText: 'Ride Type',
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: RideType.values.map((RideType type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type
                            .toString()
                            .split('.')
                            .last), // Display readable enum values
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        widget.rideTypeController.text =
                            newValue.toString().split('.').last;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        BuildCardSection(
          context: context,
          title: RideFormConstants.TIME_DETAILS_TITLE,
          children: [
            DateTimePickerTile(
              label: RideFormConstants.STARTED_AT_LABEL,
              dateTime: widget.selectedStartDateTime,
              onTap: () => _selectDateTime(context, true),
            ),
            DateTimePickerTile(
              label: RideFormConstants.FINISHED_AT_LABEL,
              dateTime: widget.selectedFinishDateTime,
              onTap: () => _selectDateTime(context, false),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectDateTime(
      BuildContext context, bool isStartDateTime) async {
    final initialDate = isStartDateTime
        ? widget.selectedStartDateTime
        : widget.selectedFinishDateTime;
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
