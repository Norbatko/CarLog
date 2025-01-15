import 'package:car_log/model/user.dart';
import 'package:car_log/routes.dart';
import 'package:car_log/base/builders/stream_custom_builder.dart';
import 'package:car_log/base/theme/application_bar.dart';
import 'package:flutter/material.dart';
import 'package:car_log/base/services/user_service.dart';
import 'users_list.dart';

const _APP_BAR_TITLE = 'User List';
const _CURRENT_USER = 'currentUser';
const _USERS = 'users';

class UserListScaffold extends StatelessWidget {
  const UserListScaffold({
    super.key,
    required this.combinedStream,
    required UserService userService,
  }) : _userService = userService;

  final Stream<Map<String, dynamic>> combinedStream;
  final UserService _userService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationBar(
        title: _APP_BAR_TITLE,
        userDetailRoute: Routes.userDetail,
      ),
      body: StreamCustomBuilder<Map<String, dynamic>>(
        stream: combinedStream,
        builder: (context, data) {
          final currentUser = data[_CURRENT_USER] as User?;
          final users = data[_USERS] as List<User>? ?? [];

          return UsersList(
            users: users,
            currentUser: currentUser,
            userService: _userService,
          );
        },
      ),
    );
  }
}