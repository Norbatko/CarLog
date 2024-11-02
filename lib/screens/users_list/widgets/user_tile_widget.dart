import 'package:flutter/material.dart';
import 'package:car_log/model/user.dart';

class UserTileWidget extends StatelessWidget {
  final User user;
  final VoidCallback onNavigate;

  const UserTileWidget({
    super.key,
    required this.user,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: theme.colorScheme.primary),
      ),
      child: ListTile(
        leading: Icon(Icons.account_circle,
            color: theme.colorScheme.secondary, size: 42.0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: theme.colorScheme.onSecondaryContainer)),
            Text(user.email,
                style: TextStyle(
                    fontSize: 14.0,
                    color: theme.colorScheme.onSecondaryContainer)),
          ],
        ),
        onTap: onNavigate,
        trailing: user.isAdmin
            ? Tooltip(
                message: 'Admin User',
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.green,
                  border: Border.all(color: Colors.teal),
                ),
                child: Icon(
                  Icons.admin_panel_settings,
                  color: Colors.green,
                  size: 30.0,
                ),
              )
            : null,
      ),
    );
  }
}
