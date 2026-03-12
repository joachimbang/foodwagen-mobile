// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'FoodWagen';

  @override
  String welcomeUser(Object firstName) {
    return 'Welcome, $firstName!';
  }

  @override
  String get welcomeSubtitle => 'What would you like to eat today?';

  @override
  String get welcomeGuestTitle => 'Welcome to FoodWagen!';

  @override
  String get welcomeGuestSubtitle => 'Order delicious food from your favorite restaurants';

  @override
  String get home => 'Home';

  @override
  String get foods => 'Foods';

  @override
  String get foodsTitle => 'Foods';

  @override
  String get searchFoodHint => 'Search food by name...';

  @override
  String get noFoodFound => 'No food found';

  @override
  String get createFood => 'Create Food';

  @override
  String get editFood => 'Edit Food';

  @override
  String get name => 'Name';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get restaurantName => 'Restaurant name';

  @override
  String get price => 'Price';

  @override
  String get rating => 'Rating';

  @override
  String get imageUrl => 'Image URL';

  @override
  String get open => 'Open';

  @override
  String get create => 'Create';

  @override
  String get update => 'Update';

  @override
  String get cart => 'Cart';

  @override
  String get profile => 'Profile';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get loginTitle => 'Login';

  @override
  String get registerTitle => 'Register';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get goHome => 'Go Home';
}
