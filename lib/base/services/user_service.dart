import 'dart:async';
import 'package:car_log/base/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:car_log/services/database_service.dart';

class UserService with ChangeNotifier {
  final DatabaseService _databaseService;
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  UserService({required DatabaseService databaseService})
      : _databaseService = databaseService;

  User? _currentUser;

  Stream<void> addUser(User user) async* {
    await usersCollection.doc(user.id).set(user.toMap());
    yield null;
  }

  Stream<User?> getUserData(String userId) {
    return _databaseService.getUserById(userId);
  }

  Stream<User?> getLoggedInUserData(String userId) async* {
    yield* _databaseService.getUserById(userId).map((user) {
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
