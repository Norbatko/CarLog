import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_log/model/user.dart';

const _USER_COLLECTION = 'users';
const _FAVORITE_CARS = 'favoriteCars';
const _IS_ADMIN = 'isAdmin';

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

  Stream<void> createUserProfile(User user) async* {
    try {
      await _userRef.doc(user.id).set(user.toMap());
      yield null;
    } catch (e) {
      throw Exception('Error creating user profile: $e');
    }
  }

  Stream<void> updateUserProfile(String uid, Map<String, dynamic> updates) async* {
    try {
      await _userRef.doc(uid).update(updates);
      yield null;
    } catch (e) {
      throw Exception('Error updating user profile: $e');
    }
  }

  Stream<void> deleteUserProfile(String uid) async* {
    try {
      await _userRef.doc(uid).delete();
      yield null;
    } catch (e) {
      throw Exception('Error deleting user profile: $e');
    }
  }

  Stream<List<String>> userFavoritesStream(String uid) {
    return _userRef.doc(uid).snapshots().map((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data[_FAVORITE_CARS] is List) {
        return List<String>.from(data[_FAVORITE_CARS]);
      }
      return <String>[];
    }).handleError((error) {
      throw Exception('Error streaming user favorites: $error');
    });
  }

  Stream<bool> isAdminStream(String uid) {
    return _userRef.doc(uid).snapshots().map((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey(_IS_ADMIN)) {
        return data[_IS_ADMIN] as bool;
      }
      return false;
    }).handleError((error) {
      throw Exception('Error streaming admin status: $error');
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
