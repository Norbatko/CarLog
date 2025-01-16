import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class RideMapSelector extends StatefulWidget {
  final flutterMap.MapController mapController;
  final LatLng? initialPosition;
  final void Function(LatLng) onLocationSelected;

  const RideMapSelector({
    Key? key,
    required this.mapController,
    this.initialPosition,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  _RideMapSelectorState createState() => _RideMapSelectorState();
}

class _RideMapSelectorState extends State<RideMapSelector> {
  LatLng? _selectedPosition;
  LatLng? _currentPosition;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocationOnMap();
  }

  Future<void> _fetchCurrentLocationOnMap() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        widget.mapController.move(_currentPosition!, 14.0);
      });
    } catch (e) {
      setState(() {
        _currentPosition = LatLng(49.210015, 16.598854);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Location')),
        body: Stack(
          children: [
            flutterMap.FlutterMap(
              mapController: widget.mapController,
              options: flutterMap.MapOptions(
                initialCenter: widget.initialPosition ?? LatLng(49.210015, 16.598854),
                initialZoom: 14.0,
                onTap: (_, point) {
                  setState(() {
                    _selectedPosition = point;
                  });
                },
              ),
              children: [
                flutterMap.TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                if (_selectedPosition != null)
                  flutterMap.MarkerLayer(
                    markers: [
                      flutterMap.Marker(
                        point: _selectedPosition!,
                        width: 50,
                        height: 50,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                if (_currentPosition != null)
                  flutterMap.MarkerLayer(
                    markers: [
                      flutterMap.Marker(
                        point: _currentPosition!,
                        width: 45,
                        height: 45,
                        child: Icon(
                          Icons.my_location,
                                color: Colors.blue,
                                size: 35,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: _selectedPosition != null
                    ? () {
                  widget.onLocationSelected(_selectedPosition!);
                  Navigator.pop(context);
                }
                    : null,
                child: const Text('Confirm Location'),
              ),
            ),
            Positioned(
              bottom: 80,
              right: 20,
              child: FloatingActionButton(
                onPressed: _isLoading ? null : _fetchCurrentLocationOnMap,
                tooltip: 'Go to Current Location',
                backgroundColor: Theme.of(context).primaryColor,
                child: _isLoading
                    ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : const Icon(Icons.my_location, color: Colors.white),
              ),
            ),
          ],
        ),
    );
  }
}