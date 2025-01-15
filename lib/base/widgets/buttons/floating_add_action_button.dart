import 'package:flutter/material.dart';

class FloatingAddActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FloatingAddActionButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Icon(
        Icons.add,
        color: Theme.of(context).colorScheme.onSecondary,
      ),
      onPressed: onPressed,
    );
  }
}
