import 'package:car_log/model/user.dart';
import 'package:car_log/screens/user_detail/widgets/log_out_button.dart';
import 'package:car_log/screens/user_detail/widgets/user_details_card.dart';
import 'package:car_log/services/database_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:car_log/widgets/builders/build_future.dart';
import 'package:car_log/widgets/section_tile.dart';
import 'package:flutter/material.dart';
import 'package:car_log/widgets/theme/theme_color_picker.dart';
import 'package:car_log/widgets/builders/build_future_with_stream.dart';
import 'package:car_log/services/auth_service.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final databaseService = get<DatabaseService>();
    final authService = AuthService(databaseService: databaseService);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Detail',
          style: TextStyle(color: theme.colorScheme.onSecondary),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: buildFuture<User?>(
        future: authService.getCurrentUser(),
        loadingWidget: const Center(child: CircularProgressIndicator()),
        errorWidget: (error) => Center(child: Text('Error: $error')),
        onData: (context, user) {
          if (user == null) {
            return const Center(child: Text('No user logged in'));
          }
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              const SectionTitle(title: 'Choose Theme:'),
              const SizedBox(height: 16),
              const ThemeColorPicker(),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Profile Details:'),
              const SizedBox(height: 16),
              UserDetailsCard(user: user),
              const SizedBox(height: 40),
              LogoutButton(
                onLogout: () {
                  authService.logOut();
                  Navigator.of(context).pushReplacementNamed('/login');
                },
              ),
            ],
          );
        },
      ),
    );
  }
}