import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SliderToCall extends StatefulWidget {
  final String phoneNumber;

  const SliderToCall({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  _SliderToCallState createState() => _SliderToCallState();
}

class _SliderToCallState extends State<SliderToCall> {
  double _slideValue = 0.28;

  @override
  Widget build(BuildContext context) {
    double sliderWidth = MediaQuery.of(context).size.width * 0.85;
    double sliderHeight = MediaQuery.of(context).size.height * 0.1;
    var theme = Theme.of(context);

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta! > 0) {
          double newSlideValue = _slideValue + details.primaryDelta! / sliderWidth;

          newSlideValue = newSlideValue.clamp(0.0, 1.0);
          setState(() => _slideValue = newSlideValue);
          if (_slideValue == 1.0) {_makePhoneCall(widget.phoneNumber);}
        }
      },
      onHorizontalDragEnd: (details) {
        setState(() => _slideValue = 0.28);
      },
      child: Container(
        height: sliderHeight,
        width: sliderWidth,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _slideValue * sliderWidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: const Center(
                child: Icon(Icons.phone, color: Colors.white, size: 30),
              ),
            ),
            Center(
              child: Opacity(
                opacity: (1 - _slideValue).clamp(0.0, 1.0),
                child: const Text(
                  'Slide to open dial',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch the dialer.')),
      );
    }
  }
}
