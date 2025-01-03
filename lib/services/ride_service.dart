import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_log/model/ride.dart';

class RideService {
  final CollectionReference carsCollection =
  FirebaseFirestore.instance.collection('cars');

  RideService();

  Stream<String> saveRide(Ride ride, String carId) async* {
    final ridesRef = carsCollection.doc(carId).collection('rides');

    try {
      if (ride.id.isEmpty) {
        DocumentReference newRideRef = await ridesRef.add(ride.toMap());
        ride.id = newRideRef.id;
      } else {
        await ridesRef.doc(ride.id).set(ride.toMap());
      }
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
