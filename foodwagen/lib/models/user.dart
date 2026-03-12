import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

// Modèles "User".
//
// Utilisés par auth_provider.dart pour stocker un utilisateur (mock) et le persister.
// Sérialisation via json_serializable (user.g.dart).
@JsonSerializable()
class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String? profileImageUrl;
  final List<Address> addresses;
  final List<PaymentMethod> paymentMethods;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    this.profileImageUrl,
    required this.addresses,
    required this.paymentMethods,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String get fullName => '$firstName $lastName';
}

@JsonSerializable()
class Address {
  // Adresse de livraison (feature future).
  final int id;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final bool isDefault;
  final double latitude;
  final double longitude;

  Address({
    required this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.isDefault,
    required this.latitude,
    required this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

  String get fullAddress => '$street, $city, $state $postalCode, $country';
}

@JsonSerializable()
class PaymentMethod {
  // Moyen de paiement (feature future).
  final int id;
  final String type; // 'credit_card', 'debit_card', 'paypal', etc.
  final String lastFour;
  final String brand; // 'visa', 'mastercard', etc.
  final String expiryMonth;
  final String expiryYear;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.lastFour,
    required this.brand,
    required this.expiryMonth,
    required this.expiryYear,
    required this.isDefault,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);

  String get displayName => '${brand.toUpperCase()} ****$lastFour';
}
