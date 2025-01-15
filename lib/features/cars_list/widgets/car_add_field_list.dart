import 'package:car_log/base/controllers/field_controller.dart';
import 'package:car_log/features/cars_list/widgets/car_add_field.dart';
import 'package:car_log/features/cars_list/widgets/fuel_type_dropdown.dart';
import 'package:flutter/material.dart';

class CarAddFieldList extends StatelessWidget {
  final Map<String, FieldController> textControllers;
  final Map<String, FieldController> numericControllers;
  final Map<String, String?> errorMessages;
  final List<String> fuelTypes;
  final String selectedFuelType;
  final List<IconData> carIcons;
  final int selectedCarIcon;
  final ValueChanged<String?> onFuelTypeChanged;
  final ValueChanged<int?> onCarIconChanged;

  const CarAddFieldList({
    super.key,
    required this.errorMessages,
    required this.fuelTypes,
    required this.selectedFuelType,
    required this.carIcons,
    required this.selectedCarIcon,
    required this.onFuelTypeChanged,
    required this.onCarIconChanged,
    required this.textControllers,
    required this.numericControllers,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...textControllers.entries.map((entry) {
            return CarAddField(
              controller: entry.value.controller,
              errorMessage: errorMessages[entry.key],
              nameOfField: entry.key,
              isRequired: entry.value.isRequired,
            );
          }).toList(),
          ...numericControllers.entries.map((entry) {
            return CarAddField(
              controller: entry.value.controller,
              errorMessage: errorMessages[entry.key],
              nameOfField: entry.key,
              isRequired: entry.value.isRequired,
              isNumeric: true,
            );
          }).toList(),
          FuelTypeDropdown(
            selectedFuelType: selectedFuelType,
            fuelTypes: fuelTypes,
            onChanged: onFuelTypeChanged,
          ),
          InputDecorator(
            decoration: const InputDecoration(labelText: 'Car Icon'),
            child: Row(
              children: List.generate(carIcons.length, (index) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio(
                      value: index,
                      groupValue: selectedCarIcon,
                      onChanged: onCarIconChanged,
                    ),
                    Icon(carIcons[index]),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
