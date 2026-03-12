// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
  menuItem: MenuItem.fromJson(json['menuItem'] as Map<String, dynamic>),
  quantity: (json['quantity'] as num).toInt(),
  customizations: (json['customizations'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  totalPrice: (json['totalPrice'] as num).toDouble(),
);

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
  'menuItem': instance.menuItem,
  'quantity': instance.quantity,
  'customizations': instance.customizations,
  'totalPrice': instance.totalPrice,
};

Cart _$CartFromJson(Map<String, dynamic> json) => Cart(
  items: (json['items'] as List<dynamic>)
      .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  subtotal: (json['subtotal'] as num).toDouble(),
  deliveryFee: (json['deliveryFee'] as num).toDouble(),
  tax: (json['tax'] as num).toDouble(),
  total: (json['total'] as num).toDouble(),
  restaurantId: json['restaurantId'] as String,
);

Map<String, dynamic> _$CartToJson(Cart instance) => <String, dynamic>{
  'items': instance.items,
  'subtotal': instance.subtotal,
  'deliveryFee': instance.deliveryFee,
  'tax': instance.tax,
  'total': instance.total,
  'restaurantId': instance.restaurantId,
};

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
  id: json['id'] as String,
  restaurantId: json['restaurantId'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  subtotal: (json['subtotal'] as num).toDouble(),
  deliveryFee: (json['deliveryFee'] as num).toDouble(),
  tax: (json['tax'] as num).toDouble(),
  total: (json['total'] as num).toDouble(),
  status: json['status'] as String,
  deliveryAddress: json['deliveryAddress'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  estimatedDeliveryTime: json['estimatedDeliveryTime'] == null
      ? null
      : DateTime.parse(json['estimatedDeliveryTime'] as String),
  trackingId: json['trackingId'] as String?,
);

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
  'id': instance.id,
  'restaurantId': instance.restaurantId,
  'items': instance.items,
  'subtotal': instance.subtotal,
  'deliveryFee': instance.deliveryFee,
  'tax': instance.tax,
  'total': instance.total,
  'status': instance.status,
  'deliveryAddress': instance.deliveryAddress,
  'createdAt': instance.createdAt.toIso8601String(),
  'estimatedDeliveryTime': instance.estimatedDeliveryTime?.toIso8601String(),
  'trackingId': instance.trackingId,
};
