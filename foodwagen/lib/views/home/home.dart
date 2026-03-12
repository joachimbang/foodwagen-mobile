import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodwagen/providers/auth_provider.dart';
import 'package:foodwagen/routes/app_router.dart';
import 'package:foodwagen/l10n/app_localizations.dart';

// Écran d'accueil.
//
// Rôle :
// - Point d'entrée utilisateur
// - Propose des raccourcis vers les features (Foods, Cart, Profile)
// - Adapte certains accès selon l'auth (ex: Profile/Cart => login si non connecté)
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final l10n = AppLocalizations.of(context)!;

    // On construit un écran complet.
    // ConsumerWidget => accès direct à Riverpod via WidgetRef.
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Si pas connecté, on redirige vers le login.
              if (user != null) {
                NavigationHelper.navigateToProfile(context);
              } else {
                NavigationHelper.navigateToLogin(context);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        // Padding = marge intérieure pour que l'UI respire.
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // Column = empile les widgets verticalement.
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user != null) ...[
                // Text + style venant du thème.
                Text(
                  l10n.welcomeUser(user.firstName),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.welcomeSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ] else ...[
                Text(
                  l10n.welcomeGuestTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.welcomeGuestSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
              const SizedBox(height: 32),
              Expanded(
                // Expanded = prend tout l'espace restant de la Column.
                child: GridView.count(
                  // GridView.count = grille simple en spécifiant le nombre de colonnes.
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildFeatureCard(
                      context,
                      l10n.foods,
                      Icons.fastfood,
                      Colors.orange,
                      // Navigation centralisée via NavigationHelper (GoRouter).
                      () => NavigationHelper.navigateToFoods(context),
                    ),
                    _buildFeatureCard(
                      context,
                      'My Orders',
                      Icons.receipt_long,
                      Colors.green,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Orders feature coming soon!'),
                          ),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      'Favorites',
                      Icons.favorite,
                      Colors.red,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Favorites feature coming soon!'),
                          ),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      'Support',
                      Icons.support_agent,
                      Colors.blue,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Support feature coming soon!'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // Navigation simple via index.
          switch (index) {
            case 0:
              NavigationHelper.navigateToHome(context);
              break;
            case 1:
              NavigationHelper.navigateToFoods(context);
              break;
            case 2:
              if (user != null) {
                NavigationHelper.navigateToCart(context);
              } else {
                NavigationHelper.navigateToLogin(context);
              }
              break;
            case 3:
              if (user != null) {
                NavigationHelper.navigateToProfile(context);
              } else {
                NavigationHelper.navigateToLogin(context);
              }
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.restaurant),
            label: l10n.foods,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart),
            label: l10n.cart,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: l10n.profile,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
