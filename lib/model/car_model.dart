import 'package:cloud_firestore/cloud_firestore.dart';
import 'car.dart';

class CarModel {
  final CollectionReference carsCollection =
  FirebaseFirestore.instance.collection('cars');

  CarModel();

  Stream<void> addCar(Car car) async* {
    await carsCollection.add(car.toMap());
    yield null;
  }

  Stream<void> updateCar(String carId, Car updatedCar) async* {
    await carsCollection.doc(carId).update(updatedCar.toMap());
    yield null;
  }

  Stream<void> deleteCar(String carId) async* {
    await carsCollection.doc(carId).delete();
    yield null;
  }

  Stream<List<Car>> getCars() {
    return carsCollection.snapshots().map((querySnapshot) {
      List<Car> carsList = [];
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final detail = data['detail'] as Map<String, dynamic>?;
        if (detail != null) {
          carsList.add(Car.fromMap(doc.id, detail));
        }
      }
      return carsList;
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

  Stream<Car?> getCarById(String carId) async* {
    final docSnapshot = await carsCollection.doc(carId).get();
    if (docSnapshot.exists) {
      yield Car.fromMap(carId, docSnapshot.data() as Map<String, dynamic>);
    } else {
      yield null;
    }
  }
}
