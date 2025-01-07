import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:latlong2/latlong.dart';
import 'package:car_log/services/location_service.dart';

class MapContainer extends StatelessWidget {
  final LocationService locationService;

  const MapContainer({Key? key, required this.locationService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blueAccent, width: 1.5),
      ),
      child: flutterMap.FlutterMap(
        options: flutterMap.MapOptions(
          initialCenter: LatLng(51.5, -0.09),
          initialZoom: 14.0,
        ),
        children: [
          flutterMap.TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
        ],
      ),
    );
  }
}
