import 'package:car_log/services/Routes.dart';
import 'package:car_log/widgets/theme/application_bar.dart';
import 'package:flutter/material.dart';
import 'package:car_log/model/car.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCallPage extends StatelessWidget {
  final Car car;

  const HelpCallPage({Key? key, required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: ApplicationBar(title: 'Emergency Assistance', userDetailRoute: Routes.userDetail),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(30),
                child: Icon(Icons.support_agent_rounded,
                    color: theme.colorScheme.primary, size: screenHeight * 0.12),
              ),
              const SizedBox(height: 30.0),
              Text(
                'Need Help?',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                'We\'re here to assist you in case of an emergency.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 40.0),

              // Emergency Number Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 25.0, horizontal: 40.0),
                  child: Column(
                    children: [
                      const Text(
                        'EMERGENCY NUMBER',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        car.insuranceContact,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50.0),

              // Call Slider Widget
              _SliderToCallWidget(phoneNumber: car.insuranceContact),
            ],
          ),
        ),
      ),
    );
  }
}

// Slider Widget
class _SliderToCallWidget extends StatefulWidget {
  final String phoneNumber;

  const _SliderToCallWidget({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  _SliderToCallWidgetState createState() => _SliderToCallWidgetState();
}

class _SliderToCallWidgetState extends State<_SliderToCallWidget> {
  double _slideValue = 0.28;

  @override
  Widget build(BuildContext context) {
    double sliderWidth = MediaQuery.of(context).size.width * 0.85;
    double sliderHeight = MediaQuery.of(context).size.height * 0.1;
    var theme = Theme.of(context);

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta! > 0) {
          double newSlideValue =
              _slideValue + details.primaryDelta! / sliderWidth;
          newSlideValue = newSlideValue.clamp(0.0, 1.0);

          setState(() {
            _slideValue = newSlideValue;
          });

          if (_slideValue == 1.0) {
            _makePhoneCall(widget.phoneNumber);
          }
        }
      },
      onHorizontalDragEnd: (details) {
        setState(() {
          _slideValue = 0.28;
        });
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
