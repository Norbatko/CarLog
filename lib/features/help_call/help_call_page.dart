import 'package:car_log/features/help_call/widgets/slider_to_call.dart';
import 'package:car_log/routes.dart';
import 'package:car_log/base/theme/application_bar.dart';
import 'package:flutter/material.dart';
import 'package:car_log/model/car.dart';

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
              SliderToCall(phoneNumber: car.insuranceContact),
            ],
          ),
        ),
      ),
    );
  }
}