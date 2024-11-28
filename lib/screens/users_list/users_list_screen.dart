import 'package:car_log/model/user.dart';
import 'package:car_log/screens/users_list/widgets/user_tile_widget.dart';
import 'package:car_log/services/Routes.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:car_log/widgets/builders/build_future_with_stream.dart';
import 'package:car_log/widgets/theme/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:car_log/services/auth_service.dart';
import 'package:car_log/services/user_service.dart';

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = get<AuthService>();
    final UserService userService = get<UserService>();

    return Scaffold(
      appBar: ApplicationBar(title: 'User List', userDetailRoute: Routes.userDetail),
      body: buildFutureWithStream<User?, List<User>>(
        future: _loadCurrentUser(authService, userService),
        stream: userService.users,
        loadingWidget: const Center(child: CircularProgressIndicator()),
        errorWidget: (error) => Center(child: Text('Error loading data: $error')),
        onData: (context, currentUser, users) => _buildBodyContent(context, currentUser, users),
      ),
    );
  }

  Future<User?> _loadCurrentUser(
      AuthService authService, UserService userService) async {
    final user = await authService.getCurrentUser();
    if (user != null) {
      return await userService.getUserData(user.id);
    }
    return null;
  }

  Widget _buildBodyContent(BuildContext context, User? currentUser, List<User> users) {
    if (users.isEmpty) {
      return const Center(child: Text('No users found'));
    }

    if (currentUser != null) {
      users.removeWhere((user) => user.id == currentUser.id);
    }
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return UserTileWidget(
          user: user,
          onNavigate: () => Navigator.pushNamed(context, '/user/detail', arguments: user.id),
        );
      },
    );
  }
}
