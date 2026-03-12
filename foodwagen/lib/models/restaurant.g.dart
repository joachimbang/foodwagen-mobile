// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) => Restaurant(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String,
  imageUrl: json['imageUrl'] as String,
  address: json['address'] as String,
  rating: (json['rating'] as num).toDouble(),
  deliveryTime: (json['deliveryTime'] as num).toInt(),
  deliveryFee: (json['deliveryFee'] as num).toDouble(),
  cuisine: json['cuisine'] as String,
  isOpen: json['isOpen'] as bool,
  categories: (json['categories'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$RestaurantToJson(Restaurant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'address': instance.address,
      'rating': instance.rating,
      'deliveryTime': instance.deliveryTime,
      'deliveryFee': instance.deliveryFee,
      'cuisine': instance.cuisine,
      'isOpen': instance.isOpen,
      'categories': instance.categories,
    };

MenuItem _$MenuItemFromJson(Map<String, dynamic> json) => MenuItem(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toDouble(),
  imageUrl: json['imageUrl'] as String,
  category: json['category'] as String,
  allergens: (json['allergens'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  isAvailable: json['isAvailable'] as bool,
  isVegetarian: json['isVegetarian'] as bool,
  isVegan: json['isVegan'] as bool,
);

Map<String, dynamic> _$MenuItemToJson(MenuItem instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'imageUrl': instance.imageUrl,
  'category': instance.category,
  'allergens': instance.allergens,
  'isAvailable': instance.isAvailable,
  'isVegetarian': instance.isVegetarian,
  'isVegan': instance.isVegan,
};

MenuCategory _$MenuCategoryFromJson(Map<String, dynamic> json) => MenuCategory(
  name: json['name'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MenuCategoryToJson(MenuCategory instance) =>
    <String, dynamic>{'name': instance.name, 'items': instance.items};
