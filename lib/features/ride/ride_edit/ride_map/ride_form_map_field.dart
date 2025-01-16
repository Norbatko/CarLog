import 'package:car_log/features/ride/ride_edit/ride_map/ride_map_selector.dart';
import 'package:car_log/features/ride/services/location_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:latlong2/latlong.dart';

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