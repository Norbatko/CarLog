import 'package:flutter/material.dart';

class FavoriteFloatingActionButton extends StatelessWidget {
  final String routeName;

  const FavoriteFloatingActionButton({
    super.key,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, routeName),
      child: const Icon(Icons.add),
    );
  }
}
