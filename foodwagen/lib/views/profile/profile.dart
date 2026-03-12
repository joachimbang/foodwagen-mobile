import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodwagen/providers/auth_provider.dart';
import 'package:foodwagen/routes/app_router.dart';

// Écran profil.
//
// Dans ce projet :
// - On affiche les infos de l'utilisateur (mock) si connecté.
// - Sinon, on affiche un CTA pour se connecter.
// - Les sections "Addresses", "Payment", "Orders" sont des placeholders (coming soon).
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    // Scaffold = structure standard.
    // Ici, le body dépend de l'état (connecté ou non).
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              // Ouvre une boite de dialogue (AlertDialog) "Settings".
              _showSettingsDialog(context);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: user != null
          ? _buildProfileContent(context, ref, user)
          : _buildLoginPrompt(context),
    );
  }

  Widget _buildProfileContent(BuildContext context, WidgetRef ref, user) {
    // Contenu principal quand l'utilisateur est connecté.
    // Utilisation de SingleChildScrollView pour permettre le scroll si le contenu dépasse l'écran.
    return SingleChildScrollView(
      // SingleChildScrollView permet de scroller si le contenu dépasse.
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          // Cette section affiche les informations de l'utilisateur (nom, prénom, email, téléphone).
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.deepOrange,
                  child: Text(
                    '${user.firstName[0]}${user.lastName[0]}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.fullName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  user.phoneNumber,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Menu Options
          _buildMenuSection(
            title: 'Account',
            items: [
              _MenuItem(
                icon: Icons.person,
                title: 'Personal Information',
                subtitle: 'Update your personal details',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Personal info feature coming soon!'),
                    ),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.location_on,
                title: 'Delivery Addresses',
                subtitle: 'Manage your delivery addresses',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Addresses feature coming soon!'),
                    ),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.payment,
                title: 'Payment Methods',
                subtitle: 'Add or remove payment methods',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment methods feature coming soon!'),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          _buildMenuSection(
            title: 'Orders',
            items: [
              _MenuItem(
                icon: Icons.receipt_long,
                title: 'Order History',
                subtitle: 'View your past orders',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order history feature coming soon!'),
                    ),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.favorite,
                title: 'Favorite Restaurants',
                subtitle: 'View your favorite restaurants',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Favorites feature coming soon!'),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          _buildMenuSection(
            title: 'Support',
            items: [
              _MenuItem(
                icon: Icons.help,
                title: 'Help Center',
                subtitle: 'Get help with your orders',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Help center feature coming soon!'),
                    ),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.contact_support,
                title: 'Contact Support',
                subtitle: 'Reach out to our support team',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Contact support feature coming soon!'),
                    ),
                  );
                },
              ),
              _MenuItem(
                icon: Icons.info,
                title: 'About',
                subtitle: 'Learn more about FoodWagen',
                onTap: () {
                  _showAboutDialog(context);
                },
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Logout Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // On demande confirmation avant de déconnecter.
                _showLogoutDialog(context, ref);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    // Affiché quand user == null.
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, size: 100, color: Colors.grey),
            const SizedBox(height: 32),
            Text(
              'Please Login',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'You need to be logged in to view your profile',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                NavigationHelper.navigateToLogin(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection({
    required String title,
    required List<_MenuItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        ...items.map((item) => item),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    // Confirmation de déconnexion.
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authProvider.notifier).logout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Settings feature coming soon!'),
            const SizedBox(height: 16),
            _buildSettingItem('Notifications', 'Push notifications settings'),
            _buildSettingItem('Language', 'Change app language'),
            _buildSettingItem('Theme', 'Dark/Light mode'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(subtitle, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About FoodWagen'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('FoodWagen v1.0.0'),
            SizedBox(height: 8),
            Text('Your favorite food delivery app'),
            SizedBox(height: 16),
            Text('Made with ❤️ by FoodWagen Team'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // ListTile = composant standard : icône + titre + sous-titre + action.
    return ListTile(
      leading: Icon(icon, color: Colors.deepOrange),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
