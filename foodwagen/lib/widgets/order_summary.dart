import 'package:flutter/material.dart';
import 'package:foodwagen/models/cart.dart';
import 'package:foodwagen/services/style.dart';

// Résumé de commande (affiché en bas du panier).
//
// But :
// - Montrer subtotal / frais / tax / total
// - Proposer un bouton checkout (placeholder dans ce projet)
//
// Remarque pédagogique : ce widget est un bon exemple de "composition" Flutter.
// Plutôt que de faire tout le rendu dans l'écran, on isole un bloc réutilisable
// avec une API simple (des paramètres + un callback optionnel).
class OrderSummary extends StatelessWidget {
  final Cart cart;
  final VoidCallback? onCheckout;

  const OrderSummary({super.key, required this.cart, this.onCheckout});

  @override
  Widget build(BuildContext context) {
    // Container sert ici de "carte" collée en bas :
    // - padding pour l'espace intérieur
    // - decoration pour le fond + l'ombre
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // Petite ombre vers le haut : on donne l'impression que le résumé
            // est au-dessus de la liste.
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        // Column : empile verticalement le titre, les lignes de résumé et le bouton.
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Les "SummaryRow" sont des petits widgets dédiés :
          // chaque ligne aligne un label à gauche et une valeur à droite.
          SummaryRow(
            label: 'Subtotal',
            value: '\$${cart.subtotal.toStringAsFixed(2)}',
          ),
          SummaryRow(
            label: 'Delivery Fee',
            value: '\$${cart.deliveryFee.toStringAsFixed(2)}',
          ),
          SummaryRow(label: 'Tax', value: '\$${cart.tax.toStringAsFixed(2)}'),
          const Divider(),
          SummaryRow(
            label: 'Total',
            value: '\$${cart.total.toStringAsFixed(2)}',
            isTotal: true,
          ),
          const SizedBox(height: 16),
          CheckoutButton(
            total: cart.total,
            // Si l'écran parent fournit un callback onCheckout, on l'utilise.
            // Sinon, on montre un dialog "coming soon" local à ce widget.
            onPressed: onCheckout ?? () => _showCheckoutDialog(context),
          ),
        ],
      ),
    );
  }

  void _showCheckoutDialog(BuildContext context) {
    // showDialog : ouvre une modale au-dessus de l'écran.
    // Le builder retourne le widget à afficher (souvent AlertDialog).
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Checkout'),
        content: const Text(
          'Checkout feature is coming soon! This would take you to the payment screen.',
        ),
        actions: [
          TextButton(
            // Navigator.pop() ferme la boîte de dialogue.
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  // Ligne réutilisable : label à gauche, valeur à droite.
  final String label;
  final String value;
  final bool isTotal;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        // Row + spaceBetween => place les 2 textes aux extrémités.
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppStyle.PRIMERYCOLOR : null,
            ),
          ),
        ],
      ),
    );
  }
}

class CheckoutButton extends StatelessWidget {
  // Bouton checkout. Ici c'est un placeholder (feature future).
  final double total;
  final VoidCallback onPressed;

  const CheckoutButton({
    super.key,
    required this.total,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: double.infinity => le bouton prend toute la largeur disponible.
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppStyle.PRIMERYCOLOR,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          // On met le texte + le total sur une seule ligne.
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Proceed to Checkout'),
            const SizedBox(width: 8),
            Text(
              '(\$${total.toStringAsFixed(2)})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
