# foodwagen-mobile

# FoodWagen Mobile

---

**FoodWagen** is a Flutter application designed as a maintainable template, easy to understand, and structured around a simple principle: **the UI layer only talks to providers, providers talk to repositories, and repositories consume the `Food` API (MockAPI).**

This README centralizes everything you need to start, understand the architecture, extend the app, and use it as a project base.

---

## 🔍 Why this structure?

- Provide a **clean base** for a Flutter project (layered architecture + DI + state management)
- Show how to structure a project to be **scalable** (new screens, new API resources)
- Set up **best practices**: separation of concerns, state management, local persistence, error handling, and easy-to-add tests.

---

## 🧭 Main flow (how data moves)

1. **UI (views / widgets)** observes/calls a **Riverpod Provider**
2. The **Provider** orchestrates logic (loading, errors, state)
3. The Provider uses a **Repository** (contract + implementation)
4. The **Repository** makes HTTP calls via **Dio** (configured in `ApiService`)
5. JSON responses are mapped to **Models** (`Food`, `Cart`, `User`, ...)

✅ Goal: each layer has a clear responsibility. The UI never makes HTTP requests directly.

---

## 🗂 Project structure

```text
foodwagen/
├── lib/
│   ├── main.dart                 # Entry point (init Env + Dio + Riverpod + MaterialApp)
│   ├── routes/
│   │   └── app_router.dart       # GoRouter navigation + guards + animated transitions
│   ├── providers/                # Riverpod (state + actions)
│   │   ├── auth_provider.dart
│   │   ├── cart_provider.dart
│   │   └── foods_provider.dart
│   ├── repositories/             # Contracts + API access implementations
│   │   ├── food_repository.dart
│   │   └── dio_food_repository.dart
│   ├── services/                 # Technical services (Dio, env, storage, style)
│   │   ├── dio/
│   │   │   └── api_service.dart
│   │   ├── environment/
│   │   │   └── env_service.dart
│   │   ├── storage/
│   │   │   └── secure_storage_service.dart
│   │   ├── routers/
│   │   │   └── routes.dart       # Legacy (not used: GoRouter is the reference)
│   │   └── style.dart            # AppStyle + light/dark themes
│   ├── core/
│   │   ├── errors/
│   │   │   └── exceptions.dart   # Normalized exceptions + Dio -> ApiException mapping
│   │   └── utils/
│   │       └── logger.dart       # AppLogger (centralized logs)
│   ├── l10n/                     # Localization (ARB + generated file)
│   │   ├── app_en.arb
│   │   ├── app_fr.arb
│   │   └── app_localizations.dart
│   ├── models/                   # Models (JSON <-> Dart)
│   ├── views/                    # Screens (UI)
│   └── widgets/                  # Reusable widgets
├── android/
├── ios/
├── web/
├── windows/
├── linux/
├── macos/
└── pubspec.yaml
```

---

## 🧩 Folder details (what and why)

### `lib/main.dart`
- Starts the app
- Loads environment variables via `EnvService`
- Initializes Dio with `ApiService.initialize()`
- Wraps the app in `ProviderScope` (Riverpod)
- Configures `MaterialApp.router` (GoRouter) + themes + localization

### `lib/routes/app_router.dart`
- Defines all routes (ex: `/home`, `/foods`, `/food/new`, `/food/:id/edit`, `/cart`, `/profile`, `/login`)
- Handles **guards** (authentication) for certain routes
- Centralizes **animated transitions** via `CustomTransitionPage`
- `NavigationHelper` helps avoid scattered route strings

### `lib/providers/`
The heart of state management.

- **auth_provider.dart**: authentication + session
- **cart_provider.dart**: cart + local persistence
- **foods_provider.dart**: list + search + loading

Each provider exposes state (loading/error/data) and actions (fetch, add, update, delete).

### `lib/repositories/`
Decouples business logic from HTTP implementation.

- `food_repository.dart`: contract (`abstract class`) with allowed methods
- `dio_food_repository.dart`: concrete implementation (Dio + JSON mapping)

✅ To add a new resource, create an `OrderRepository` + `DioOrderRepository`.

### `lib/services/`
Technical and cross-cutting services.

- `api_service.dart`: Dio configuration (baseUrl, timeout, interceptors, logs)
- `env_service.dart`: `.env` reading
- `secure_storage_service.dart`: secure persistence (token, user, cart)
- `style.dart`: light/dark themes + palette + spacing
- `routes.dart`: old navigation (legacy), not used by GoRouter

### `lib/core/`
- `logger.dart`: wrapper for consistent logging (`AppLogger`)
- `exceptions.dart`: normalized errors (`ApiException`, conversion from `DioException`)

### `lib/models/`
Contains models (JSON ⇄ Dart) used everywhere.

- Ex: `Food`, `Cart`, `CartItem`, `User`, `Restaurant`.
- Some are generated with `json_serializable`, others are parsed “manually” for defensive parsing when JSON is unstable.

### `lib/views/` and `lib/widgets/`
- `views/`: full screens
- `widgets/`: reusable components (cart item, order summary, loader, etc.)

> 💡 Refactoring example: the cart (`cart`) was split into a provider + reusable widgets to separate UI from logic.

---

## 🌐 API (MockAPI)

**Base URL**

`https://6852821e0594059b23cdd834.mockapi.io`

**Endpoints used**

- `GET /Food`
- `GET /Food?name={search}`
- `POST /Food`
- `PUT /Food/{id}`
- `DELETE /Food/{id}`

> ⚠️ The app is intentionally limited to these endpoints to remain a simple and stable template.

---

## 🧠 State management (Riverpod)

- The project uses **Riverpod** for state management.
- Providers expose immutable states (`CartState`, `AuthState`, etc.) and actions.
- Widgets consume these providers via `ref.watch(...)` and `ref.read(...)`.

### Example pattern used

- **Provider** → **StateNotifier** → **State** (immutable)
- **Widget** → watches the state → reactive UI

---

## 🎨 Theme and localization

### Theme
- The app follows the phone theme (`ThemeMode.system`).
- Colors and styles are centralized in `AppStyle` (`services/style.dart`).

### Localization
- Uses `flutter_localizations` + ARB (`lib/l10n/`).
- The app automatically follows the system locale.

---

## 🔧 Important refactoring (cart example)

The initial code was monolithic (a single `cart.dart` file with UI + logic + data), making it hard to maintain.

✅ After refactoring:
- Separate UI (`views/cart/cart_refactored.dart`)
- Centralized state (`providers/cart_provider.dart`)
- Reusable widgets (`widgets/cart_item_card.dart`, `widgets/order_summary.dart`)
- Local cart persistence via `SecureStorageService`

**Advantages**
- better testability
- better reusability
- clear separation of concerns

---

## ✅ Add a new feature (example: `Order`)

1. **Model**: `lib/models/order.dart`
2. **Repository**
   - `lib/repositories/order_repository.dart` (interface)
   - `lib/repositories/dio_order_repository.dart` (implementation)
3. **Provider**: `lib/providers/orders_provider.dart`
4. **UI**
   - `lib/views/order/order_list.dart`
   - `lib/views/order/order_form.dart`
5. **Route**: add in `lib/routes/app_router.dart`

Always follow the flow:
`UI → Provider → Repository → Dio/API → Model`

---

## 🔥 Useful commands

```bash
flutter pub get
flutter gen-l10n
flutter analyze
flutter run
```

### Generate json_serializable models

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🧪 Test structure (unit + widget)

This template is ready for testing: follow the same structure as the source code, with isolated tests for providers and repositories, and widget tests for the UI.

### 📁 Where to place tests
- `test/providers/`: tests for `StateNotifier` / providers (mock repositories)
- `test/repositories/`: tests for implementations (mock Dio / API calls)
- `test/widgets/`: tests for reusable widgets
- `test/views/`: screen tests (widget tests with navigation, providers, etc.)

### 🧩 Example unit test (provider)
- Create a `cart_provider_test.dart` that instantiates `CartNotifier` and calls its methods.
- Use `mocktail`/`mockito` to mock `FoodRepository` or `SecureStorageService` if needed.

### 🧪 Example widget test
- Use `WidgetTester` + `pumpWidget`.
- Wrap with `ProviderScope` (and optionally `MaterialApp.router` or `GoRouter`) to provide the providers.
- Check for UI elements, `loading`/`error` states, and interactions (tap, scroll, etc.).

### ✅ Test commands
```bash
flutter test                 # run all tests
flutter test test/providers/cart_provider_test.dart
flutter test test/widgets/cart_item_card_test.dart
```

> 💡 Tip: in unit tests, prefer mocking dependencies (repository, storage) rather than making real network calls.

---

## �🧰 Conseils pour utiliser ce template

- Évite de mettre de la logique métier dans les widgets.
- Préfère exposer des actions dans les providers plutôt que des variables globales.
- Écris des tests pour les providers / repositories (ils sont très faciles à isoler).
- Garde le routing dans `app_router.dart` et utilise `NavigationHelper` pour éviter les strings magiques.

---

## 📌 Remarque

Ce README contient toutes les informations nécessaires pour comprendre l’architecture et faire évoluer le projet. Tu peux aussi consulter `README_EXPLICATION.md` pour une explication plus pédagogique (dossier par dossier) si tu veux approfondir.
