import 'package:car_log/features/ride/ride_edit/utils/build_card_section.dart';
import 'package:car_log/features/ride/ride_edit/utils/ride_form_constants.dart';
import 'package:car_log/features/ride/ride_edit/widget/date_time_picker_tile.dart';
import 'package:flutter/material.dart';

class TimeDetailsSection extends StatelessWidget {
  final DateTime? selectedStartDateTime;
  final DateTime? selectedFinishDateTime;
  final void Function(DateTime? start, DateTime? finish) onDatesChanged;
  final Future<void> Function(BuildContext, bool) selectDateTime;

  const TimeDetailsSection({
    required this.selectedStartDateTime,
    required this.selectedFinishDateTime,
    required this.onDatesChanged,
    required this.selectDateTime,
  });

  @override
  Widget build(BuildContext context) {
    return BuildCardSection(
      context: context,
      title: RideFormConstants.TIME_DETAILS_TITLE,
      children: [
        DateTimePickerTile(label: RideFormConstants.STARTED_AT_LABEL, dateTime: selectedStartDateTime, onTap: () => selectDateTime(context, true)),
        DateTimePickerTile(label: RideFormConstants.FINISHED_AT_LABEL, dateTime: selectedFinishDateTime, onTap: () => selectDateTime(context, false)),
      ],
    );
  }
}