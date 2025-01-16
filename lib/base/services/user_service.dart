import 'dart:async';
import 'package:car_log/base/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserService with ChangeNotifier {
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  User? _currentUser;

  Stream<void> addUser(User user) async* {
    await usersCollection.doc(user.id).set(user.toMap());
    yield null;
  }

  Stream<User?> getUserData(String userId) {
    return usersCollection.doc(userId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        final userData = snapshot.data() as Map<String, dynamic>;
        return User.fromMap(userId, userData);
      }
      return null;
    });
  }

  Stream<User?> getLoggedInUserData(String userId) async* {
    yield* getUserData(userId).map((user) {
      _currentUser = user;
      notifyListeners();
      return user;
    });
  }

  bool isFavoriteCar(String carId) {
    return _currentUser?.favoriteCars.contains(carId) ?? false;
  }

  Stream<void> toggleFavoriteCar(String carId) async* {
    if (_currentUser == null) return;

    if (isFavoriteCar(carId)) {
      _currentUser!.favoriteCars.remove(carId);
    } else {
      _currentUser!.favoriteCars.add(carId);
    }

    yield* updateUserFavorites(_currentUser!.id, _currentUser!.favoriteCars);
    notifyListeners();
  }

  Stream<void> updateUserFavorites(String userId, List<String> favoriteCars) async* {
    await usersCollection.doc(userId).update({'favoriteCars': favoriteCars});
    yield null;
  }

  Stream<List<User>> get users {
    return usersCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return User.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  User? get currentUser => _currentUser;
}
