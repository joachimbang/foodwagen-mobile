import 'package:foodwagen/models/food.dart';

// Contrat (interface) du repository Food.
//
// Pourquoi une interface ?
// - L'UI et les providers ne dépendent pas d'une implémentation concrète (Dio).
// - On peut remplacer par un fake/mock en test.
//
// Chaque méthode correspond directement aux endpoints autorisés par MockAPI.
abstract class FoodRepository {
  // GET /Food
  Future<List<Food>> getFeaturedFoods();

  // GET /Food?name=...
  Future<List<Food>> filterFoodsByName(String searchParam);

  // POST /Food
  Future<Food> createFood(Food food);

  // PUT /Food/{id}
  Future<Food> updateFood(String id, Food food);

  // DELETE /Food/{id}
  Future<void> deleteFood(String id);
}
