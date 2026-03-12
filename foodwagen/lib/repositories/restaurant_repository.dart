import 'package:foodwagen/models/restaurant.dart';

// Contrat (interface) "Restaurant" provenant du template initial.
//
// Important : l'objectif actuel du projet est de consommer uniquement les endpoints "Food".
// Ce repository n'est donc pas utilisé dans le flux principal (il reste pour compatibilité).
abstract class RestaurantRepository {
  Future<List<Restaurant>> getRestaurants();
  Future<Restaurant> getRestaurantDetails(String restaurantId);
  Future<List<MenuCategory>> getRestaurantMenu(String restaurantId);
}
