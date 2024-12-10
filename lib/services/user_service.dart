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

  final StreamController<User?> _userStreamController =
      StreamController<User?>.broadcast();
  Stream<User?> get userStream => _userStreamController.stream;

  Stream<User?> getUserData(String userId) {
    return _databaseService.getUserById(userId);
  }

  Stream<User?> getLoggedInUserData(String userId) async* {
    yield* _databaseService.getUserById(userId).map((user) {
      _currentUser = user;
      _userStreamController.add(user);
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
      _userStreamController.add(_currentUser);
      notifyListeners();
    });
    return Stream.empty();
  }

  Stream<void> updateUserFavorites(String userId, List<String> favoriteCars) {
    return _databaseService.updateUserFavorites(userId, favoriteCars);
  }

  Stream<List<User>> get users => userModel.getUsers();

  @override
  void dispose() {
    _userStreamController.close();
    super.dispose();
  }
}
