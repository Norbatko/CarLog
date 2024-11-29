import 'dart:async';
import 'package:car_log/model/car.dart';
import 'package:car_log/model/car_model.dart';

class CarService {
  final CarModel carModel = CarModel();
  Car activeCar = Car();
  Function? onOdometerChange; // Optional callback

  // StreamController for broadcasting Car updates
  final StreamController<Car> _carStreamController =
      StreamController<Car>.broadcast();
  Stream<Car> get carStream => _carStreamController.stream;

  CarService();

  // Method to update odometer and save the car
  void updateOdometer(int newOdometer) {
    activeCar.odometerStatus = newOdometer.toString();
    _carStreamController.add(activeCar); // Emit updated Car through stream
    carModel.saveCar(activeCar); // Save updated car in CarModel
    onOdometerChange?.call(); // Invoke callback if set
  }

  // Method to retrieve a list of cars
  Stream<List<Car>> get cars => carModel.getCars();

  Future<void> addCar(
      String name,
      String alias,
      String fuelType,
      String licensePlate,
      String insuranceContact,
      String odometerStatus,
      String description,
      int selectedCarIcon) async {
    Car newCar = Car(
        name: name,
        alias: alias,
        fuelType: fuelType,
        licensePlate: licensePlate,
        insuranceContact: insuranceContact,
        odometerStatus: odometerStatus,
        description: description,
        icon: selectedCarIcon);
    await carModel.addCar(newCar);
  }

  void setActiveCar(Car car) {
    activeCar = car;
  }

  // Dispose method to close the StreamController when done
  void dispose() {
    _carStreamController.close();
  }
}
