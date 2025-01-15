import 'package:flutter/material.dart';

class OdometerDisplay extends StatefulWidget {
  final Stream<String> odometerStream;
  final String initialOdometer;  // New parameter to pass the initial odometer value

  const OdometerDisplay({
    Key? key,
    required this.odometerStream,
    required this.initialOdometer,
  }) : super(key: key);

  @override
  _OdometerDisplayState createState() => _OdometerDisplayState();
}

class _OdometerDisplayState extends State<OdometerDisplay> {
  late String _odometerValue;

  @override
  void initState() {
    super.initState();
    _odometerValue = widget.initialOdometer;  // Set initial odometer from passed value
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: widget.odometerStream,
      initialData: _odometerValue,  // Use initialOdometer instead of '0'
      builder: (context, snapshot) {
        _odometerValue = snapshot.data ?? _odometerValue;  // Update value if stream provides data

        return Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Odometer Status',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: Text(
                    '$_odometerValue km',
                    key: ValueKey<String>(_odometerValue),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
