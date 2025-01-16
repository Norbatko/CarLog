import 'package:flutter/material.dart';
import 'package:car_log/features/car_history/widgets/car_history_constants.dart';

class RideInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;

  RideInfo({required this.icon, required this.label, this.iconColor = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: ICON_SIZE, color: iconColor),
          SIZED_BOX_WIDTH_12,
          Expanded(child: Text(label, style: TEXT_STYLE, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}