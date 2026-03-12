import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodwagen/models/food.dart';
import 'package:foodwagen/repositories/dio_food_repository.dart';
import 'package:foodwagen/repositories/food_repository.dart';

// Provider de dépendance : expose un FoodRepository à l’app.
//
// Pourquoi ?
// - Permet de remplacer facilement l’implémentation (ex: mock, autre backend).
final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  return DioFoodRepository();
});

// foodsProvider(search) : charge les foods.
// - si search est vide => GET /Food
// - sinon => GET /Food?name=...
//
// FutureProvider.family permet de “paramétrer” le provider avec la recherche.
final foodsProvider = FutureProvider.family<List<Food>, String?>((
  ref,
  search,
) async {
  final repo = ref.watch(foodRepositoryProvider);
  if (search == null || search.trim().isEmpty) {
    return repo.getFeaturedFoods();
  }
  return repo.filterFoodsByName(search.trim());
});
