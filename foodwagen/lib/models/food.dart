class Food {
  // Modèle Food = représentation locale (Dart) d'une entrée renvoyée par MockAPI.
  //
  // Pourquoi ce modèle ?
  // - Centralise le mapping JSON <-> Dart.
  // - Évite d'avoir des Map<String, dynamic> partout dans l'UI.
  //
  // Attention : MockAPI renvoie parfois des types différents selon les enregistrements
  // (ex: rating peut être un nombre OU une String). D'où le parsing "défensif".
  final String id;
  final DateTime? createdAt;
  final String name;
  final String? avatar;
  final String? image;
  final String? logo;
  final String? restaurantName;
  final double? rating;
  final bool? open;
  final double? price;

  const Food({
    required this.id,
    required this.name,
    this.createdAt,
    this.avatar,
    this.image,
    this.logo,
    this.restaurantName,
    this.rating,
    this.open,
    this.price,
  });

  static double? _parseDouble(dynamic value) {
    // Gère les cas : 4.2, "4.2", null
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static bool? _parseBool(dynamic value) {
    // Gère les cas : true/false, "true"/"false", 0/1
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) {
      if (value.toLowerCase() == 'true') return true;
      if (value.toLowerCase() == 'false') return false;
    }
    if (value is num) {
      if (value == 1) return true;
      if (value == 0) return false;
    }
    return null;
  }

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: (json['id'] ?? '').toString(),
      createdAt: json['createdAt'] is String
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      name: (json['name'] ?? '').toString(),
      avatar: json['avatar']?.toString(),
      image: json['image']?.toString(),
      logo: json['logo']?.toString(),
      restaurantName: json['restaurantName']?.toString(),
      rating: _parseDouble(json['rating']),
      open: _parseBool(json['open']),
      price: _parseDouble(json['Price']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'name': name,
      'avatar': avatar,
      'image': image,
      'logo': logo,
      'restaurantName': restaurantName,
      'rating': rating,
      'open': open,
      'Price': price?.toStringAsFixed(2),
    };
  }

  Food copyWith({
    String? id,
    DateTime? createdAt,
    String? name,
    String? avatar,
    String? image,
    String? logo,
    String? restaurantName,
    double? rating,
    bool? open,
    double? price,
  }) {
    return Food(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      image: image ?? this.image,
      logo: logo ?? this.logo,
      restaurantName: restaurantName ?? this.restaurantName,
      rating: rating ?? this.rating,
      open: open ?? this.open,
      price: price ?? this.price,
    );
  }
}
