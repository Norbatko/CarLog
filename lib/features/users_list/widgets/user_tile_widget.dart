import 'package:flutter/material.dart';
import 'package:car_log/model/user.dart';

const _EDGE_INSETS = 5.0;
const _BORDER_RADIUS = 16.0;
const _LIST_TILE_ICON_SIZE = 42.0;
const _LIST_TILE_NAME_FONT_SIZE = 20.0;
const _LIST_TILE_EMAIL_FONT_SIZE = 14.0;
const _LIST_TILE_ADMIN_ICON_SIZE = 30.0;

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
      margin: const EdgeInsets.all(_EDGE_INSETS),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(_BORDER_RADIUS),
        border: Border.all(color: theme.colorScheme.primary),
      ),
      child: ListTile(
        leading: Icon(Icons.account_circle,
            color: theme.colorScheme.secondary, size: _LIST_TILE_ICON_SIZE),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: _LIST_TILE_NAME_FONT_SIZE,
                    color: theme.colorScheme.onSecondaryContainer)),
            Text(user.email,
                style: TextStyle(
                    fontSize: _LIST_TILE_EMAIL_FONT_SIZE,
                    color: theme.colorScheme.onSecondaryContainer)),
          ],
        ),
        onTap: onNavigate,
        trailing: user.isAdmin
            ? Tooltip(
                message: 'Admin User',
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_BORDER_RADIUS),
                  color: Colors.green,
                  border: Border.all(color: Colors.teal),
                ),
                child: Icon(
                  Icons.admin_panel_settings,
                  color: Colors.green,
                  size: _LIST_TILE_ADMIN_ICON_SIZE,
                ),
              )
            : null,
      ),
    );
  }
}
