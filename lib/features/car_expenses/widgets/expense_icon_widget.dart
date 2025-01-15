import 'package:car_log/features/car_expenses/models/expense.dart';
import 'package:flutter/material.dart';

const _ICON_SIZE = 22.0;

// Icons for each expense type using Material Icons
final Map<ExpenseType, IconData> _expenseIcons = {
  ExpenseType.fuel: Icons.local_gas_station,
  ExpenseType.service: Icons.build,
  ExpenseType.repair: Icons.handyman,
  ExpenseType.insurance: Icons.shield,
  ExpenseType.other: Icons.more_vert,
};

class ExpenseIconWidget extends StatelessWidget {
  final ExpenseType expenseType;

  const ExpenseIconWidget({super.key, required this.expenseType});

  @override
  Widget build(BuildContext context) {
    return Icon(
      _expenseIcons[expenseType],
      color: Colors.blue,
      size: _ICON_SIZE,
    );
  }
}
