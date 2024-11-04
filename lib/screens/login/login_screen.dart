import 'package:car_log/screens/cars_list/cars_list_screen.dart';
import 'package:car_log/screens/users_list/users_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:car_log/services/auth_service.dart';
import 'package:car_log/model/user.dart';
import 'package:car_log/model/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<String?> _authenticateUser(LoginData data) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    return await authService.authUser(data);
  }

  Future<String?> _onSignup(SignupData data) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userModel = Provider.of<UserModel>(context, listen: false);

    try {
      // Only perform Firebase authentication, retrieve userId
      final userId = await authService.signupUser(data);

      if (userId != null) {
        // Extract additional signup fields from FlutterLogin
        String name = data.additionalSignupData?['name'] ?? '';
        String login = data.additionalSignupData?['login'] ??
            data.name?.split('@')[0] ??
            '';
        String phoneNumber = data.additionalSignupData?['phoneNumber'] ?? '';

        // Create and save the user profile in Firebase
        final newUser = User(
          id: userId,
          name: name,
          login: login,
          email: data.name!,
          phoneNumber: phoneNumber,
          isAdmin: false,
          favoriteCars: [],
        );
        await userModel.addUser(newUser);
        _onLoginSuccess();
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  void _onLoginSuccess() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const UsersListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logo: const AssetImage('assets/images/logo.png'),
      onLogin: (LoginData data) async {
        final result = await _authenticateUser(data);
        if (result == null) {
          _onLoginSuccess();
        }
        return result;
      },
      onSignup: _onSignup,
      onRecoverPassword: (String name) =>
          Provider.of<AuthService>(context, listen: false)
              .recoverPassword(name),
      additionalSignupFields: const [
        UserFormField(
            keyName: 'name',
            displayName: 'Full Name',
            icon: Icon(Icons.person)),
        UserFormField(
            keyName: 'login',
            displayName: 'Username',
            icon: Icon(Icons.account_circle)),
        UserFormField(
            keyName: 'phoneNumber',
            displayName: 'Phone Number',
            icon: Icon(Icons.phone)),
      ],
      theme: LoginTheme(primaryColor: Colors.blueAccent, logoWidth: 150),
      savedEmail: "miro@mail.co.uk",
      savedPassword: "123456",
    );
  }
}
