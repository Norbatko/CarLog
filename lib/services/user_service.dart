import 'package:car_log/model/user.dart';
import 'package:car_log/services/database_service.dart';

class UserService {
  final DatabaseService _databaseService;

  UserService({required DatabaseService databaseService})
      : _databaseService = databaseService;

  Future<User?> getUserData(String userId) async {
    return await _databaseService.getUserById(userId);
  }

  bool isFavoriteCar(User user, String carId) {
    return user.favoriteCars.contains(carId);
  }

  void addFavoriteCar(User user, String carId) {
    if (!user.favoriteCars.contains(carId)) {
      user.favoriteCars.add(carId);
    }
  }

  void removeFavoriteCar(User user, String carId) {
    user.favoriteCars.remove(carId);
  }

  Future<void> updateUserFavorites(String userId, List<String> favoriteCars) async {
    await _databaseService.updateUserFavorites(userId, favoriteCars);
  }

  Future<void> toggleFavoriteCar(User currentUser, String carId) async {
    if (isFavoriteCar(currentUser, carId)) {
      removeFavoriteCar(currentUser, carId);
    } else {
      addFavoriteCar(currentUser, carId);
    }
    await updateUserFavorites(currentUser.id, currentUser.favoriteCars);
  }
}
