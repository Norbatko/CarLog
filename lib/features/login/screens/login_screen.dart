import 'package:car_log/features/login/screens/animated_car_screen.dart';
import 'package:car_log/routes.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:car_log/features/login/services/auth_service.dart';
import 'package:car_log/model/user.dart';
import 'package:car_log/model/user_model.dart';

const _LOGO_WIDTH = 150.0;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = get<AuthService>();
  final UserModel userModel = get<UserModel>();

  Stream<String?> _authenticateUser(LoginData data) {
    return authService.authUser(data);
  }

  Stream<String?> _onSignup(SignupData data) async* {
    try {
      await for (final userId in authService.signupUser(data)) {
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
        yield null;
      }
    } catch (e) {
      yield e.toString();
    }
  }

  void _onLoginSuccess() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => AnimatedCarScreen(),
        settings: RouteSettings(name: Routes.carAnimation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logo: const AssetImage('assets/images/logo.png'),
      onLogin: (LoginData data) async {
        final resultStream = _authenticateUser(data);
        await for (final result in resultStream) {
          if (result == null) {
            _onLoginSuccess();
          }
          return result;
        }
        return null;
      },
      onSignup: (SignupData data) async {
        final resultStream = _onSignup(data);
        await for (final result in resultStream) {
          return result;
        }
        return null;
      },
      onRecoverPassword: (String name) async {
        final recoverStream = authService.recoverPassword(name);
        await for (final result in recoverStream) {
          return result;
        }
        return "Error recovering password";
      },
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
        logoWidth: _LOGO_WIDTH,
      ),
      savedEmail: "miro@mail.co.uk",
      savedPassword: "123456",
    );
  }
}
