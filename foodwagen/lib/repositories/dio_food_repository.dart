import 'package:dio/dio.dart';
import 'package:foodwagen/models/food.dart';
import 'package:foodwagen/repositories/food_repository.dart';
import 'package:foodwagen/services/dio/api_service.dart';

// Implémentation Dio du FoodRepository.
//
// Important : on consomme uniquement les endpoints fournis :
// - GET    /Food
// - GET    /Food?name=...
// - POST   /Food
// - PUT    /Food/{id}
// - DELETE /Food/{id}
//
// Avantage : l’UI et Riverpod n’ont pas besoin de connaître Dio.
class DioFoodRepository implements FoodRepository {
  DioFoodRepository({Dio? dio}) : _dio = dio ?? ApiService.dio;

  final Dio _dio;

  @override
  Future<List<Food>> getFeaturedFoods() async {
    final response = await _dio.get('/Food');
    final data = response.data;
    if (data is List) {
      return data
          .whereType<Map>()
          .map((e) => Food.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }

  @override
  Future<List<Food>> filterFoodsByName(String searchParam) async {
    final response = await _dio.get(
      '/Food',
      queryParameters: {'name': searchParam},
    );
    final data = response.data;
    if (data is List) {
      return data
          .whereType<Map>()
          .map((e) => Food.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }

  @override
  Future<Food> createFood(Food food) async {
    final response = await _dio.post(
      '/Food',
      data: food.toJson()..remove('id'),
    );
    return Food.fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  @override
  Future<Food> updateFood(String id, Food food) async {
    final response = await _dio.put(
      '/Food/$id',
      data: food.toJson()..remove('id'),
    );
    return Food.fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  @override
  Future<void> deleteFood(String id) async {
    await _dio.delete('/Food/$id');
  }
}
