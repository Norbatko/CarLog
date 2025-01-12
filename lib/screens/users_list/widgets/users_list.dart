import 'package:car_log/model/user.dart';
import 'package:car_log/screens/users_list/widgets/user_tile_widget.dart';
import 'package:car_log/services/user_service.dart';
import 'package:car_log/widgets/filters/name_filter.dart';
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
  late List<User> filteredUsers;

  @override
  void initState() {
    super.initState();
    _initializeFilteredUsers();
  }

  void _initializeFilteredUsers() {
    filteredUsers = List.from(widget.users);
    filteredUsers.sort((a, b) {
      if (a.isAdmin && !b.isAdmin) return -1;
      if (!a.isAdmin && b.isAdmin) return 1;
      return 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentUser != null) {
      filteredUsers.removeWhere((user) => user.id == widget.currentUser!.id);
    }

    return filteredUsers.isEmpty
        ? const Center(child: Text('No users available'))
        : Column(
            children: [
              NameFilter(
                onChanged: (query) {
                  setState(() {
                    _filterUsers(query);
                  });
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return UserTileWidget(
                      user: user,
                      onNavigate: () => Navigator.pushNamed(
                        context,
                        '/user/detail',
                        arguments: user.id,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }

  void _filterUsers(String query) {
    final lowerCaseQuery = query.toLowerCase();
    filteredUsers = widget.users.where((user) {
      final userName = user.name.toLowerCase();
      final userEmail = user.email.toLowerCase();
      return userName.contains(lowerCaseQuery) ||
          userEmail.contains(lowerCaseQuery);
    }).toList();

    // Sort the filtered list by admin status
    filteredUsers.sort((a, b) {
      if (a.isAdmin && !b.isAdmin) return -1;
      if (!a.isAdmin && b.isAdmin) return 1;
      return 0;
    });
  }
}
