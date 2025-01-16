import 'package:car_log/features/ride/main_car_ride/widgets/add_new_ride_dialog.dart';
import 'package:flutter/material.dart';

class StartRideButton extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final AnimationController animationController;
  final String position;

  const StartRideButton({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.animationController,
    required this.position,
  }) : super(key: key);

  @override
  _StartRideButtonState createState() => _StartRideButtonState();
}

class _StartRideButtonState extends State<StartRideButton> {
  bool isRiding = false;
  DateTime? start = null;
  DateTime? end = null;
  String startPosition = '';
  String endPosition = '';

  void _toggleRide() {
    if (isRiding) {
      _showDialog();
    } else {
      setState(() {
        isRiding = !isRiding;
        start = DateTime.now();
        startPosition = widget.position;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleRide,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        width: isRiding ? widget.screenWidth * 0.8 : widget.screenWidth * 1,
        height: widget.screenHeight * 0.08,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isRiding
                ? [Colors.redAccent, Colors.red]
                : [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: isRiding
                  ? Colors.red.withOpacity(0.4)
                  : Theme.of(context).colorScheme.primary.withOpacity(0.4),
              blurRadius: 12,
              offset: Offset(4, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedRotation(
              duration: Duration(milliseconds: 400),
              turns: isRiding ? 1 : 0,
              child: Icon(
                isRiding ? Icons.stop_circle_outlined : Icons.play_circle_fill,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              style: TextStyle(
                fontSize: isRiding ? 22 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              child: Text(isRiding ? 'STOP RIDE' : 'START RIDE'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text('Are you sure you want to finish the ride?')),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Continue",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isRiding = !isRiding;
                    end = DateTime.now();
                    endPosition = widget.position;
                  });
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AddNewRideDialog(
                          startOfRide: start ?? DateTime.now(),
                          endOfRide: end ?? DateTime.now(),
                          startPosition: startPosition,
                          endPosition: endPosition,
                        );
                      });
                },
                child: Text(
                  "Finish",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              )
            ],
          );
        });
  }
}
