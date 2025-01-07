import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:latlong2/latlong.dart';
import 'package:car_log/services/location_service.dart';
import 'package:car_log/set_up_locator.dart';
class RideMapSelector extends StatefulWidget {
  final flutterMap.MapController mapController;
  final LatLng? initialPosition;
  final Function(LatLng) onLocationSelected;

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
        ],
      ),
    );
  }
}

class RideFormMapField extends StatelessWidget {
  final TextEditingController controller;
  final flutterMap.MapController mapController;
  final String label;
  final bool isStartLocation;
  final Function(LatLng) onLocationSelected;

  RideFormMapField({
    Key? key,
    required this.controller,
    required this.mapController,
    required this.label,
    required this.isStartLocation,
    required this.onLocationSelected,
  }) : super(key: key);

  final LocationService locationService = get<LocationService>();

  void _openMapSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: RideMapSelector(
            mapController: mapController,
            onLocationSelected: (LatLng point) {
              onLocationSelected(point);
              locationService
                  .reverseGeocode(point)
                  .then((address) {
                controller.text = address;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$label updated to $address.')),
                );
              }).catchError((_) {
                controller.text = '${point.latitude}, ${point.longitude}';
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: const Icon(Icons.map),
          onPressed: () => _openMapSelector(context),
        ),
      ),
    );
  }
}

