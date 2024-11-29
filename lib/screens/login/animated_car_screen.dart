import 'package:car_log/model/user.dart';
import 'package:car_log/screens/cars_list/cars_list_screen.dart';
import 'package:car_log/screens/users_list/users_list_screen.dart';
import 'package:car_log/widgets/tab_manager.dart';
import 'package:flutter/material.dart';

class AnimatedCarScreen extends StatefulWidget {
  @override
  _AnimatedCarScreenState createState() => _AnimatedCarScreenState();
}

class _AnimatedCarScreenState extends State<AnimatedCarScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _carAnimation;
  late Animation<double> _carScaleAnimation;

  @override
  void initState() {
    super.initState();

    _loadBackgroundImage(); // Start loading background image

    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Shorter animation duration
      vsync: this,
    );

    _carAnimation = Tween<double>(begin: -0.08, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _carScaleAnimation = Tween<double>(begin: 0.3, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                TabManager(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadBackgroundImage() async {
    await precacheImage(
        AssetImage('assets/images/logo_with_bigger_road.jpeg'), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _loadBackgroundImage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Future.delayed(Duration(milliseconds: 100), () {
              if (mounted) _controller.forward();
            });

            return Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/logo_with_bigger_road.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final screenHeight = MediaQuery.of(context).size.height;
                    return Positioned(
                      top: _carAnimation.value * screenHeight,
                      left: MediaQuery.of(context).size.width / 4 - 40,
                      child: Transform.scale(
                        scale: _carScaleAnimation.value,
                        child: child,
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/images/car.png',
                    width: 100,
                    height: 100,
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
