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

  Future<List<String>> toggleFavoriteCar(User currentUser, String carId) async {
    // Toggle favorite status
    if (isFavoriteCar(currentUser, carId)) {
      _removeFavoriteCar(currentUser, carId);
    } else {
      _addFavoriteCar(currentUser, carId);
    }

    // Update favorites in the database
    await updateUserFavorites(currentUser.id, currentUser.favoriteCars);

    // Return the updated favorites list
    return currentUser.favoriteCars;
  }

  Future<void> updateUserFavorites(String userId, List<String> favoriteCars) async {
    await _databaseService.updateUserFavorites(userId, favoriteCars);
  }

  // Private helper methods for internal use
  void _addFavoriteCar(User user, String carId) {
    if (!user.favoriteCars.contains(carId)) {
      user.favoriteCars.add(carId);
    }
  }

  void _removeFavoriteCar(User user, String carId) {
    user.favoriteCars.remove(carId);
  }
}
