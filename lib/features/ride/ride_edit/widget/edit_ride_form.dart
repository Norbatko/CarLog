import 'dart:async';
import 'package:car_log/features/ride/model/ride.dart';
import 'package:car_log/features/ride/ride_edit/utils/ride_form_constants.dart';
import 'package:car_log/features/ride/ride_edit/widget/dialog_helper.dart';
import 'package:car_log/features/ride/ride_edit/widget/ride_form/ride_form_field_list.dart';
import 'package:car_log/base/widgets/buttons/save_or_delete_button.dart';
import 'package:car_log/base/services/car_service.dart';
import 'package:car_log/features/ride/services/location_service.dart';
import 'package:car_log/features/ride/services/ride_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;

class EditRideForm extends StatefulWidget {
  final Ride ride;

  const EditRideForm({Key? key, required this.ride}) : super(key: key);

  @override
  _EditRideFormState createState() => _EditRideFormState();
}

class _EditRideFormState extends State<EditRideForm> {
  late TextEditingController _rideTypeController;
  late TextEditingController _distanceController;
  late TextEditingController _userNameController;
  late TextEditingController _locationStartController;
  late TextEditingController _locationEndController;
  DateTime? _selectedStartDateTime;
  DateTime? _selectedFinishDateTime;

  final RideService rideService = get<RideService>();
  final LocationService locationService = get<LocationService>();
  late flutterMap.MapController _mapController;
  late StreamSubscription<String> _locationSubscription;
  bool _isUpdatingStartLocation = true;

  @override
  void initState() {
    super.initState();
    _rideTypeController = TextEditingController(text: widget.ride.rideType);
    _distanceController =
        TextEditingController(text: widget.ride.distance.toString());
    _userNameController = TextEditingController(text: widget.ride.userName);
    _locationStartController =
        TextEditingController(text: widget.ride.locationStart);
    _locationEndController =
        TextEditingController(text: widget.ride.locationEnd);
    _selectedStartDateTime = widget.ride.startedAt;
    _selectedFinishDateTime = widget.ride.finishedAt;
    _mapController = flutterMap.MapController();
    _locationSubscription =
        locationService.locationStream.listen((location) {});
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    _rideTypeController.dispose();
    _distanceController.dispose();
    _userNameController.dispose();
    _locationStartController.dispose();
    _locationEndController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          RideFormFieldList(
            locationStartController: _locationStartController,
            locationEndController: _locationEndController,
            distanceController: _distanceController,
            mapController: _mapController,
            rideTypeController: _rideTypeController,
            selectedStartDateTime: _selectedStartDateTime,
            selectedFinishDateTime: _selectedFinishDateTime,
            onDatesChanged: (DateTime? start, DateTime? finish) {
              setState(() {
                _selectedStartDateTime = start;
                _selectedFinishDateTime = finish;
              });
            },
          ),
          const SizedBox(height: RideFormConstants.SECTION_VERTICAL_MARGIN),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SaveOrDeleteButton(
                onPressed: _saveOrUpdateRide,
                isDeleteButton: false,
                saveText: 'Save Ride',
              ),
              const SizedBox(width: RideFormConstants.FIELD_SPACING),
              SaveOrDeleteButton(
                onPressed: _deleteRide,
                isDeleteButton: true,
              ),
            ],
          ),
          const SizedBox(height: RideFormConstants.SECTION_VERTICAL_MARGIN),
        ],
      ),
    );
  }

  void _deleteRide() {
    final carService = get<CarService>();
    final rideDistance = widget.ride.distance;

    rideService.deleteRide(carService.activeCar.id, widget.ride.id).listen((_) {
      if (mounted) {
        final newOdometerValue =
            int.parse(carService.activeCar.odometerStatus) - rideDistance;
        carService.updateOdometer(newOdometerValue < 0 ? 0 : newOdometerValue);

        DialogHelper.showSnackBar(
            context, RideFormConstants.RIDE_DELETED_MESSAGE);
        Navigator.pop(context);
      }
    }).onError((_) {
      if (mounted) {
        DialogHelper.showSnackBar(context, 'Failed to delete ride.');
      }
    });
  }

  void _saveOrUpdateRide() {
    if (_distanceController.text.isEmpty) return;

    final updatedRide = widget.ride.copyWith(
      startedAt: _selectedStartDateTime,
      finishedAt: _selectedFinishDateTime,
      rideType: _rideTypeController.text,
      distance: int.parse(_distanceController.text),
      locationStart: _locationStartController.text,
      locationEnd: _locationEndController.text,
    );

    rideService
        .saveRide(updatedRide, get<CarService>().activeCar.id)
        .listen((_) {
      if (mounted) {
        // Explicitly update odometer after ride save
        final newOdometerValue =
            int.parse(get<CarService>().activeCar.odometerStatus) +
                updatedRide.distance;
        get<CarService>().updateOdometer(newOdometerValue);

        DialogHelper.showSnackBar(
            context, RideFormConstants.RIDE_SAVED_MESSAGE);
        Navigator.pop(context);
      }
    }).onError((_) {
      if (mounted) {
        DialogHelper.showSnackBar(context, 'Failed to save ride.');
      }
    });
  }

  void _requestLocation(bool isStartLocation) {
    _isUpdatingStartLocation = isStartLocation;
    _locationSubscription = locationService.locationStream.listen((location) {
      if (mounted) {
        setState(() => _isUpdatingStartLocation
            ? _locationStartController.text = location
            : _locationEndController.text = location);
        DialogHelper.showSnackBar(
            context, RideFormConstants.LOCATION_UPDATED_MESSAGE);
      }
    });
    locationService.requestLocation();
  }
}
