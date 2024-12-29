import 'dart:async';

import 'package:car_log/model/user.dart';
import 'package:car_log/model/user_model.dart';
import 'package:car_log/services/database_service.dart';
import 'package:flutter/foundation.dart';

class UserService with ChangeNotifier {
  final DatabaseService _databaseService;
  final UserModel userModel;

  UserService({
    required this.userModel,
    required DatabaseService databaseService,
  }) : _databaseService = databaseService;

  User? _currentUser;

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

  Stream<void> toggleFavoriteCar(String carId) {
    if (isFavoriteCar(carId)) {
      _currentUser!.favoriteCars.remove(carId);
    } else {
      _currentUser!.favoriteCars.add(carId);
    }
    _databaseService
        .updateUserFavorites(_currentUser!.id, _currentUser!.favoriteCars)
        .listen((_) {
      notifyListeners();
    });
    return Stream.empty();
  }

  Stream<void> updateUserFavorites(String userId, List<String> favoriteCars) {
    return _databaseService.updateUserFavorites(userId, favoriteCars);
  }

  Stream<List<User>> get users => userModel.getUsers();

  User? get currentUser => _currentUser;
}
