import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_log/model/user.dart';

class DatabaseService {
  final CollectionReference _userRef = FirebaseFirestore.instance.collection('users');

  Stream<User?> getUserStreamById(String uid) {
    return _userRef.doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        final userData = snapshot.data() as Map<String, dynamic>;
        return User.fromMap(uid, userData);
      }
      return null;
    });
  }

  Stream<List<User>> getAllUsersStream() {
    return _userRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final userData = doc.data() as Map<String, dynamic>;
        return User.fromMap(doc.id, userData);
      }).toList();
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

  Future<User?> getUserById(String uid) async {
    final snapshot = await _userRef.doc(uid).get();
    if (snapshot.exists) {
      final userData = snapshot.data() as Map<String, dynamic>;
      return User.fromMap(uid, userData);
    }
    return null;
  }

  Stream<List<String>> userFavoritesStream(String uid) {
    return _userRef.doc(uid).snapshots().map((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data['favoriteCars'] is List) {
        return List<String>.from(data['favoriteCars']);
      }
      return <String>[];
    }).handleError((error) {
      throw Exception('Error streaming user favorites: $error');
    });
  }

  Stream<bool> isAdminStream(String uid) {
    return _userRef.doc(uid).snapshots().map((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('isAdmin')) {
        return data['isAdmin'] as bool;
      }
      return false; // Default to non-admin if field is not found
    }).handleError((error) {
      throw Exception('Error streaming admin status: $error');
    });
  }

  Stream<void> updateUserFavorites(String uid, List<String> favoriteCars) async* {
    try {
      await _userRef.doc(uid).update({'favoriteCars': favoriteCars});
      yield null; // Emit an event to indicate completion
    } catch (e) {
      throw Exception('Error updating favorite cars: $e');
    }
  }
}
