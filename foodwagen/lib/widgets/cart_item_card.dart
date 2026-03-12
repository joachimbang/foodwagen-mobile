import 'package:flutter/material.dart';
import 'package:foodwagen/models/cart.dart';

// Widget réutilisable : affiche une ligne du panier.
//
// Les callbacks sont fournis par l'écran (CartScreen) pour :
// - augmenter / diminuer la quantité
// - supprimer l'item
//
// Note pédagogique : on sépare l'UI en petites méthodes privées (_buildItemImage,
// _buildItemDetails, _buildActionButtons). Ça rend build() plus lisible et plus
// facile à maintenir, sans changer le rendu final.
class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback? onIncreaseQuantity;
  final VoidCallback? onDecreaseQuantity;
  final VoidCallback? onRemove;

  const CartItemCard({
    super.key,
    required this.cartItem,
    this.onIncreaseQuantity,
    this.onDecreaseQuantity,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    // Card = composant Material avec une élévation (ombre) et des coins arrondis
    // par défaut. Parfait pour des items de liste.
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          // Row aligne les enfants horizontalement :
          // [image] [espacement] [détails] [boutons]
          children: [
            _buildItemImage(),
            const SizedBox(width: 12),
            // Expanded donne tout l'espace restant à la colonne de détails.
            // Sans Expanded, les boutons de droite pourraient pousser/compresser
            // les textes ou provoquer un overflow.
            Expanded(child: _buildItemDetails()),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildItemImage() {
    // ClipRRect (clip + borderRadius) : arrondit les coins de l'image.
    // Très utilisé pour obtenir un rendu "card" plus moderne.
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        // Image.network charge une image via HTTP.
        // Important : si l'URL est invalide ou si le réseau échoue,
        // errorBuilder évite un crash et affiche un fallback.
        cartItem.menuItem.imageUrl,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 60,
          height: 60,
          color: Colors.grey[300],
          child: const Icon(Icons.restaurant, size: 30),
        ),
      ),
    );
  }

  Widget _buildItemDetails() {
    // Détails de l'item : nom, customizations (optionnel), prix.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cartItem.menuItem.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        // if (...) dans une liste de widgets => on n'affiche le bloc que si
        // la condition est vraie.
        if (cartItem.customizations.isNotEmpty)
          Text(
            'Customizations: ${cartItem.customizations.join(', ')}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        const SizedBox(height: 4),
        Text(
          '\$${cartItem.menuItem.price.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    // Les boutons appellent les callbacks si fournis.
    // Sinon on affiche "coming soon" (utile si on réutilise ce widget ailleurs).
    return Column(
      // Column : empile verticalement la ligne + / - et le bouton suppression.
      children: [
        Row(
          children: [
            _QuantityButton(
              icon: Icons.remove_circle_outline,
              // L'opérateur ?? permet un fallback :
              // - si onDecreaseQuantity est null, on utilise une fonction locale.
              onPressed:
                  onDecreaseQuantity ??
                  () => _showComingSoon(context, 'Decrease quantity'),
            ),
            Text(
              cartItem.quantity.toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            _QuantityButton(
              icon: Icons.add_circle_outline,
              onPressed:
                  onIncreaseQuantity ??
                  () => _showComingSoon(context, 'Increase quantity'),
            ),
          ],
        ),
        IconButton(
          // IconButton est un bouton cliquable uniquement avec une icône.
          onPressed: onRemove ?? () => _showComingSoon(context, 'Remove item'),
          icon: const Icon(Icons.delete_outline, color: Colors.red),
        ),
      ],
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    // ScaffoldMessenger affiche une SnackBar liée au Scaffold le plus proche.
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$feature feature coming soon!')));
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QuantityButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // Petit wrapper autour d'IconButton pour factoriser le style/tailles.
    return IconButton(onPressed: onPressed, icon: Icon(icon, size: 24));
  }
}
