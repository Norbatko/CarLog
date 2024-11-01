import 'package:firebase_database/firebase_database.dart';
import 'package:car_log/model/user.dart';

class DatabaseService {
  final DatabaseReference _userRef = FirebaseDatabase.instance.ref('users');

  Future<User?> getUserById(String uid) async {
    try {
      // Access the user node directly by uid
      final snapshot = await _userRef.child(uid).get();
      if (snapshot.exists) {
        // Cast the data to Map and use uid as the local id
        final userData = Map<String, dynamic>.from(snapshot.value as Map);
        return User.fromMap(uid, userData);
      } else {
        print("No user data found for UID: $uid");
        return null;
      }
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }

  Future<void> createUserProfile(User user) async {
    try {
      await _userRef.child(user.id).set(user.toMap());
    } catch (e) {
      throw Exception('Error creating user profile: $e');
    }
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> updates) async {
    if (updates.isEmpty) return; // No updates to apply
    try {
      await _userRef.child(uid).update(updates);
    } catch (e) {
      throw Exception('Error updating user profile: $e');
    }
  }

  Future<void> updateUserFavorites(String uid, List<String> favoriteCars) async {
    try {
      await _userRef.child(uid).update({'favoriteCars': favoriteCars});
    } catch (e) {
      throw Exception('Error updating favorite cars: $e');
    }
  }

  Future<bool> isAdmin(String uid) async {
    try {
      final snapshot = await _userRef.child(uid).child('isAdmin').get();
      if (snapshot.exists) {
        return snapshot.value as bool;
      } else {
        print("Admin status not found for UID: $uid");
        return false;
      }
    } catch (e) {
      throw Exception('Error checking admin status: $e');
    }
  }

  Future<void> deleteUserProfile(String uid) async {
    try {
      await _userRef.child(uid).remove();
      print("User profile deleted for UID: $uid");
    } catch (e) {
      throw Exception('Error deleting user profile: $e');
    }
  }
}
