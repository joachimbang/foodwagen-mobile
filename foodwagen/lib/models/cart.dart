import 'package:json_annotation/json_annotation.dart';
import 'restaurant.dart';

part 'cart.g.dart';

// Modèles liés au panier.
//
// Ils sont sérialisés en JSON via json_serializable (fichier généré cart.g.dart).
// Le panier est ensuite persisté localement dans SecureStorage.
@JsonSerializable()
class CartItem {
  final MenuItem menuItem;
  final int quantity;
  final List<String> customizations;
  final double totalPrice;

  CartItem({
    required this.menuItem,
    required this.quantity,
    required this.customizations,
    required this.totalPrice,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemToJson(this);

  CartItem copyWith({
    MenuItem? menuItem,
    int? quantity,
    List<String>? customizations,
    double? totalPrice,
  }) {
    return CartItem(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      customizations: customizations ?? this.customizations,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}

@JsonSerializable()
class Cart {
  // Cart = snapshot du panier à un instant T.
  // NB: restaurantId est gardé pour associer le panier à un restaurant (template).
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final String restaurantId;

  Cart({
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.restaurantId,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  Map<String, dynamic> toJson() => _$CartToJson(this);

  Cart copyWith({
    List<CartItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? tax,
    double? total,
    String? restaurantId,
  }) {
    return Cart(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      restaurantId: restaurantId ?? this.restaurantId,
    );
  }

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

@JsonSerializable()
class Order {
  // Order = modèle "commande" (feature future, non connecté à une API dans ce projet).
  final String id;
  final String restaurantId;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final String status;
  final String deliveryAddress;
  final DateTime createdAt;
  final DateTime? estimatedDeliveryTime;
  final String? trackingId;

  Order({
    required this.id,
    required this.restaurantId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.status,
    required this.deliveryAddress,
    required this.createdAt,
    this.estimatedDeliveryTime,
    this.trackingId,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
