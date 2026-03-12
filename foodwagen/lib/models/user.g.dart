// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String,
  phoneNumber: json['phoneNumber'] as String,
  profileImageUrl: json['profileImageUrl'] as String?,
  addresses: (json['addresses'] as List<dynamic>)
      .map((e) => Address.fromJson(e as Map<String, dynamic>))
      .toList(),
  paymentMethods: (json['paymentMethods'] as List<dynamic>)
      .map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'phoneNumber': instance.phoneNumber,
  'profileImageUrl': instance.profileImageUrl,
  'addresses': instance.addresses,
  'paymentMethods': instance.paymentMethods,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
  id: (json['id'] as num).toInt(),
  street: json['street'] as String,
  city: json['city'] as String,
  state: json['state'] as String,
  postalCode: json['postalCode'] as String,
  country: json['country'] as String,
  isDefault: json['isDefault'] as bool,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
);

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
  'id': instance.id,
  'street': instance.street,
  'city': instance.city,
  'state': instance.state,
  'postalCode': instance.postalCode,
  'country': instance.country,
  'isDefault': instance.isDefault,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) =>
    PaymentMethod(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      lastFour: json['lastFour'] as String,
      brand: json['brand'] as String,
      expiryMonth: json['expiryMonth'] as String,
      expiryYear: json['expiryYear'] as String,
      isDefault: json['isDefault'] as bool,
    );

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'lastFour': instance.lastFour,
      'brand': instance.brand,
      'expiryMonth': instance.expiryMonth,
      'expiryYear': instance.expiryYear,
      'isDefault': instance.isDefault,
    };
