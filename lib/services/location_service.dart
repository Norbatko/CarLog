import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  final StreamController<String> _locationController = StreamController.broadcast();
  Stream<String> get locationStream => _locationController.stream;

  LocationService() {
    _checkPermissionsAndFetchLocation();
  }

  Future<void> _checkPermissionsAndFetchLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _locationController.addError('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _locationController.addError('Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _locationController.addError('Location permissions are permanently denied.');
      return;
    }

    _fetchCurrentLocation();
  }

  void _fetchCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();

      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);

      Placemark place = placemarks[0];
      String location = '${place.street}, ${place.locality}, ${place.country}';

      _locationController.add(location);
    } catch (e) {
      _locationController.addError('Failed to fetch location.');
    }
  }

  void requestLocation() {
    _fetchCurrentLocation();
  }

  void dispose() {
    _locationController.close();
  }
}
