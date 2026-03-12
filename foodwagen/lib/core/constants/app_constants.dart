class AppConstants {
  // Constantes globales.
  //
  // Note : une partie de ces constantes provient d'un template (ex: routes Restaurants).
  // Dans l'architecture actuelle, la config API est plutôt lue via EnvService (.env)
  // et le routing est déclaré via GoRouter (app_router.dart).
  // App Info
  static const String appName = 'FoodWagen';
  static const String appVersion = '1.0.0';

  // API Endpoints
  // Exemple d'utilisation via "--dart-define".
  // Dans ce projet, on utilise surtout API_BASE_URL depuis le .env.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.foodwagen.com',
  );

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String cartKey = 'cart_items';
  static const String favoritesKey = 'favorite_items';

  // Routes
  // Routes historiques (Navigator). L'app utilise désormais GoRouter.
  static const String homeRoute = '/home';
  static const String restaurantsRoute = '/restaurants';
  static const String restaurantDetailRoute = '/restaurant/:id';
  static const String cartRoute = '/cart';
  static const String profileRoute = '/profile';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';

  // Timeouts
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;

  // Pagination
  static const int defaultPageSize = 20;

  // Cache Duration
  static const Duration cacheDuration = Duration(hours: 1);
}
