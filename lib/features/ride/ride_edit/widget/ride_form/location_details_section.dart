import 'package:car_log/features/ride/ride_edit/ride_map/ride_form_map_field.dart';
import 'package:car_log/features/ride/ride_edit/utils/build_card_section.dart';
import 'package:car_log/features/ride/ride_edit/utils/ride_form_constants.dart';
import 'package:car_log/features/ride/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:latlong2/latlong.dart';


class LocationDetailsSection extends StatelessWidget {
  final LocationService locationService;
  final TextEditingController locationStartController;
  final TextEditingController locationEndController;
  final flutterMap.MapController mapController;

  const LocationDetailsSection({
    required this.locationService,
    required this.locationStartController,
    required this.locationEndController,
    required this.mapController,
  });

  @override
  Widget build(BuildContext context) {
    return BuildCardSection(
      context: context,
      title: RideFormConstants.LOCATION_DETAILS_TITLE,
      children: [
        RideFormMapField(
          controller: locationStartController,
          mapController: mapController,
          label: RideFormConstants.START_LOCATION_LABEL,
          isStartLocation: true,
          onLocationSelected: (LatLng point) => _updateLocation(point, locationStartController, context),
        ),
        const SizedBox(height: RideFormConstants.FIELD_SPACING),
        RideFormMapField(
          controller: locationEndController,
          mapController: mapController,
          label: RideFormConstants.END_LOCATION_LABEL,
          isStartLocation: false,
          onLocationSelected: (LatLng point) => _updateLocation(point, locationEndController, context),
        ),
      ],
    );
  }

  void _updateLocation(LatLng point, TextEditingController controller, BuildContext context) {
    locationService.reverseGeocode(point).then((address) {
      controller.text = address;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location updated to $address.')),
      );
    }).catchError((_) {
      controller.text = '${point.latitude}, ${point.longitude}';
    });
  }
}
