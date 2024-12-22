import 'package:car_log/screens/login/animated_car_screen.dart';
import 'package:car_log/screens/user_detail/user_detail_screen.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:car_log/widgets/car_tab_manager.dart';
import 'package:car_log/widgets/tab_manager.dart';
import 'package:car_log/widgets/theme/theme_setter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:car_log/screens/login/login_screen.dart';
import 'firebase_db/firebase_options.dart';
import 'package:car_log/services/Routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SetUpLocator.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = get<ThemeProvider>();

    return AnimatedBuilder(
        animation: themeProvider,
        builder: (context, _) {
          return MaterialApp(
            title: 'CarLog',
            theme: themeProvider.themeData,
            initialRoute: Routes.login,
            routes: {
              Routes.login: (context) => LoginScreen(),
              Routes.carAnimation: (context) => AnimatedCarScreen(),
              Routes.userDetail: (context) => const UserDetailScreen(),
              Routes.carDetail: (context) => CarTabManager(),
              Routes.carNavigation: (context) => TabManager(),
            },
          );
        });
  }
}
