import 'package:car_log/model/user.dart';
import 'package:car_log/services/Routes.dart';
import 'package:car_log/screens/users_list/widgets/users_list.dart';
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
      appBar: ApplicationBar(
          title: 'User List', userDetailRoute: Routes.userDetail),
      body: buildFutureWithStream<User?, List<User>>(
        future: _loadCurrentUser(authService, userService),
        stream: userService.users,
        loadingWidget: const Center(child: CircularProgressIndicator()),
        errorWidget: (error) =>
            Center(child: Text('Error loading data: $error')),
        onData: (context, currentUser, users) => UsersList(
            users: users, currentUser: currentUser, userService: userService),
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
}
