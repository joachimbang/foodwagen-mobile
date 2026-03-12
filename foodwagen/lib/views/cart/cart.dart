import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodwagen/models/cart.dart';
import 'package:foodwagen/providers/cart_provider.dart';
import 'package:foodwagen/widgets/cart_item_card.dart';
import 'package:foodwagen/widgets/order_summary.dart';
import 'package:foodwagen/services/style.dart';

// Écran panier.
//
// Il observe cartProvider (Riverpod) et affiche :
// - loading
// - erreur
// - panier vide
// - panier rempli (liste + résumé)
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cart = cartState.cart;
    final isLoading = cartState.isLoading;
    final error = cartState.error;

    // 1) Loading
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 2) Erreur
    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Cart')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                Text(
                  'Error loading cart',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  // On réinitialise juste l'erreur (l'UI pourra retenter).
                  onPressed: () => ref.read(cartProvider.notifier).clearError(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 3) Panier vide
    if (cart == null || cart.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Cart'),
          actions: [
            TextButton(
              // Vide le panier persistant.
              onPressed: () => ref.read(cartProvider.notifier).clearCart(),
              child: Text('Clear'),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'Your cart is empty',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add some delicious items to get started!',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  // Retour arrière (dans cette app, l'accès panier vient du bottom nav).
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.restaurant),
                label: const Text('Browse Restaurants'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyle.PRIMERYCOLOR,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 4) Panier avec items
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          TextButton(
            onPressed: () => ref.read(cartProvider.notifier).clearCart(),
            child: const Text('Clear'),
          ),
        ],
      ),
      body: Column(
        // Column :
        // - en haut => la liste scrollable des items
        // - en bas => le résumé (OrderSummary)
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                // itemBuilder : construit chaque ligne à la demande.
                final cartItem = cart.items[index];
                return CartItemCard(
                  cartItem: cartItem,
                  onIncreaseQuantity: () => _increaseQuantity(ref, cartItem),
                  onDecreaseQuantity: () => _decreaseQuantity(ref, cartItem),
                  onRemove: () => _removeItem(context, ref, cartItem),
                );
              },
            ),
          ),
          OrderSummary(
            cart: cart,
            onCheckout: () => _proceedToCheckout(context),
          ),
        ],
      ),
    );
  }

  void _increaseQuantity(WidgetRef ref, CartItem cartItem) {
    // Les helpers privés gardent build() lisible.
    ref
        .read(cartProvider.notifier)
        .updateQuantity(cartItem.menuItem.id, cartItem.quantity + 1);
  }

  void _decreaseQuantity(WidgetRef ref, CartItem cartItem) {
    if (cartItem.quantity > 1) {
      ref
          .read(cartProvider.notifier)
          .updateQuantity(cartItem.menuItem.id, cartItem.quantity - 1);
    }
  }

  void _removeItem(BuildContext context, WidgetRef ref, CartItem cartItem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Item'),
        content: Text(
          'Are you sure you want to remove ${cartItem.menuItem.name} from your cart?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref
                  .read(cartProvider.notifier)
                  .removeFromCart(cartItem.menuItem.id);
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _proceedToCheckout(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Checkout feature coming soon! This would take you to the payment screen.',
        ),
      ),
    );
  }
}
