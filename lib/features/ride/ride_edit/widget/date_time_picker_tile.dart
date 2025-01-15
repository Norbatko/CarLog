import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePickerTile extends StatelessWidget {
  final String label;
  final DateTime? dateTime;
  final VoidCallback onTap;

  const DateTimePickerTile({
    Key? key,
    required this.label,
    required this.dateTime,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        '$label\n${dateTime != null ? DateFormat('dd.MM - HH:mm').format(dateTime!) : ''}',
      ),
      trailing: const Icon(Icons.edit_calendar),
      onTap: onTap,
    );
  }
}
