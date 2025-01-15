import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_log/features/ride/model/ride.dart';

class RideService {
  final CollectionReference carsCollection =
  FirebaseFirestore.instance.collection('cars');

  RideService();

  Stream<String> saveRide(Ride ride, String carId) async* {
    final ridesRef = carsCollection.doc(carId).collection('rides');
    final carRef = carsCollection.doc(carId);

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore.runTransaction((transaction) async {
        DocumentSnapshot carSnapshot = await transaction.get(carRef);

        if (!carSnapshot.exists) throw Exception("Car not found");

        if (ride.id.isEmpty) {
          DocumentReference newRideRef = ridesRef.doc();
          ride.id = newRideRef.id;
          transaction.set(newRideRef, ride.toMap());
        }
        else {
          transaction.set(ridesRef.doc(ride.id), ride.toMap());
        }
        _updateOdometer(transaction, carSnapshot, ride.distance);
      });
      yield 'success';
    }
    catch (e) {
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
      }
      ).toList()
        ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
    });
  }

  Stream<String> deleteRide(String carId, String rideId) async* {
    final ridesRef = carsCollection.doc(carId).collection('rides');
    final carRef = carsCollection.doc(carId);

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore.runTransaction((transaction) async {
        DocumentSnapshot rideSnapshot = await transaction.get(ridesRef.doc(rideId));

        if (!rideSnapshot.exists) {
          throw Exception("Ride not found");
        }

        Ride ride = Ride.fromMap(rideSnapshot.id, rideSnapshot.data() as Map<String, dynamic>);

        DocumentSnapshot carSnapshot = await transaction.get(carRef);
        if (!carSnapshot.exists) throw Exception("Car not found");

        _updateOdometer(transaction, carSnapshot, -ride.distance);
        transaction.delete(ridesRef.doc(rideId));
      });
      yield 'success';
    }
    catch (e) {
      yield 'error: ${e.toString()}';
    }
  }


  void _updateOdometer(Transaction transaction, DocumentSnapshot carSnapshot, int distanceChange) {
    Map<String, dynamic> carData = carSnapshot['detail'];
    String currentOdometerStatus = carData['odometer_status'] ?? '0';
    int currentOdometer = int.tryParse(currentOdometerStatus) ?? 0;

    int updatedOdometer = currentOdometer + distanceChange;
    if (updatedOdometer < 0) updatedOdometer = 0;

    transaction.update(carSnapshot.reference, {
      'detail.odometer_status': updatedOdometer.toString(),
    });
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
