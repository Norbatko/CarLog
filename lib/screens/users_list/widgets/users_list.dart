import 'package:car_log/model/user.dart';
import 'package:car_log/screens/users_list/widgets/user_tile_widget.dart';
import 'package:car_log/services/user_service.dart';
import 'package:flutter/material.dart';

class UsersList extends StatefulWidget {
  final List<User> users;
  final User? currentUser;
  final UserService userService;

  const UsersList({
    super.key,
    required this.users,
    this.currentUser,
    required this.userService,
  });

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  late List<User> sortedUsers;

  @override
  void initState() {
    super.initState();
    _sortUsers();
  }

  void _sortUsers() {
    final adminUsers = widget.users.where((user) => user.isAdmin).toList();
    final otherUsers = widget.users.where((user) => !user.isAdmin).toList();
    sortedUsers = adminUsers..addAll(otherUsers);
  }

  @override
  Widget build(BuildContext context) {
    _sortUsers();
    if (widget.currentUser != null) {
      sortedUsers.removeWhere((user) => user.id == widget.currentUser!.id);
    }
    return sortedUsers.isEmpty
        ? const Center(child: Text('No users available'))
        : ListView.builder(
            itemCount: sortedUsers.length,
            itemBuilder: (context, index) {
              final user = sortedUsers[index];
              return UserTileWidget(
                user: user,
                onNavigate: () => Navigator.pushNamed(context, '/user/detail',
                    arguments: user.id),
              );
            },
          );
  }
}
