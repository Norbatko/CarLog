// car_ride_screen.dart
import 'package:car_log/model/car.dart';
import 'package:car_log/screens/car_ride/widgets/car_details_card.dart';
import 'package:car_log/screens/car_ride/widgets/odometer_display.dart';
import 'package:car_log/screens/car_ride/widgets/start_ride_button.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/services/location_service.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:car_log/widgets/theme/application_bar.dart';
import 'package:car_log/services/Routes.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

class CarRideScreen extends StatefulWidget {
  @override
  _CarRideScreenState createState() => _CarRideScreenState();
}

class _CarRideScreenState extends State<CarRideScreen> with SingleTickerProviderStateMixin {
  final CarService _carService = GetIt.instance<CarService>();
  late Car activeCar;
  bool isRiding = false;
  late AnimationController _animationController;
  late LocationService _locationService;
  LatLng? _currentPosition;
  late StreamSubscription<String> _locationSubscription;
  final flutterMap.MapController _mapController = flutterMap.MapController();

  @override
  void initState() {
    super.initState();
    activeCar = _carService.getActiveCar();
    _locationService = LocationService();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _locationSubscription = _locationService.locationStream.listen((location) {
      _fetchCoordinates(location);
    }, onError: (error) {
      print('Location error: $error');
    });

    _locationService.requestLocation();
  }

  void _fetchCoordinates(String location) async {
    List<Location> locations = await locationFromAddress(location);
    if (locations.isNotEmpty) {
      setState(() {
        _currentPosition = LatLng(locations.first.latitude, locations.first.longitude);
        _mapController.move(_currentPosition!, 14.0);
      });
    }
  }

  void _toggleRide(bool rideStatus) {
    setState(() {
      isRiding = rideStatus;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _locationSubscription.cancel();
    _locationService.dispose();
    super.dispose();
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
                  Expanded(child: CarDetailsCard(car: activeCar)),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Assistance Request Sent!')),
                      );
                    },
                    child: Lottie.asset(
                      'assets/animations/urgent_call.json',
                      width: screenWidth * 0.15,
                      height: screenWidth * 0.15,
                      repeat: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              OdometerDisplay(odometer: activeCar.odometerStatus),
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
                  child: flutterMap.FlutterMap(
                    mapController: _mapController,
                    options: flutterMap.MapOptions(
                      initialCenter: _currentPosition ?? LatLng(51.5, -0.09),
                      initialZoom: 14.0,
                    ),
                    children: [
                      flutterMap.TileLayer(
                        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                      ),
                      if (_currentPosition != null)
                        flutterMap.MarkerLayer(
                          markers: [
                            flutterMap.Marker(
                              point: _currentPosition!,
                              width: 50,
                              height: 50,
                              child: Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: StartRideButton(
                  screenWidth: screenWidth,
                  animationController: _animationController,
                  onRideToggle: _toggleRide,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}