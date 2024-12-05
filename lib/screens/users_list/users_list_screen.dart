import 'package:car_log/model/user.dart';
import 'package:car_log/services/Routes.dart';
import 'package:car_log/screens/users_list/widgets/users_list.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:car_log/widgets/theme/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:car_log/services/auth_service.dart';
import 'package:car_log/services/user_service.dart';
import 'package:rxdart/rxdart.dart';

const _APP_BAR_TITLE = 'User List';
const _CURRENT_USER = 'currentUser';
const _USERS = 'users';

class UsersListScreen extends StatelessWidget {
  final AuthService _authService = get<AuthService>();
  final UserService _userService = get<UserService>();

  UsersListScreen({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    // Combine the currentUserStream and users stream
    final combinedStream = Rx.combineLatest2<User?, List<User>, Map<String, dynamic>>(
      _loadCurrentUser(_authService, _userService),
      _userService.users,
          (currentUser, users) => {
        _CURRENT_USER: currentUser,
        _USERS: users,
      },
    );

    return Scaffold(
      appBar: ApplicationBar(
        title: _APP_BAR_TITLE,
        userDetailRoute: Routes.userDetail,
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: combinedStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final data = snapshot.data ?? {};
          final currentUser = data['currentUser'] as User?;
          final users = data['users'] as List<User>? ?? [];

          return UsersList(
            users: users,
            currentUser: currentUser,
            userService: _userService,
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
