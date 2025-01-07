import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StartRideButton extends StatefulWidget {
  final double screenWidth;
  final AnimationController animationController;
  final Function(bool) onRideToggle;

  const StartRideButton({
    Key? key,
    required this.screenWidth,
    required this.animationController,
    required this.onRideToggle,
  }) : super(key: key);

  @override
  _StartRideButtonState createState() => _StartRideButtonState();
}

class _StartRideButtonState extends State<StartRideButton> {
  bool isRiding = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isRiding = !isRiding;
          isRiding ? widget.animationController.forward() : widget.animationController.reverse();
        });
        widget.onRideToggle(isRiding);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isRiding ? 'Ride Started Successfully!' : 'Ride Stopped!',
            ),
          ),
        );
      },
      child: ClipPath(
        child: Container(
          width: widget.screenWidth * 1,
          height: widget.screenWidth * 0.6,
          child: Lottie.asset(
            'assets/animations/start-stop.json',
            controller: widget.animationController,
            repeat: false,
            animate: true,
            onLoaded: (composition) {
              setState(() {
                widget.animationController.duration = composition.duration;
              });
            },
          ),
        ),
      ),
    );
  }
}
