/// This class is responsible for all CRUD operations related to the Car model.
/// It is a Singleton class that uses Firebase Realtime Database to store the data.
/// @Author: Gabriel Biel xbielg00
/// @modified: Adam Gabrys xgabry01 -- added updateUserFavorites() and getUserById()

import 'package:firebase_database/firebase_database.dart';
import 'user.dart';

class UserModel {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  UserModel();

  Future<void> addUser(User user) async {
    DatabaseReference userRef = databaseReference.child('users').push();
    await userRef.set(user.toMap());
  }

  Future<void> deleteUser(String userId) async {
    await databaseReference.child('users').child(userId).remove();
  }

  // Update the favorite cars for a user in the database
  Future<void> updateUserFavorites(String userId, List<String> favoriteCars) async {
    await databaseReference.child('users').child(userId).update({'favoriteCars': favoriteCars});
  }

  Stream<List<User>> getUsers() {
    return databaseReference.child('users').onValue.map((event) {
      var snapshot = event.snapshot;
      var data = snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        List<User> userList = [];
        data.forEach((key, value) {
          if (value is Map<Object?, Object?>) {
              userList.add(User.fromMap(key, value.cast<String, dynamic>()));
          }
        });
        return userList;
      }
      return [];
    });
  }

  Future<User?> getUserById(String userId) async {
    DataSnapshot snapshot = await databaseReference.child('users').child(userId).get();
    if (snapshot.exists && snapshot.value is Map) {
      Map<String, dynamic> userMap = Map<String, dynamic>.from(snapshot.value as Map);
      return User.fromMap(userId, userMap);
    }
    return null;
  }
}
