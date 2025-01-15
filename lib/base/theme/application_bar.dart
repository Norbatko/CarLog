import 'package:flutter/material.dart';

class ApplicationBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String userDetailRoute;

  const ApplicationBar({
    super.key,
    required this.title,
    required this.userDetailRoute,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
      backgroundColor: Theme.of(context).colorScheme.primary,
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.account_circle,
            color: Theme.of(context).colorScheme.onSecondary,
            size: 40,
          ),
          onPressed: () => Navigator.pushNamed(context, userDetailRoute),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
