import 'package:car_log/base/models/user.dart';
import 'package:car_log/features/users_list/widgets/user_tile_widget.dart';
import 'package:car_log/base/services/user_service.dart';
import 'package:car_log/base/filters/admin_filter.dart';
import 'package:car_log/base/filters/name_filter.dart';
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
  String _searchQuery = '';
  bool _isAdminFilter = false;

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

    // If the filtered list is empty, show the search bar and "No users available"
    if (filteredUsers.isEmpty && _searchQuery.isNotEmpty) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: NameFilter(
                  hintText: "Name or Email",
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                      _filterUsers();
                    });
                  },
                ),
              ),
              AdminFilter(
                onChanged: (bool isAdminFilter) {
                  setState(() {
                    _isAdminFilter = isAdminFilter;
                    _filterUsers();
                  });
                },
              ),
            ],
          ),
          const Center(child: Text('No users found')),
        ],
      );
    }

    return filteredUsers.isEmpty
        ? const Center(child: Text('No users available'))
        : Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: NameFilter(
                      hintText: "Name or Email",
                      onChanged: (query) {
                        setState(() {
                          _searchQuery = query;
                          _filterUsers();
                        });
                      },
                    ),
                  ),
                  AdminFilter(
                    onChanged: (bool isAdminFilter) {
                      setState(() {
                        _isAdminFilter = isAdminFilter;
                        _filterUsers();
                      });
                    },
                  )
                ],
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

  void _filterUsers() {
    filteredUsers = widget.users.where((user) {
      // Apply search filter
      final userName = user.name.toLowerCase();
      final userEmail = user.email.toLowerCase();
      final lowerCaseQuery = _searchQuery.toLowerCase();
      bool matchesQuery = userName.contains(lowerCaseQuery) ||
          userEmail.contains(lowerCaseQuery);

      // Apply isAdmin filter (if any)
      if (_isAdminFilter) {
        matchesQuery = matchesQuery && user.isAdmin == true;
      }

      return matchesQuery;
    }).toList();

    // Sort the filtered list by admin status
    filteredUsers.sort((a, b) {
      if (a.isAdmin && !b.isAdmin) return -1;
      if (!a.isAdmin && b.isAdmin) return 1;
      return 0;
    });
  }
}
