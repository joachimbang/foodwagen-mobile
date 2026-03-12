import 'package:json_annotation/json_annotation.dart';

part 'restaurant.g.dart';

// Modèles "Restaurant" provenant du template initial.
//
// Dans le scope actuel (API Food uniquement), ces modèles servent surtout à :
// - supporter le panier (MenuItem mocké dans cart_provider.dart)
// - garder la structure pour des features futures.
@JsonSerializable()
class Restaurant {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final String address;
  final double rating;
  final int deliveryTime;
  final double deliveryFee;
  final String cuisine;
  final bool isOpen;
  final List<String> categories;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.address,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.cuisine,
    required this.isOpen,
    required this.categories,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}

@JsonSerializable()
class MenuItem {
  // MenuItem : item d'un menu de restaurant.
  // Dans l'app actuelle, on le crée en local (mock) pour le panier.
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final List<String> allergens;
  final bool isAvailable;
  final bool isVegetarian;
  final bool isVegan;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.allergens,
    required this.isAvailable,
    required this.isVegetarian,
    required this.isVegan,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemToJson(this);
}

@JsonSerializable()
class MenuCategory {
  // Groupe d'items (catégorie) - feature future.
  final String name;
  final List<MenuItem> items;

  MenuCategory({required this.name, required this.items});

  factory MenuCategory.fromJson(Map<String, dynamic> json) =>
      _$MenuCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$MenuCategoryToJson(this);
}
