import 'package:car_log/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:car_log/model/user.dart';
import 'package:car_log/screens/user_detail/widgets/log_out_button.dart';
import 'package:car_log/screens/user_detail/widgets/user_details_card.dart';
import 'package:car_log/services/user_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:car_log/widgets/theme/theme_color_picker.dart';
import 'package:car_log/widgets/builders/build_future.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = get<UserService>();
    final authService = get<AuthService>();
    final loggedInUser = authService.getCurrentUser();
    final userId = ModalRoute.of(context)?.settings.arguments as String?;
    final theme = Theme.of(context);
    final isLoggedInUser = userId == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            isLoggedInUser ? 'My Details' : 'User Details',
          style: TextStyle(color: theme.colorScheme.onSecondary),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: buildFuture<User?>(
        future: isLoggedInUser
            ? loggedInUser
            : userService.getUserData(userId),
        loadingWidget: const Center(child: CircularProgressIndicator()),
        errorWidget: (error) => Center(child: Text('Error: $error')),
        onData: (context, user) {
          if (user == null) {
            return const Center(child: Text('User not found'));
          }
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              if (isLoggedInUser) ...[
                const Text('Choose Theme:', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 16),
                const ThemeColorPicker(),
                const SizedBox(height: 24),
              ],
              const Text('Profile Details:', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 16),
              UserDetailsCard(user: user),
              if (isLoggedInUser) ...[
                const SizedBox(height: 40),
                LogoutButton(
                  onLogout: () {
                    authService.logOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
