import 'package:flutter/material.dart';

class FavoriteButtonWidget extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const FavoriteButtonWidget({
    super.key,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.grey,
      ),
      onPressed: onToggleFavorite,
    );
  }
}
