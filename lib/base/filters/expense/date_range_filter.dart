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

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;

    if (_startDate != null) {
      _startDateController.text = _formatDate(_startDate!);
    }
    if (_endDate != null) {
      _endDateController.text = _formatDate(_endDate!);
    }
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
          _startDateController.text = _formatDate(selectedDate);
        } else {
          _endDate = selectedDate;
          _endDateController.text = _formatDate(selectedDate);
        }
      });
      widget.onDateRangeChanged(_startDate, _endDate);
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year.toString().substring(2)}";
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date Range',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        Divider(thickness: 1.0, color: Theme.of(context).primaryColor),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _startDateController,
                readOnly: true,
                onTap: () => _selectDate(context, isStartDate: true),
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                  hintText: 'Select start date',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _endDateController,
                readOnly: true,
                onTap: () => _selectDate(context, isStartDate: false),
                decoration: const InputDecoration(
                  labelText: 'End Date',
                  hintText: 'Select end date',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
