import 'package:car_log/model/user.dart';
import 'package:car_log/services/database_service.dart';

class UserService {
  final DatabaseService _databaseService = DatabaseService();

  /// Fetches the current user's data
  Future<User?> getUserData(String userId) async {
    return await _databaseService.getUserById(userId);
  }

  /// Checks if a car is in the user's favorites
  bool isFavoriteCar(User user, String carId) {
    return user.favoriteCars.contains(carId);
  }

  /// Adds a car to the user's favorites
  void addFavoriteCar(User user, String carId) {
    if (!user.favoriteCars.contains(carId)) {
      user.favoriteCars.add(carId);
    }
  }

  /// Removes a car from the user's favorites
  void removeFavoriteCar(User user, String carId) {
    user.favoriteCars.remove(carId);
  }

  /// Updates the user's favorites in the database
  Future<void> updateUserFavorites(String userId, List<String> favoriteCars) async {
    await _databaseService.updateUserFavorites(userId, favoriteCars);
  }
}
