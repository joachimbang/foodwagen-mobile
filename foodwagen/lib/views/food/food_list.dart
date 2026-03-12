import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:foodwagen/models/food.dart';
import 'package:foodwagen/providers/foods_provider.dart';
import 'package:foodwagen/services/style.dart';
import 'package:foodwagen/l10n/app_localizations.dart';

class FoodListScreen extends ConsumerStatefulWidget {
  // Page principale : liste des foods.
  //
  // Elle démontre le flux complet :
  // UI -> Provider (Riverpod) -> Repository -> Dio -> API.
  const FoodListScreen({super.key});

  @override
  ConsumerState<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends ConsumerState<FoodListScreen> {
  final _searchController = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // foodsProvider(_search) : si _search est vide => GET /Food
    // sinon => GET /Food?name=...
    final foodsAsync = ref.watch(foodsProvider(_search));

    // Scaffold = structure de base d'un écran Material :
    // - appBar (barre du haut)
    // - body (contenu)
    // - floatingActionButton (bouton +)
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.foodsTitle),
        // PreferredSize permet de mettre un widget "bottom" avec une hauteur fixe.
        // Ici on l'utilise pour ajouter un champ de recherche sous le titre.
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchFoodHint,
                prefixIcon: const Icon(Icons.search),
                // suffixIcon = petit bouton de droite dans le champ.
                // On l'affiche uniquement quand il y a un texte à effacer.
                suffixIcon: _search.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _search = '';
                          });
                        },
                        icon: const Icon(Icons.clear),
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              // setState => on relance un build pour mettre à jour _search.
              // Riverpod (foodsProvider) est recalculé avec la nouvelle valeur.
              onChanged: (value) {
                setState(() {
                  _search = value;
                });
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyle.PRIMERYCOLOR,
        onPressed: () async {
          // Navigation vers l'écran de création.
          // context.push retourne une valeur (ici bool) quand on fait pop(true).
          final didChange = await context.push<bool>('/food/new');
          if (didChange == true && mounted) {
            ref.invalidate(foodsProvider(_search));
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      // AsyncValue.when() : pattern Riverpod pour gérer loading/error/data.
      body: foodsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => _ErrorState(
          message: err.toString(),
          onRetry: () => ref.invalidate(foodsProvider(_search)),
        ),
        data: (foods) {
          if (foods.isEmpty) {
            return Center(child: Text(l10n.noFoodFound));
          }

          // ListView.builder = liste performante (construit les items à la demande).
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: foods.length,
            itemBuilder: (context, index) {
              final food = foods[index];
              return _FoodCard(
                food: food,
                onEdit: () async {
                  // Pour l'édition, on passe l'objet Food via "extra".
                  // Avantage : pas besoin de re-fetch l'item par id.
                  final didChange = await context.push<bool>(
                    '/food/${food.id}/edit',
                    extra: food,
                  );
                  if (didChange == true && mounted) {
                    ref.invalidate(foodsProvider(_search));
                  }
                },
                onDelete: () async {
                  // showDialog retourne une Future<bool?>.
                  // Ici on l'utilise comme confirmation avant suppression.
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete'),
                      content: Text('Delete "${food.name}"?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed != true || !mounted) return;

                  final repo = ref.read(foodRepositoryProvider);
                  await repo.deleteFood(food.id);
                  ref.invalidate(foodsProvider(_search));
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _FoodCard extends StatelessWidget {
  const _FoodCard({
    required this.food,
    required this.onEdit,
    required this.onDelete,
  });

  final Food food;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  String? get _imageUrl => food.image ?? food.avatar;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _imageUrl == null
                    ? Container(
                        width: 88,
                        height: 88,
                        color: Colors.grey[200],
                        child: const Icon(Icons.fastfood),
                      )
                    : CachedNetworkImage(
                        imageUrl: _imageUrl!,
                        width: 88,
                        height: 88,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 88,
                          height: 88,
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 88,
                          height: 88,
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (food.restaurantName != null &&
                        food.restaurantName!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        food.restaurantName!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: [
                        if (food.price != null)
                          _Chip(
                            label: 'Price: ${food.price!.toStringAsFixed(2)}',
                          ),
                        if (food.rating != null)
                          _Chip(label: 'Rating: ${food.rating}'),
                        if (food.open != null)
                          _Chip(label: food.open! ? 'Open' : 'Closed'),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') onEdit();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(
              'Failed to load foods',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
