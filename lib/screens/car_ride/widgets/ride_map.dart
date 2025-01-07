// ride_map.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:latlong2/latlong.dart';

class RideMap extends StatelessWidget {
  final flutterMap.MapController mapController;
  final LatLng? currentPosition;
  final double screenHeight;

  const RideMap({
    Key? key,
    required this.mapController,
    required this.currentPosition,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.25,
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blueAccent, width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          alignment: Alignment.center,
          children: [
            flutterMap.FlutterMap(
              mapController: mapController,
              options: flutterMap.MapOptions(
                initialCenter: currentPosition ?? LatLng(49.210015, 16.598854),
                initialZoom: 14.0,
              ),
              children: [
                flutterMap.TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                if (currentPosition != null)
                  flutterMap.MarkerLayer(
                    markers: [
                      flutterMap.Marker(
                        point: currentPosition!,
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
            if (currentPosition == null) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
