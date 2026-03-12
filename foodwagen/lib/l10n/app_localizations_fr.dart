// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'FoodWagen';

  @override
  String welcomeUser(Object firstName) {
    return 'Bienvenue, $firstName !';
  }

  @override
  String get welcomeSubtitle => 'Qu’allez-vous manger aujourd’hui ?';

  @override
  String get welcomeGuestTitle => 'Bienvenue sur FoodWagen !';

  @override
  String get welcomeGuestSubtitle => 'Commandez de délicieux plats depuis vos restaurants préférés';

  @override
  String get home => 'Accueil';

  @override
  String get foods => 'Foods';

  @override
  String get foodsTitle => 'Foods';

  @override
  String get searchFoodHint => 'Rechercher un food par nom...';

  @override
  String get noFoodFound => 'Aucun food trouvé';

  @override
  String get createFood => 'Créer un Food';

  @override
  String get editFood => 'Modifier le Food';

  @override
  String get name => 'Nom';

  @override
  String get nameRequired => 'Le nom est obligatoire';

  @override
  String get restaurantName => 'Nom du restaurant';

  @override
  String get price => 'Prix';

  @override
  String get rating => 'Note';

  @override
  String get imageUrl => 'URL de l\'image';

  @override
  String get open => 'Ouvert';

  @override
  String get create => 'Créer';

  @override
  String get update => 'Mettre à jour';

  @override
  String get cart => 'Panier';

  @override
  String get profile => 'Profil';

  @override
  String get login => 'Connexion';

  @override
  String get register => 'Inscription';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get registerTitle => 'Inscription';

  @override
  String get pageNotFound => 'Page introuvable';

  @override
  String get goHome => 'Retour accueil';
}
