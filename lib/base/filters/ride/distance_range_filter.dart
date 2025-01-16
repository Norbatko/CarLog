import 'package:flutter/material.dart';

class DistanceFilter extends StatefulWidget {
  final int minDistance;
  final int maxDistance;
  final void Function(int? selectedMin, int? selectedMax)
      onDistanceRangeChanged;

  const DistanceFilter({
    super.key,
    required this.minDistance,
    required this.maxDistance,
    required this.onDistanceRangeChanged,
  });

  @override
  _DistanceFilterState createState() => _DistanceFilterState();
}

class _DistanceFilterState extends State<DistanceFilter> {
  late int _selectedMin;
  late int _selectedMax;
  late int _initialMin;
  late int _initialMax;

  @override
  void initState() {
    super.initState();
    _selectedMin = widget.minDistance;
    _selectedMax = widget.maxDistance;
    _initialMin = widget.minDistance;
    _initialMax = widget.maxDistance;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Distance Range',
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
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    if (value == '') {
                      _selectedMin = _initialMin;
                    } else {
                      _selectedMin = int.tryParse(value)!;
                    }
                  });
                  widget.onDistanceRangeChanged(_selectedMin, _selectedMax);
                },
                decoration: InputDecoration(
                  labelText: 'Min',
                  hintText: widget.minDistance.toStringAsFixed(2),
                  prefixIcon: const Icon(Icons.directions_car_filled),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    if (value == '') {
                      _selectedMax = _initialMax;
                    } else {
                      _selectedMax = int.tryParse(value)!;
                    }
                  });
                  widget.onDistanceRangeChanged(_selectedMin, _selectedMax);
                },
                decoration: InputDecoration(
                  labelText: 'Max',
                  hintText: widget.maxDistance.toStringAsFixed(2),
                  prefixIcon: const Icon(Icons.attach_money),
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
