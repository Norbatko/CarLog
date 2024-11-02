import 'package:car_log/screens/cars_list/widgets/favorite_floating_action_button.dart';
import 'package:car_log/screens/users_list/widgets/user_app_bar.dart';
import 'package:car_log/screens/users_list/widgets/user_tile_widget.dart';
import 'package:car_log/services/auth_service.dart';
import 'package:car_log/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:car_log/model/user.dart';
import 'package:provider/provider.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  User? currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);
    final user = await authService.getCurrentUser();

    if (user != null) {
      currentUser = await userService.getUserData(user.id);
      setState(() {}); // Refresh the UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const UserAppBar(title: 'User List', userDetailRoute: '/user/detail'),
      // body: Text("je"),
      body: Consumer<UserService>(
        builder: (context, userService, _) {
          return StreamBuilder<List<User>>(
            stream: userService.users,
            builder: (context, snapshot) {
              return _buildBodyContent(context, snapshot);
            },
          );
        },
      ),
      floatingActionButton:
          const FavoriteFloatingActionButton(routeName: '/add-user'),
    );
  }

  Widget _buildBodyContent(
      BuildContext context, AsyncSnapshot<List<User>> snapshot) {
    return snapshot.connectionState == ConnectionState.waiting
        ? _buildLoading()
        : snapshot.hasError
            ? _buildError(snapshot.error)
            : (!snapshot.hasData || snapshot.data!.isEmpty)
                ? _buildEmpty()
                : _buildUserList(snapshot.data!);
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());

  Widget _buildError(Object? error) =>
      Center(child: Text('Error loading users: $error'));

  Widget _buildEmpty() => const Center(child: Text('No users found'));

  Widget _buildUserList(List<User> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Consumer<UserService>(
          builder: (context, userService, _) {
            return UserTileWidget(
              user: user,
              onNavigate: () => Navigator.pushNamed(context, '/user-navigation',
                  arguments: user),
            );
          },
        );
      },
    );
  }
}
