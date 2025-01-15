import 'dart:async';
import 'package:car_log/base/models/car.dart';
import 'package:car_log/base/models/car_model.dart';

class CarService {
  final CarModel carModel = CarModel();
  Car activeCar = Car();
  final StreamController<Car> _carStreamController = StreamController<Car>.broadcast();
  Stream<Car> get carStream => _carStreamController.stream;
  CarService();

  Stream<List<Car>> get cars => carModel.getCars();

  Stream<void> addCar(
      String name,
      String fuelType,
      String licensePlate,
      String insuranceContact,
      String odometerStatus,
      String responsiblePerson,
      int selectedCarIcon) async* {
    Car newCar = Car(
        name: name,
        fuelType: fuelType,
        licensePlate: licensePlate,
        insuranceContact: insuranceContact,
        odometerStatus: odometerStatus,
        description: responsiblePerson,
        icon: selectedCarIcon);
    yield* carModel.addCar(newCar);
  }

  void updateOdometer(int newOdometer) {
    activeCar.odometerStatus = newOdometer.toString();
    _carStreamController.add(activeCar);
    carModel.saveCar(activeCar).listen((_) {
      _carStreamController.add(activeCar);
    });
  }

  Stream<void> updateCar(
      String id,
      String name,
      String fuelType,
      String licensePlate,
      String insurance,
      String insuranceContact,
      String odometerStatus,
      String responsiblePerson,
      String description,
      int selectedCarIcon) async* {
    Car updatedCar = Car(
        name: name,
        fuelType: fuelType,
        licensePlate: licensePlate,
        insurance: insurance,
        insuranceContact: insuranceContact,
        odometerStatus: odometerStatus,
        responsiblePerson: responsiblePerson,
        description: description,
        icon: selectedCarIcon);
    yield* carModel.updateCar(id, updatedCar);
  }

  Stream<void> deleteCar(String carId) async* {
    yield* carModel.deleteCar(carId);
  }

  void setActiveCar(Car car) {
    activeCar = car;
  }

  Car getActiveCar() {
    if (activeCar.odometerStatus == '0' || activeCar.name.isEmpty) {
      carModel.getCars().listen((carList) {
        if (carList.isNotEmpty) {
          setActiveCar(carList.first);
          _carStreamController.add(activeCar);
        }
      });
    }
    return activeCar;
  }
}
