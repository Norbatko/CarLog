import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutButton({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onLogout,
      style: ElevatedButton.styleFrom(
        backgroundColor:
        Theme.of(context).colorScheme.error.withOpacity(0.8),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      ),
      child: Text(
        'Logout',
        style: TextStyle(
          fontSize: 20,
          color: Theme.of(context).colorScheme.onError,
        ),
      ),
    );
  }
}
