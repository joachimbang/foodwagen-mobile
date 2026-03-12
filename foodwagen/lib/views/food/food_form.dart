import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodwagen/models/food.dart';
import 'package:foodwagen/providers/foods_provider.dart';
import 'package:foodwagen/services/style.dart';
import 'package:foodwagen/l10n/app_localizations.dart';

class FoodFormScreen extends ConsumerStatefulWidget {
  // Formulaire utilisé pour :
  // - créer un Food (POST /Food)
  // - modifier un Food (PUT /Food/{id})
  //
  // Si food == null => mode création.
  // Si food != null => mode édition.
  const FoodFormScreen({super.key, this.food});

  final Food? food;

  @override
  ConsumerState<FoodFormScreen> createState() => _FoodFormScreenState();
}

class _FoodFormScreenState extends ConsumerState<FoodFormScreen> {
  // GlobalKey permet d'accéder à l'état du Form (validation, etc.).
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _name;
  late final TextEditingController _restaurantName;
  late final TextEditingController _price;
  late final TextEditingController _rating;
  late final TextEditingController _image;
  bool _open = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final f = widget.food;

    // Pré-remplissage en mode édition.
    // En mode création => champs vides.
    _name = TextEditingController(text: f?.name ?? '');
    _restaurantName = TextEditingController(text: f?.restaurantName ?? '');
    _price = TextEditingController(text: f?.price?.toString() ?? '');
    _rating = TextEditingController(text: f?.rating?.toString() ?? '');
    _image = TextEditingController(text: f?.image ?? f?.avatar ?? '');
    _open = f?.open ?? true;
  }

  @override
  void dispose() {
    _name.dispose();
    _restaurantName.dispose();
    _price.dispose();
    _rating.dispose();
    _image.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEdit = widget.food != null;

    // Scaffold : appBar + body.
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? l10n.editFood : l10n.createFood)),
      body: SafeArea(
        // SafeArea évite que le contenu passe sous la barre de status / encoche.
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            // ListView pour éviter l'overflow quand le clavier est ouvert.
            child: ListView(
              children: [
                TextFormField(
                  controller: _name,
                  decoration: InputDecoration(labelText: l10n.name),
                  // validator : retourne un message d'erreur (String) ou null si ok.
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.nameRequired
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _restaurantName,
                  decoration: InputDecoration(labelText: l10n.restaurantName),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _price,
                  decoration: InputDecoration(labelText: l10n.price),
                  // keyboardType indique au téléphone d'afficher un clavier numérique.
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _rating,
                  decoration: InputDecoration(labelText: l10n.rating),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _image,
                  decoration: InputDecoration(labelText: l10n.imageUrl),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  // SwitchListTile = un switch (on/off) avec un label.
                  value: _open,
                  onChanged: (v) => setState(() => _open = v),
                  activeColor: AppStyle.PRIMERYCOLOR,
                  title: Text(l10n.open),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        // Petite animation quand on enregistre.
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(isEdit ? l10n.update : l10n.create),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    // Étape 1 : valider le formulaire.
    if (!_formKey.currentState!.validate()) return;

    // Étape 2 : UI -> état "saving" pour désactiver le bouton et afficher le loader.
    setState(() => _saving = true);
    try {
      final repo = ref.read(foodRepositoryProvider);

      // Conversion des champs numériques.
      // Si l'utilisateur saisit un texte non numérique => null.
      final price = double.tryParse(_price.text.trim());
      final rating = double.tryParse(_rating.text.trim());

      final food = Food(
        id: widget.food?.id ?? '',
        name: _name.text.trim(),
        restaurantName: _restaurantName.text.trim().isEmpty
            ? null
            : _restaurantName.text.trim(),
        price: price,
        rating: rating,
        open: _open,
        image: _image.text.trim().isEmpty ? null : _image.text.trim(),
      );

      if (widget.food == null) {
        // POST /Food
        await repo.createFood(food);
      } else {
        // PUT /Food/{id}
        await repo.updateFood(widget.food!.id, food);
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
