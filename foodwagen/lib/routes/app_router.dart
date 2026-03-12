import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:foodwagen/models/food.dart';
import 'package:foodwagen/l10n/app_localizations.dart';
import 'package:foodwagen/views/home/home.dart';
import 'package:foodwagen/views/auth/login.dart';
import 'package:foodwagen/views/auth/register.dart';
import 'package:foodwagen/views/cart/cart.dart';
import 'package:foodwagen/views/profile/profile.dart';
import 'package:foodwagen/views/food/food_list.dart';
import 'package:foodwagen/views/food/food_form.dart';

// Routing central de l'application.
//
// Pourquoi GoRouter ?
// - Navigation déclarative (routes regroupées dans un seul fichier).
// - Simple pour passer des paramètres (ex: /food/:id/edit) et des objets (state.extra).
//
// Note importante : l'app est volontairement centrée sur la ressource "Food"
// (endpoints MockAPI) => les routes principales sont /foods et /food/*.
GoRouter createRouter({required bool isAuthenticated}) {
  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      // If not authenticated and trying to access protected routes, redirect to login
      // redirect() est appelé à chaque navigation.
      // On l'utilise ici comme "guard" très simple.
      if (!isAuthenticated) {
        final protectedRoutes = ['/profile', '/cart'];
        final location = state.uri.toString();
        if (protectedRoutes.any((route) => location.startsWith(route))) {
          return '/login';
        }
      }

      return null;
    },
    routes: [
      // Home
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder: (context, state) => _defaultTransitionPage(
          key: state.pageKey,
          child: const HomeScreen(),
        ),
      ),

      // Authentication
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => _defaultTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),

      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder: (context, state) => _defaultTransitionPage(
          key: state.pageKey,
          child: const RegisterScreen(),
        ),
      ),

      // Foods (MockAPI)
      //
      // /foods : liste + recherche
      GoRoute(
        path: '/foods',
        name: 'foods',
        pageBuilder: (context, state) => _defaultTransitionPage(
          key: state.pageKey,
          child: const FoodListScreen(),
        ),
      ),

      // /food/new : création d'un food
      GoRoute(
        path: '/food/new',
        name: 'food_create',
        pageBuilder: (context, state) => _defaultTransitionPage(
          key: state.pageKey,
          child: const FoodFormScreen(),
        ),
      ),

      // /food/:id/edit : édition d'un food
      // On passe l'objet Food via state.extra (plus simple que de re-fetch).
      GoRoute(
        path: '/food/:id/edit',
        name: 'food_edit',
        pageBuilder: (context, state) {
          final food = state.extra;
          return _defaultTransitionPage(
            key: state.pageKey,
            child: FoodFormScreen(food: food is Food ? food : null),
          );
        },
      ),

      // Cart
      GoRoute(
        path: '/cart',
        name: 'cart',
        pageBuilder: (context, state) => _defaultTransitionPage(
          key: state.pageKey,
          child: const CartScreen(),
        ),
      ),

      // Profile
      GoRoute(
        path: '/profile',
        name: 'profile',
        pageBuilder: (context, state) => _defaultTransitionPage(
          key: state.pageKey,
          child: const ProfileScreen(),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.pageNotFound,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Could not find a page for: ${state.uri}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: Text(AppLocalizations.of(context)!.goHome),
            ),
          ],
        ),
      ),
    ),
  );
}

CustomTransitionPage<void> _defaultTransitionPage({
  required LocalKey key,
  required Widget child,
}) {
  // Transition simple et moderne :
  // - Fade (opacité)
  // - léger slide vertical (arrivée douce)
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(0, 0.02),
        end: Offset.zero,
      ).animate(fade);

      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: offsetAnimation, child: child),
      );
    },
  );
}

// Navigation helper functions
class NavigationHelper {
  // Helpers simples pour éviter de répéter les chemins string partout.
  // Le but est pédagogique : centraliser les appels context.go().
  static void navigateToHome(BuildContext context) {
    context.go('/home');
  }

  static void navigateToLogin(BuildContext context) {
    context.go('/login');
  }

  static void navigateToRegister(BuildContext context) {
    context.go('/register');
  }

  static void navigateToFoods(BuildContext context) {
    context.go('/foods');
  }

  static void navigateToCart(BuildContext context) {
    context.go('/cart');
  }

  static void navigateToProfile(BuildContext context) {
    context.go('/profile');
  }

  static void pop(BuildContext context) {
    // pop() revient à l'écran précédent.
    context.pop();
  }
}
