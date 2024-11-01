import 'package:flutter/material.dart';
import 'package:car_log/model/car.dart';

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
    var theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: theme.colorScheme.primary),
      ),
      child: ListTile(
        leading: Icon(Icons.car_rental, color: theme.colorScheme.secondary, size: 36.0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(car.name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: theme.colorScheme.onSecondaryContainer)),
            Text(car.licensePlate,
                style: TextStyle(
                    fontSize: 14.0,
                    color: theme.colorScheme.onSecondaryContainer)),
          ],
        ),
        onTap: onNavigate,
        trailing: IconButton(
          icon: isFavorite ? const Icon(Icons.favorite, color: Colors.red) : const Icon(Icons.favorite_border),
          onPressed: onToggleFavorite,
        ),
      ),
    );
  }
}
