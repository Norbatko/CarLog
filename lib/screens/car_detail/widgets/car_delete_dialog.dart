import 'package:car_log/services/Routes.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';

class CarDeleteDialog extends StatefulWidget {
  const CarDeleteDialog({super.key});

  @override
  State<CarDeleteDialog> createState() => _CarDeleteDialogState();
}

class _CarDeleteDialogState extends State<CarDeleteDialog> {
  final CarService carService = get<CarService>();
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigator.of(context).pop();
        // carService.deleteCar(carService.activeCar.id).listen((_) {});
        _showDeleteCarDialog(context);
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          textStyle: TextStyle(color: Colors.black)),
      child: Text("Delete Car"),
    );
  }

  void _showDeleteCarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: _buildDialogTitle(),
              content: _buildDialogContent(setState),
              actions: _buildDialogActions(context, setState),
            );
          },
        );
      },
    );
  }

  Widget _buildDialogTitle() {
    return _isDeleting
        ? Text('Car deleted')
        : Text('Do you want to delete ${carService.activeCar.name}?');
  }

  Widget _buildDialogContent(void Function(void Function()) setState) {
    return Container(
      width: 100,
      height: 100,
      color: Colors.orangeAccent,
    );
  }

  List<Widget> _buildDialogActions(
      BuildContext context, void Function(void Function()) setState) {
    if (_isDeleting) {
      return [];
    } else {
      return [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isDeleting = true;
              carService.deleteCar(carService.activeCar.id).listen((_) {});
              Future.delayed(const Duration(seconds: 2), () {
                _isDeleting = false;
                Navigator.of(context).popUntil(
                    (route) => route.settings.name == Routes.carNavigation);
              });
            });
          },
          child: Text('Delete'),
        ),
      ];
    }
  }
}
