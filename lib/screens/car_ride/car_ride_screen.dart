import 'package:car_log/services/Routes.dart';
import 'package:car_log/widgets/theme/application_bar.dart';
import 'package:flutter/material.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/model/car.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart';

class CarRideScreen extends StatefulWidget {
  @override
  _CarRideScreenState createState() => _CarRideScreenState();
}

class _CarRideScreenState extends State<CarRideScreen> with SingleTickerProviderStateMixin {
  final CarService _carService = GetIt.instance<CarService>();
  late Car activeCar;
  bool isRiding = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Alignment> _alignmentAnimation;

  @override
  void initState() {
    super.initState();
    activeCar = _carService.getActiveCar();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _alignmentAnimation = AlignmentTween(
      begin: Alignment.center,
      end: Alignment.bottomCenter,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: ApplicationBar(title: 'Start Ride', userDetailRoute: Routes.userDetail),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: _buildCarDetailsCard()),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Assistance Request Sent!')),
                      );
                    },
                    child: Lottie.asset(
                      'assets/animations/calling_phone.json',
                      width: screenWidth * 0.15,
                      height: screenWidth * 0.15,
                      repeat: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildOdometerDisplay(),
              const SizedBox(height: 24),
              Container(
                height: screenHeight * 0.25,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blueAccent, width: 1.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(51.5, -0.09),
                      initialZoom: 14.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                      ),
                    ],
                  ),
                ),
              ),
              Center(child: _buildStartRideButton(screenWidth)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarDetailsCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.directions_car, size: 60),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activeCar.name,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  'License: ${activeCar.licensePlate}',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOdometerDisplay() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blueAccent, width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            'Odometer Status',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            '${activeCar.odometerStatus} km',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildStartRideButton(double screenWidth) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isRiding = !isRiding;
          isRiding ? _animationController.forward() : _animationController
              .reverse();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(
              isRiding ? 'Ride Started Successfully!' : 'Ride Stopped!')
          ),
        );
      },
      child: ClipPath(
        child: Container(
          width: screenWidth * 1,
          height: screenWidth * 0.6,
          child: Lottie.asset(
            'assets/animations/start-stop.json',
            controller: _animationController,
            repeat: false,
            animate: true,
            onLoaded: (composition) {
              setState(() {
                _animationController.duration = composition.duration;
              });
            },
          ),
        ),
      ),

    );
  }
}