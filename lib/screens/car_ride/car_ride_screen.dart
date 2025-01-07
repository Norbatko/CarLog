import 'package:car_log/model/car.dart';
import 'package:car_log/screens/car_ride/widgets/car_details_card.dart';
import 'package:car_log/screens/car_ride/widgets/odometer_display.dart';
import 'package:car_log/screens/car_ride/widgets/start_ride_button.dart';
import 'package:car_log/screens/car_ride/widgets/ride_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get_it/get_it.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/services/location_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:car_log/widgets/theme/application_bar.dart';
import 'package:car_log/services/Routes.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

class CarRideScreen extends StatefulWidget {
  final bool isVisible;

  const CarRideScreen({Key? key, required this.isVisible}) : super(key: key);

  @override
  _CarRideScreenState createState() => _CarRideScreenState();
}

class _CarRideScreenState extends State<CarRideScreen>
    with SingleTickerProviderStateMixin {
  late Car activeCar;
  final CarService _carService = GetIt.instance<CarService>();
  late LocationService _locationService;
  late AnimationController _animationController;
  final MapController _mapController = MapController();
  LatLng? _currentPosition;
  late StreamSubscription<String> _locationSubscription;
  late StreamController<String> _odometerController;

  @override
  void initState() {
    super.initState();
    activeCar = _carService.getActiveCar();
    _locationService = LocationService();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _odometerController = StreamController<String>.broadcast();

    // Immediately set the current odometer value
    _odometerController.add(activeCar.odometerStatus);

    _carService.carStream.listen((car) {
      if (mounted) {
        _odometerController.add(car.odometerStatus);
      }
    });

    if (widget.isVisible) {
      _startLocationUpdates();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _odometerController.add(activeCar.odometerStatus);
  }

  void _startLocationUpdates() {
    _locationSubscription = _locationService.locationStream.listen((location) {
      _fetchCoordinates(location);
    }, onError: (error) {
      print('Location error: $error');
    });
    _locationService.requestLocation();
  }

  @override
  void didUpdateWidget(covariant CarRideScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _startLocationUpdates();
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _locationSubscription.cancel();
    }
  }

  void _fetchCoordinates(String location) async {
    List<Location> locations = await locationFromAddress(location);
    if (locations.isNotEmpty) {
      setState(() {
        _currentPosition =
            LatLng(locations.first.latitude, locations.first.longitude);
        _mapController.move(_currentPosition!, 14.0);
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _locationSubscription.cancel();
    _locationService.dispose();
    _odometerController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return const Offstage();
    }

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: ApplicationBar(
          title: 'Start Ride', userDetailRoute: Routes.userDetail),
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
                        const SnackBar(content: Text('Assistance Request Sent!')),
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
              OdometerDisplay(
                  odometerStream: _odometerController.stream,
                  initialOdometer: _carService.activeCar.odometerStatus),
              const SizedBox(height: 24),
              RideMap(
                mapController: _mapController,
                currentPosition: _currentPosition,
                screenHeight: screenHeight,
              ),
              const SizedBox(height: 24),
              Center(
                child: StartRideButton(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  animationController: _animationController,
                  startPosition: _currentPosition != null
                      ? _currentPosition.toString()
                      : '',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
