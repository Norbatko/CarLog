import 'package:car_log/routes.dart';
import 'package:car_log/base/tab_managers/tab_manager.dart';
import 'package:flutter/material.dart';

const _ANIMATION_TWEEN_BEGIN = -0.08;
const _ANIMATION_TWEEN_END = 1.1;
const _SCALE_TWEEN_BEGIN = 0.3;
const _SCALE_TWEEN_END = 1.3;
const _OFFSET_BEGIN = 0.0;
const _OFFSET_END = 1.0;
const _BG_IMAGE_DURATION_IN_MS = 100;
const _ANIMATION_DURATION_IN_S = 3;
const _IMAGE_WIDTH = 100.0;
const _IMAGE_HEIGHT = 100.0;

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

    _loadBackgroundImage();

    _controller = AnimationController(
      duration: const Duration(seconds: _ANIMATION_DURATION_IN_S),
      vsync: this,
    );

    _carAnimation =
        Tween<double>(begin: _ANIMATION_TWEEN_BEGIN, end: _ANIMATION_TWEEN_END)
            .animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _carScaleAnimation =
        Tween<double>(begin: _SCALE_TWEEN_BEGIN, end: _SCALE_TWEEN_END).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                TabManager(),
            settings: RouteSettings(name: Routes.carNavigation),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(_OFFSET_BEGIN, _OFFSET_END);
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
            Future.delayed(Duration(milliseconds: _BG_IMAGE_DURATION_IN_MS),
                () {
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
                    width: _IMAGE_WIDTH,
                    height: _IMAGE_HEIGHT,
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
