import 'dart:async';
import 'package:car_log/base/models/car.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarService {
  final CollectionReference carsCollection = FirebaseFirestore.instance.collection('cars');
  Car activeCar = Car();
  Function? onOdometerChange;
  final StreamController<Car> _carStreamController = StreamController<Car>.broadcast();
  Stream<Car> get carStream => _carStreamController.stream;

  CarService();

  Stream<List<Car>> get cars => _getCars();

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
      icon: selectedCarIcon,
    );
    await carsCollection.add(newCar.toMap());
    yield null;
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
      id: id,
      name: name,
      fuelType: fuelType,
      licensePlate: licensePlate,
      insurance: insurance,
      insuranceContact: insuranceContact,
      odometerStatus: odometerStatus,
      responsiblePerson: responsiblePerson,
      description: description,
      icon: selectedCarIcon,
    );
    await carsCollection.doc(id).update(updatedCar.toMap());
    yield null;
  }

  Stream<void> deleteCar(String carId) async* {
    await carsCollection.doc(carId).delete();
    yield null;
  }

  Stream<List<Car>> _getCars() {
    return carsCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final detail = data['detail'] as Map<String, dynamic>?;
        if (detail != null) {
          return Car.fromMap(doc.id, detail);
        }
        return Car();
      }).toList();
    });
  }

  Stream<void> saveCar(Car car) async* {
    if (car.id.isEmpty) {
      await carsCollection.add(car.toMap());
    } else {
      await carsCollection.doc(car.id).set(car.toMap());
    }
    yield null;
  }

  void updateOdometer(int newOdometer) {
    activeCar.odometerStatus = newOdometer.toString();
    _carStreamController.add(activeCar);
    saveCar(activeCar).listen((_) {});
    onOdometerChange?.call();
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
