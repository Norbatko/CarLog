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
  User? get currentUser => _currentUser;

  final StreamController<User> _userStreamController =
  StreamController<User>.broadcast();
  Stream<User> get userStream => _userStreamController.stream;

  Future<User?> getUserData(String userId) async {
    return await _databaseService.getUserById(userId);
  }

  Future<User?> getLoggedInUserData(userId) async {
    _currentUser = await _databaseService.getUserById(userId);
    _userStreamController.add(_currentUser!);
    notifyListeners();
    return _currentUser;
  }

  bool isFavoriteCar(String carId) {
    return _currentUser?.favoriteCars.contains(carId) ?? false;
  }

  Future<void> toggleFavoriteCar(String carId) async {
    if (_currentUser == null) return;
    isFavoriteCar(carId)
      ?_currentUser!.favoriteCars.remove(carId)
      :_currentUser!.favoriteCars.add(carId);

    await updateUserFavorites(_currentUser!.id, _currentUser!.favoriteCars);
    _userStreamController.add(_currentUser!);
    notifyListeners();
  }

  Future<void> updateUserFavorites(
      String userId, List<String> favoriteCars) async {
    await _databaseService.updateUserFavorites(userId, favoriteCars);
  }

  Stream<List<User>> get users => userModel.getUsers();

  @override
  void dispose() {
    _userStreamController.close();
    super.dispose();
  }
}
