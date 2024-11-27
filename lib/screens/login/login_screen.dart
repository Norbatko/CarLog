import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:car_log/services/auth_service.dart';
import 'package:car_log/model/user.dart';
import 'package:car_log/model/user_model.dart';
import 'package:car_log/widgets/tab_manager.dart';
import 'package:get_it/get_it.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = GetIt.instance<AuthService>();
  final UserModel userModel = GetIt.instance<UserModel>();

  Future<String?> _authenticateUser(LoginData data) async {
    try {
      return await authService.authUser(data);
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> _onSignup(SignupData data) async {
    try {
      final userId = await authService.signupUser(data);

      if (userId != null) {
        String name = data.additionalSignupData?['name'] ?? '';
        String login = data.additionalSignupData?['login'] ?? '';
        String phoneNumber = data.additionalSignupData?['phoneNumber'] ?? '';

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
      MaterialPageRoute(builder: (context) => const TabManager()),
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
          icon: Icon(Icons.person),
        ),
        UserFormField(
          keyName: 'login',
          displayName: 'Username',
          icon: Icon(Icons.account_circle),
        ),
        UserFormField(
          keyName: 'phoneNumber',
          displayName: 'Phone Number',
          icon: Icon(Icons.phone),
        ),
      ],
      theme: LoginTheme(
        primaryColor: Colors.blueAccent,
        logoWidth: 150,
      ),
      savedEmail: "miro@mail.co.uk",
      savedPassword: "123456",
    );
  }
}
