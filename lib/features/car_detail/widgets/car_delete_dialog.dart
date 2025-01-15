import 'package:car_log/base/widgets/buttons/save_or_delete_button.dart';
import 'package:car_log/routes.dart';
import 'package:car_log/base/services/car_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

const _ANIMATION_WIDTH = 250.0;
const _ANIMATION_HEIGHT = 250.0;

class CarDeleteDialog extends StatefulWidget {
  const CarDeleteDialog({super.key});

  @override
  State<CarDeleteDialog> createState() => _CarDeleteDialogState();
}

class _CarDeleteDialogState extends State<CarDeleteDialog>
    with TickerProviderStateMixin {
  final CarService carService = get<CarService>();
  bool _isDeleting = false;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SaveOrDeleteButton(
      isDeleteButton: true,
      onPressed: () => _showDeleteCarDialog(context)
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
    return Text(
      _isDeleting
          ? 'Car deleted'
          : 'Do you want to delete ${carService.activeCar.name}?',
    );
  }

  Widget _buildDialogContent(void Function(void Function()) setState) {
    return SizedBox(
      width: 100,
      height: 200,
      child: Center(
        child: Lottie.network(
          "https://lottie.host/447b2753-b3ef-4163-a13c-f4adb5490135/2mxMx67iBP.json",
          controller: _controller,
          width: _ANIMATION_WIDTH,
          height: _ANIMATION_HEIGHT,
          onLoaded: (composition) {
            _controller.duration = composition.duration;
            _controller.animateTo(
              1 / _controller.duration!.inSeconds,
              duration: const Duration(seconds: 1),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildDialogActions(
    BuildContext context,
    void Function(void Function()) setState,
  ) {
    if (_isDeleting) {
      return [];
    }
    return [
      TextButton(
        onPressed: () {
          setState(() {
            _controller.reset();
          });
          Navigator.of(context).pop();
        },
        child: const Text(
          'Cancel',
          style: TextStyle(color: Colors.black),
        ),
      ),
      ElevatedButton(
        onPressed: () {
          setState(() {
            _isDeleting = true;
            _controller.duration = const Duration(seconds: 2);
            _controller.forward();
            carService.deleteCar(carService.activeCar.id).listen((_) {});
            Future.delayed(const Duration(milliseconds: 1600), () {
              Navigator.of(context).popUntil(
                (route) => route.settings.name == Routes.carNavigation,
              );
            });
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          textStyle: const TextStyle(color: Colors.black),
        ),
        child: const Text(
          'Delete',
          style: TextStyle(color: Colors.black),
        ),
      ),
    ];
  }
}
