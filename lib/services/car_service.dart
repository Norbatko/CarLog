import 'dart:async';
import 'package:car_log/model/car.dart';
import 'package:car_log/model/car_model.dart';

class CarService {
  final CarModel carModel = CarModel();
  Car activeCar = Car();
  Function? onOdometerChange;

  final StreamController<Car> _carStreamController =
      StreamController<Car>.broadcast();
  Stream<Car> get carStream => _carStreamController.stream;

  CarService();

  void updateOdometer(int newOdometer) {
    activeCar.odometerStatus = newOdometer.toString();
    _carStreamController.add(activeCar);
    carModel.saveCar(activeCar);
    onOdometerChange?.call();
  }

  Stream<List<Car>> get cars => carModel.getCars();

  Future<void> addCar(
      String name,
      String fuelType,
      String licensePlate,
      String insuranceContact,
      String odometerStatus,
      String responsiblePerson,
      int selectedCarIcon) async {
    Car newCar = Car(
        name: name,
        fuelType: fuelType,
        licensePlate: licensePlate,
        insuranceContact: insuranceContact,
        odometerStatus: odometerStatus,
        description: responsiblePerson,
        icon: selectedCarIcon);
    await carModel.addCar(newCar);
  }

  void setActiveCar(Car car) {
    activeCar = car;
  }

  Car getActiveCar() {
    return activeCar;
  }

  void dispose() {
    _carStreamController.close();
  }
}
