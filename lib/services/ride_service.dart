import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_log/model/ride.dart';

class RideService {
  final CollectionReference carsCollection =
  FirebaseFirestore.instance.collection('cars');

  RideService();

  Stream<String> saveRide(Ride ride, String carId) async* {
    final ridesRef = carsCollection.doc(carId).collection('rides');
    final carRef = carsCollection.doc(carId);
    FirebaseFirestore firestore = FirebaseFirestore.instance; //for transaction

    try {
      await firestore.runTransaction((transaction) async {
        DocumentSnapshot carSnapshot = await transaction.get(carRef);

        if (!carSnapshot.exists) { throw Exception("Car not found");}

        Map<String, dynamic> carData = carSnapshot['detail'];
        String currentOdometerStatus = carData['odometer_status'] ?? '0';
        int currentOdometer = int.tryParse(currentOdometerStatus) ?? 0;
        int updatedOdometer = currentOdometer + ride.distance;

        if (ride.id.isEmpty) {
          DocumentReference newRideRef = ridesRef.doc();
          ride.id = newRideRef.id;
          transaction.set(newRideRef, ride.toMap());
        } else {
          transaction.set(ridesRef.doc(ride.id), ride.toMap());
        }

        transaction.update(carRef, {
          'detail.odometer_status': updatedOdometer.toString(),
        });
      });
      yield 'success';
    } catch (e) {
      yield 'error: ${e.toString()}';
    }
  }

  Stream<List<Ride>> getRides(String carId) {
    return carsCollection
        .doc(carId)
        .collection('rides')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Ride.fromMap(doc.id, doc.data());
      }).toList()
        ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
    });
  }

  Stream<String> deleteRide(String carId, String rideId) async* {
    try {
      await carsCollection
          .doc(carId)
          .collection('rides')
          .doc(rideId)
          .delete();
      yield 'success';
    } catch (e) {
      yield 'error: ${e.toString()}';
    }
  }

  Stream<Ride?> getRideById(String carId, String rideId) async* {
    final docSnapshot = await carsCollection
        .doc(carId)
        .collection('rides')
        .doc(rideId)
        .get();

    if (docSnapshot.exists) {
      yield Ride.fromMap(rideId, docSnapshot.data() as Map<String, dynamic>);
    } else {
      yield null;
    }
  }
}
