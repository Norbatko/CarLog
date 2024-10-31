import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:car_log/services/auth_service.dart';
import 'package:car_log/screens/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  final AuthService authService;

  const LoginScreen({super.key, required this.authService});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<String?> _authenticateUser(LoginData data) async {
    return await widget.authService.authUser(data);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      onLogin: (LoginData data) async {
        final resultStatus = await _authenticateUser(data);
        if (resultStatus != null) {
          return resultStatus;
        }
        _onLoginSuccess();
      },
      title: "CarLog",
      onSignup: (SignupData data) => widget.authService.signupUser(data),
      onRecoverPassword: (String name) => widget.authService.recoverPassword(name),
      theme: LoginTheme(primaryColor: Colors.blue),
    );
  }

  void _onLoginSuccess() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }
}
