# FoodWagen — README d’explication (architecture + dossiers + extensions)

Ce document explique **comment l’app est structurée**, **pourquoi** elle est organisée ainsi, et **comment l’étendre** (API, écrans, providers, modèles, thème, i18n, animations).

## 1) Vue d’ensemble (le flux principal)

Dans cette app, le flux recommandé est :

- **UI (screens/widgets)**
- appelle/observe des **Providers Riverpod**
- qui utilisent des **Repositories**
- qui utilisent **Dio** (configuré une fois dans `ApiService`)
- et renvoient des **Models** (ex: `Food`) à l’UI.

Objectif : **séparer les responsabilités**.

- L’UI ne fait pas de requêtes HTTP.
- Le repository ne connaît pas les widgets.
- Les models centralisent le mapping JSON ⇄ Dart.

## 2) Arborescence expliquée

### `lib/main.dart`
- Point d’entrée.
- Charge `.env` via `EnvService`.
- Initialise Dio via `ApiService.initialize()`.
- Démarre Riverpod (`ProviderScope`).
- Configure `MaterialApp.router`.
- Configure **thème système** et **localisation**.

### `lib/routes/app_router.dart`
- Routing central via **GoRouter**.
- Déclare toutes les routes (`/home`, `/foods`, `/food/new`, `/food/:id/edit`, `/cart`, `/profile`, ...).
- Met en place un **guard** simple : si non authentifié, accès à `/cart` et `/profile` redirige vers `/login`.
- Contient `NavigationHelper` (helpers pour éviter les strings partout).
- Contient des **transitions animées** de navigation (voir section animations).

### `lib/providers/`
Le dossier `providers` est le point central du **state management** (Riverpod).

- `auth_provider.dart`
  - `AuthState` : user/isLoading/isAuthenticated/error
  - `AuthNotifier` : `login`, `register`, `logout`, restauration session
  - Providers :
    - `authProvider`
    - `userProvider`
    - `isAuthenticatedProvider`

- `cart_provider.dart`
  - `CartState` : cart/isLoading/error
  - `CartNotifier` : `loadCart`, `addToCart`, `removeFromCart`, `updateQuantity`, `clearCart`
  - Persistance via `SecureStorageService` (JSON)
  - Providers :
    - `cartProvider`
    - `cartItemsProvider`, `cartTotalProvider`, `cartItemCountProvider`

- `foods_provider.dart`
  - `foodRepositoryProvider` : injection de dépendance (interface `FoodRepository`)
  - `foodsProvider` : `FutureProvider.family` (chargement + recherche)

### `lib/repositories/`
- `food_repository.dart`
  - Interface (contrat) : méthodes autorisées côté API Food.

- `dio_food_repository.dart`
  - Implémentation avec Dio.
  - Mappe les endpoints MockAPI autorisés :
    - GET `/Food`
    - GET `/Food?name=...`
    - POST `/Food`
    - PUT `/Food/{id}`
    - DELETE `/Food/{id}`

### `lib/services/`
- `services/dio/api_service.dart`
  - Configure Dio (baseUrl, timeouts, interceptors/log).
  - Centralise la config HTTP.

- `services/environment/env_service.dart`
  - Charge `.env`.

- `services/storage/secure_storage_service.dart`
  - Persistance locale (token, user, cart) via `flutter_secure_storage`.

- `services/style.dart`
  - `AppStyle` : couleurs/spacing/radius.
  - Fournit `lightTheme()` et `darkTheme()`.

- `services/routers/routes.dart`
  - Fichier legacy (ancienne navigation via `Navigator`).
  - Dans cette app : **GoRouter** est la source de vérité.

### `lib/models/`
- `food.dart`
  - Modèle principal consommé par l’API.
  - Parsing manuel “défensif” (MockAPI peut renvoyer des types incohérents).

- `cart.dart`, `user.dart`, `restaurant.dart`
  - Modèles “template” + persistance.
  - Utilisent `json_serializable` ⇒ fichiers `*.g.dart` générés.

### `lib/core/`
- `core/utils/logger.dart`
  - Wrapper `AppLogger` autour du package `logger`.
  - But : logs cohérents, centralisés.

- `core/errors/exceptions.dart`
  - Exceptions normalisées côté app.
  - `ApiException.fromDioError()` mappe `DioException` ⇒ message user-friendly.

### `lib/views/` et `lib/widgets/`
- `views/` : écrans (pages)
- `widgets/` : composants réutilisables

Les écrans importants côté API Food :
- `views/food/food_list.dart` : liste + recherche + delete + navigation
- `views/food/food_form.dart` : create/update

## 3) Pourquoi `json_serializable` parfois oui / parfois non

### Recommandé (`json_serializable`)
- JSON stable et bien typé
- beaucoup de modèles
- persistance locale (SecureStorage)

### Préférer parsing manuel
- JSON “sale” ou instable (types variables, clés incohérentes)
- besoin de parsing défensif

Exemple : `Food` est en parsing manuel car MockAPI peut renvoyer `rating` sous plusieurs types et la clé `Price` est atypique.

## 4) Pourquoi `copyWith` dans les models

`copyWith` sert à créer une **nouvelle instance** en changeant 1 ou 2 champs, sans muter l’objet.

- Très utile avec Riverpod/StateNotifier.
- Permet de reconstruire un `Cart` ou `CartItem` modifié sans recopier tous les champs à la main.

## 5) Thème (Theming) — suivre le thème du téléphone

L’app est configurée pour :
- fournir un **thème clair** (`theme`)
- fournir un **thème sombre** (`darkTheme`)
- et utiliser `ThemeMode.system` ⇒ suit automatiquement le réglage du téléphone.

Les couleurs/valeurs viennent de `AppStyle`.

## 6) Multilangue (i18n) — suivre la langue du téléphone

Mise en place via :
- `flutter_localizations`
- fichiers ARB dans `lib/l10n/`
- génération automatique Flutter (`flutter gen-l10n`)

L’app suit la locale système (langue du téléphone). Les widgets Material (date picker, boutons système, etc.) se localisent automatiquement une fois les delegates activés.

## 7) Animations

- Animations de transition entre pages : gérées par GoRouter via `CustomTransitionPage`.
- Objectif : transitions douces sans modifier la logique.

## 8) Commandes utiles

### Générer les fichiers `*.g.dart` (json_serializable)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Regénérer les fichiers de localisation
- Automatique via `flutter generate: true` + build, mais tu peux forcer :
```bash
flutter gen-l10n
```

### Analyse statique
```bash
flutter analyze
```

## 9) Comment ajouter une nouvelle feature “proprement”

Exemple : ajouter une ressource `Order` consommée via API.

- **Model** : `lib/models/order.dart`
- **Repository** :
  - interface `order_repository.dart`
  - implémentation `dio_order_repository.dart`
- **Provider** : `orders_provider.dart` (FutureProvider/Notifier)
- **UI** : `views/order/order_list.dart`, `views/order/order_form.dart`
- **Router** : ajouter routes dans `app_router.dart`

Toujours garder le flux : UI → Provider → Repository → Dio/API → Model.
