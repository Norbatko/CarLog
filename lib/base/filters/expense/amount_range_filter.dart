import 'package:flutter/material.dart';

class AmountFilter extends StatefulWidget {
  final double minAmount;
  final double maxAmount;
  final void Function(double? selectedMin, double? selectedMax)
      onAmountRangeChanged;

  const AmountFilter({
    super.key,
    required this.minAmount,
    required this.maxAmount,
    required this.onAmountRangeChanged,
  });

  @override
  _AmountFilterState createState() => _AmountFilterState();
}

class _AmountFilterState extends State<AmountFilter> {
  late double _selectedMin;
  late double _selectedMax;
  late double _initialMin;
  late double _initialMax;

  @override
  void initState() {
    super.initState();
    _selectedMin = widget.minAmount;
    _selectedMax = widget.maxAmount;
    _initialMin = widget.minAmount;
    _initialMax = widget.maxAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount Range',
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
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    if (value == '') {
                      _selectedMin = _initialMin;
                    } else {
                      _selectedMin = double.tryParse(value)!;
                    }
                  });
                  widget.onAmountRangeChanged(_selectedMin, _selectedMax);
                },
                decoration: InputDecoration(
                  labelText: 'Min',
                  hintText: widget.minAmount.toStringAsFixed(2),
                  prefixIcon: const Icon(Icons.attach_money),
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
                      _selectedMax = double.tryParse(value)!;
                    }
                  });
                  widget.onAmountRangeChanged(_selectedMin, _selectedMax);
                },
                decoration: InputDecoration(
                  labelText: 'Max',
                  hintText: widget.maxAmount.toStringAsFixed(2),
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
