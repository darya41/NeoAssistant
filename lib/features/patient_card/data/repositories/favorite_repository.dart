import '../services/favorite_service.dart';

class FavoriteRepository {
  final FavoriteService _favoriteService = FavoriteService();

  Future<bool> isFavorite(int patientId) async {
    try {
      final response = await _favoriteService.checkFavorite(patientId);

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка проверки избранного');
      }

      return response['is_favorite'] ?? false;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addFavorite(int patientId) async {
    try {
      final response = await _favoriteService.addFavorite(patientId);

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка добавления в избранное');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFavorite(int patientId) async {
    try {
      final response = await _favoriteService.removeFavorite(patientId);

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка удаления из избранного');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleFavorite(int patientId, bool isCurrentlyFavorite) async {
    if (isCurrentlyFavorite) {
      await removeFavorite(patientId);
    } else {
      await addFavorite(patientId);
    }
  }

  Future<List<int>> getFavoritePatientIds() async {
    try {
      final response = await _favoriteService.getFavorites();

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Ошибка получения избранного');
      }

      final List<dynamic> data = response['data'] ?? [];
      return data.map((json) => json['patient_id'] as int).toList();
    } catch (e) {
      rethrow;
    }
  }
}