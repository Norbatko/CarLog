import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_log/base/models/user.dart';

const _USER_COLLECTION = 'users';
const _FAVORITE_CARS = 'favoriteCars';

class DatabaseService {
  final CollectionReference _userRef = FirebaseFirestore.instance.collection(_USER_COLLECTION);

  Stream<User?> getUserById(String uid) {
    return _userRef.doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        final userData = snapshot.data() as Map<String, dynamic>;
        return User.fromMap(uid, userData);
      }
      return null;
    });
  }

  Stream<void> updateUserFavorites(String uid, List<String> favoriteCars) async* {
    try {
      await _userRef.doc(uid).update({_FAVORITE_CARS: favoriteCars});
      yield null; // Emit an event to indicate completion
    } catch (e) {
      throw Exception('Error updating favorite cars: $e');
    }
  }
}
