import 'package:car_log/screens/user_detail/widgets/user_details_card_container.dart';
import 'package:car_log/services/Routes.dart';
import 'package:flutter/material.dart';
import 'package:car_log/services/auth_service.dart';
import 'package:car_log/services/user_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:car_log/model/user.dart';
import 'package:car_log/screens/user_detail/widgets/log_out_button.dart';
import 'package:car_log/widgets/theme/theme_color_picker.dart';

const _SIZED_BOX_HEIGHT = 16.0;
const _EDGE_INSETS = 16.0;
const _BIG_SIZED_BOX_HEIGHT = 40.0;
const _FONT_SIZE = 20.0;
const _IMAGE_HEIGHT = 80.0;

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _authService = get<AuthService>();
    final _userService = get<UserService>();
    final _userId = ModalRoute.of(context)?.settings.arguments as String?;
    final _isLoggedInUser = _userId == null;

    return Scaffold(
      appBar: _buildAppBar(context, _isLoggedInUser),
      body: _buildBody(_authService, _userService, _userId, _isLoggedInUser),
    );
  }

  AppBar _buildAppBar(BuildContext context, bool isLoggedInUser) {
    final theme = Theme.of(context);
    return AppBar(
      title: Text(
        isLoggedInUser ? 'My Details' : 'User Details',
        style: TextStyle(color: theme.colorScheme.onSecondary),
      ),
      backgroundColor: theme.colorScheme.primary,
    );
  }

  Widget _buildBody(AuthService authService, UserService userService,
      String? userId, bool isLoggedInUser) {
    final userStream = isLoggedInUser
        ? authService.getCurrentUser()
        : userService.getUserData(userId!);

    return StreamBuilder<User?>(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final user = snapshot.data;
        if (user == null) {
          return const Center(child: Text('User not found'));
        }

        return _buildContent(context, user, authService, isLoggedInUser);
      },
    );
  }

  Widget _buildContent(BuildContext context, User user, AuthService authService,
      bool isLoggedInUser) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(_SIZED_BOX_HEIGHT),
            children: [
              if (isLoggedInUser) ...[
                _buildSectionTitle('Choose Theme'),
                const SizedBox(height: _SIZED_BOX_HEIGHT),
                const ThemeColorPicker(),
                const SizedBox(height: _SIZED_BOX_HEIGHT),
              ],
              _buildSectionTitle('Profile Details'),
              const SizedBox(height: _SIZED_BOX_HEIGHT),
              UserDetailsCardContainer(user: user),
              if (isLoggedInUser) ...[
                const SizedBox(height: _BIG_SIZED_BOX_HEIGHT),
                LogoutButton(
                  onLogout: () {
                    authService.logOut();
                    Navigator.pushReplacementNamed(context, Routes.login);
                  },
                ),
              ],
            ],
          ),
        ),
        _buildLogo(),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: _FONT_SIZE, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.all(_EDGE_INSETS),
      child: Column(
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: _IMAGE_HEIGHT,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
