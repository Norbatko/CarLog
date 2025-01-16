import 'package:car_log/features/cars_list/widgets/car_details_widget.dart';
import 'package:car_log/features/cars_list/widgets/favorite_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:car_log/base/models/car.dart';

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
        leading: Icon(car.getCarIcon()),
        title: CarDetailsWidget(car: car),
        onTap: onNavigate,
        trailing: FavoriteButtonWidget(
          isFavorite: isFavorite,
          onToggleFavorite: onToggleFavorite,
        ),
      ),
    );
  }
}
