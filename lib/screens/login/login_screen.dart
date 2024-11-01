import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';
import 'package:car_log/services/auth_service.dart';
import 'package:car_log/screens/cars_list/cars_list_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: "CarLog",
      onLogin: (LoginData data) async {
        final resultStatus = await _authenticateUser(data);
        if (resultStatus != null) { return resultStatus;}
        _onLoginSuccess();
        return null;
      },
      onSignup: (SignupData data) => Provider.of<AuthService>(context, listen: false).signupUser(data),
      onRecoverPassword: (String name) => Provider.of<AuthService>(context, listen: false).recoverPassword(name),
      theme: LoginTheme(primaryColor: Colors.blue),
    );
  }

  void _onLoginSuccess() {
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const CarListScreen()),
        );
      }
    });
  }

}
