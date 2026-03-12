import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodwagen/models/cart.dart';
import 'package:foodwagen/models/restaurant.dart';
import 'package:foodwagen/services/storage/secure_storage_service.dart';
import 'package:foodwagen/core/utils/logger.dart';

// Gestion du panier (Cart) via Riverpod.
//
// Ce provider démontre :
// - un StateNotifier (état mutable contrôlé)
// - la persistance locale (SecureStorage) pour garder le panier après redémarrage.
class CartState {
  final Cart? cart;
  final bool isLoading;
  final String? error;

  CartState({this.cart, this.isLoading = false, this.error});

  CartState copyWith({Cart? cart, bool? isLoading, String? error}) {
    return CartState(
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState());

  Future<void> loadCart() async {
    // Restaure le panier depuis le stockage.
    state = state.copyWith(isLoading: true, error: null);

    try {
      final cartData = await SecureStorageService.getCartData();
      if (cartData != null) {
        // Parse cart data from JSON
        final cart = Cart.fromJson(cartData);
        state = state.copyWith(cart: cart, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      AppLogger.error('Failed to load cart', error: e);
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load cart: ${e.toString()}',
      );
    }
  }

  Future<void> addToCart({
    required String restaurantId,
    required int menuItemId,
    required int quantity,
    List<String>? customizations,
  }) async {
    // Ajout d'un item au panier.
    // Ici, la partie "menu" est mockée (MenuItem) car on ne consomme pas d'API Restaurant.
    state = state.copyWith(isLoading: true, error: null);

    try {
      // For now, create a mock cart item
      final mockMenuItem = MenuItem(
        id: menuItemId,
        name: 'Menu Item $menuItemId',
        description: 'Description for menu item $menuItemId',
        price: 9.99,
        imageUrl:
            'https://via.placeholder.com/100x100/FF6B35/FFFFFF?text=Item$menuItemId',
        category: 'Main Course',
        allergens: [],
        isAvailable: true,
        isVegetarian: false,
        isVegan: false,
      );

      final mockCartItem = CartItem(
        menuItem: mockMenuItem,
        quantity: quantity,
        customizations: customizations ?? [],
        totalPrice: 9.99 * quantity,
      );

      final currentCart = state.cart;
      if (currentCart != null) {
        final updatedItems = [...currentCart.items, mockCartItem];
        final updatedCart = currentCart.copyWith(
          items: updatedItems,
          subtotal: currentCart.subtotal + mockCartItem.totalPrice,
          total: currentCart.total + mockCartItem.totalPrice,
        );

        state = state.copyWith(cart: updatedCart, isLoading: false);

        // Save to storage
        await SecureStorageService.storeCartData(updatedCart.toJson());
      } else {
        // Create new cart
        final newCart = Cart(
          items: [mockCartItem],
          subtotal: mockCartItem.totalPrice,
          deliveryFee: 2.99,
          tax: (mockCartItem.totalPrice * 0.1).roundToDouble(),
          total:
              mockCartItem.totalPrice +
              2.99 +
              (mockCartItem.totalPrice * 0.1).roundToDouble(),
          restaurantId: restaurantId,
        );

        state = state.copyWith(cart: newCart, isLoading: false);

        // Save to storage
        await SecureStorageService.storeCartData(newCart.toJson());
      }
    } catch (e) {
      AppLogger.error('Failed to add item to cart', error: e);
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to add item to cart: ${e.toString()}',
      );
    }
  }

  Future<void> removeFromCart(int cartItemId) async {
    // Supprime un item (par id de MenuItem) puis persiste.
    state = state.copyWith(isLoading: true, error: null);

    try {
      final currentCart = state.cart;
      if (currentCart != null) {
        final updatedItems = currentCart.items
            .where((item) => item.menuItem.id != cartItemId)
            .toList();

        final removedItem = currentCart.items.firstWhere(
          (item) => item.menuItem.id == cartItemId,
        );

        final updatedCart = currentCart.copyWith(
          items: updatedItems,
          subtotal: currentCart.subtotal - removedItem.totalPrice,
          total: currentCart.total - removedItem.totalPrice,
        );

        state = state.copyWith(cart: updatedCart, isLoading: false);

        // Save to storage
        await SecureStorageService.storeCartData(updatedCart.toJson());
      }
    } catch (e) {
      AppLogger.error('Failed to remove item from cart', error: e);
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to remove item from cart: ${e.toString()}',
      );
    }
  }

  Future<void> updateQuantity(int cartItemId, int newQuantity) async {
    // Met à jour la quantité (et si <= 0 on supprime).
    if (newQuantity <= 0) {
      await removeFromCart(cartItemId);
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final currentCart = state.cart;
      if (currentCart != null) {
        final updatedItems = currentCart.items.map((item) {
          if (item.menuItem.id == cartItemId) {
            final newTotalPrice = item.menuItem.price * newQuantity;
            return item.copyWith(
              quantity: newQuantity,
              totalPrice: newTotalPrice,
            );
          }
          return item;
        }).toList();

        final newSubtotal = updatedItems.fold<double>(
          0.0,
          (sum, item) => sum + item.totalPrice,
        );

        final updatedCart = currentCart.copyWith(
          items: updatedItems,
          subtotal: newSubtotal,
          total: newSubtotal + currentCart.deliveryFee + currentCart.tax,
        );

        state = state.copyWith(cart: updatedCart, isLoading: false);

        // Save to storage
        await SecureStorageService.storeCartData(updatedCart.toJson());
      }
    } catch (e) {
      AppLogger.error('Failed to update quantity', error: e);
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update quantity: ${e.toString()}',
      );
    }
  }

  Future<void> clearCart() async {
    // Vide le panier + supprime la donnée persistée.
    state = state.copyWith(isLoading: true, error: null);

    try {
      await SecureStorageService.removeCartData();
      state = CartState();
    } catch (e) {
      AppLogger.error('Failed to clear cart', error: e);
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to clear cart: ${e.toString()}',
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider principal du panier.
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

// Expose un stream des changements (utile si on veut réagir côté UI sans rebuild global).
final cartStreamProvider = StreamProvider<Cart?>((ref) {
  return ref.watch(cartProvider.notifier).stream.map((state) => state.cart);
});

// Sélecteurs pratiques pour l'UI.
final cartItemsProvider = Provider<List<CartItem>>((ref) {
  final cart = ref.watch(cartProvider).cart;
  return cart?.items ?? [];
});

final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider).cart;
  return cart?.total ?? 0.0;
});

final cartItemCountProvider = Provider<int>((ref) {
  final items = ref.watch(cartItemsProvider);
  return items.fold(0, (sum, item) => sum + item.quantity);
});
