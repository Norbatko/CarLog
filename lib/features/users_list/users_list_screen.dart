import 'package:car_log/base/models/user.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';
import 'package:car_log/features/login/services/auth_service.dart';
import 'package:car_log/base/services/user_service.dart';
import 'package:rxdart/rxdart.dart';

import 'widgets/user_list_scaffold.dart';

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
    final combinedStream = Rx.combineLatest2<User?,
        List<User>,
        Map<String, dynamic>>(
      _loadCurrentUser(_authService, _userService),
      _userService.users,
          (currentUser, users) =>
      {
        _CURRENT_USER: currentUser,
        _USERS: users,
      },
    );
    return UserListScaffold(combinedStream: combinedStream, userService: _userService);
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