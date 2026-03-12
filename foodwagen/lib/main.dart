import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:foodwagen/routes/app_router.dart';
import 'package:foodwagen/services/environment/env_service.dart';
import 'package:foodwagen/providers/auth_provider.dart';
import 'package:foodwagen/services/style.dart';
import 'package:foodwagen/services/dio/api_service.dart';
import 'package:foodwagen/l10n/app_localizations.dart';

// Point d'entrée de l'application.
//
// Rôle :
// - Initialiser Flutter.
// - Charger la configuration (.env).
// - Initialiser le client HTTP (Dio).
// - Démarrer Riverpod (ProviderScope) + MaterialApp.router.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await EnvService.load();

  // Configure Dio (baseUrl, timeouts, logs). Les appels API se font via les repositories.
  ApiService.initialize();

  // ProviderScope = conteneur global Riverpod.
  runApp(const ProviderScope(child: FoodWagen()));
}

class FoodWagen extends ConsumerWidget {
  const FoodWagen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Le router dépend de l'état d'auth (voir appRouterProvider ci-dessous).
    final router = ref.watch(appRouterProvider);

    // AppStyle contient les thèmes clair/sombre de l'app.
    // On utilise ThemeMode.system pour suivre automatiquement le thème du téléphone.
    final appStyle = AppStyle();

    return MaterialApp.router(
      // Le titre est surtout utilisé par l'OS (ex: sélecteur d'applications).
      // Les strings affichées dans l'UI viennent plutôt de AppLocalizations.
      title: 'FoodWagen',
      debugShowCheckedModeBanner: false,
      // Thèmes clair/sombre.
      theme: appStyle.lightTheme(context),
      darkTheme: appStyle.darkTheme(context),
      themeMode: ThemeMode.system,

      // Localisation : suit la langue du téléphone.
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  // On relit l'état d'auth à chaque changement.
  // Quand l'utilisateur se connecte / déconnecte, GoRouter peut rediriger.
  final isAuthenticated = ref.watch(isAuthenticatedProvider);
  return createRouter(isAuthenticated: isAuthenticated);
});
