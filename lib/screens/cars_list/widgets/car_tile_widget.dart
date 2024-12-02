import 'package:flutter/material.dart';
import 'package:car_log/model/car.dart';

const _CAR_NAME_FONT_SIZE = 16.0;
const _LICENSE_PLATE_FONT_SIZE = 14.0;
const _ICON_SIZE = 36.0;
const _BORDER_RADIUS = 16.0;
const _MARGIN = 8.0;
const _PADDING = 12.0;

  class CarTileWidget extends StatelessWidget {
  final Car car;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onNavigate;

  const CarTileWidget({
    super.key,
    required this.car,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(_MARGIN),
      padding: const EdgeInsets.all(_PADDING),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(_BORDER_RADIUS),
        border: Border.all(color: theme.colorScheme.primary),
      ),
      child: ListTile(
        leading: Icon(Icons.car_rental,
            color: theme.colorScheme.secondary, size: _ICON_SIZE),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              car.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: _CAR_NAME_FONT_SIZE,
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
            Text(
              car.licensePlate,
              style: TextStyle(
                fontSize: _LICENSE_PLATE_FONT_SIZE,
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
          ],
        ),
        onTap: onNavigate,
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: onToggleFavorite,
        ),
      ),
    );
  }
}
