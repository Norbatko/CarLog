import 'package:flutter/material.dart';

class DateRangeFilter extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final void Function(DateTime? startDate, DateTime? endDate)
      onDateRangeChanged;

  const DateRangeFilter({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    required this.onDateRangeChanged,
  });

  @override
  _DateRangeFilterState createState() => _DateRangeFilterState();
}

class _DateRangeFilterState extends State<DateRangeFilter> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
  }

  Future<void> _selectDate(BuildContext context,
      {required bool isStartDate}) async {
    final initialDate =
        isStartDate ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = selectedDate;
        } else {
          _endDate = selectedDate;
        }
      });
      widget.onDateRangeChanged(_startDate, _endDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date Range',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                readOnly: true,
                onTap: () => _selectDate(context, isStartDate: true),
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  hintText: _startDate != null
                      ? _startDate!.toLocal().toString().split(' ')[0]
                      : 'Select start date',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                readOnly: true,
                onTap: () => _selectDate(context, isStartDate: false),
                decoration: InputDecoration(
                  labelText: 'End Date',
                  hintText: _endDate != null
                      ? _endDate!.toLocal().toString().split(' ')[0]
                      : 'Select end date',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
