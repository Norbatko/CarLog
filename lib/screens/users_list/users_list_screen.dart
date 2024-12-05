import 'package:car_log/model/user.dart';
import 'package:car_log/services/Routes.dart';
import 'package:car_log/screens/users_list/widgets/users_list.dart';
import 'package:car_log/set_up_locator.dart';
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

    final currentUserStream = _loadCurrentUser(authService, userService);

    return Scaffold(
      appBar: ApplicationBar(
          title: 'User List', userDetailRoute: Routes.userDetail),
      body: StreamBuilder<User?>(
        stream: currentUserStream,
        builder: (context, currentUserSnapshot) {
          if (currentUserSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (currentUserSnapshot.hasError) {
            return Center(
                child: Text('Error loading current user: ${currentUserSnapshot.error}'));
          }

          final currentUser = currentUserSnapshot.data;

          return StreamBuilder<List<User>>(
            stream: userService.users,
            builder: (context, usersSnapshot) {
              if (usersSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (usersSnapshot.hasError) {
                return Center(
                    child: Text('Error loading users: ${usersSnapshot.error}'));
              }

              final users = usersSnapshot.data ?? [];
              return UsersList(
                users: users,
                currentUser: currentUser,
                userService: userService,
              );
            },
          );
        },
      ),
    );
  }

  Stream<User?> _loadCurrentUser(
      AuthService authService, UserService userService) async* {
    final userStream = authService.getCurrentUser();
    await for (final user in userStream) {
      if (user != null) {
        yield* userService.getUserData(user.id);
      } else {
        yield null;
      }
    }
  }
}
