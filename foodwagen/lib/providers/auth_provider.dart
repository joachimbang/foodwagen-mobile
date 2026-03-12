import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodwagen/models/user.dart';
import 'package:foodwagen/services/storage/secure_storage_service.dart';
import 'package:foodwagen/core/utils/logger.dart';

// Gestion de l'authentification (Riverpod).
//
// Remarque : dans ce projet, l'auth est encore "mockée" (pas d'API réelle).
// On persiste tout de même un token + user en SecureStorage pour simuler une session.
class AuthState {
  final User? user;
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;

  AuthState({
    this.user,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    bool? isAuthenticated,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState()) {
    // Au démarrage, on tente de restaurer une session (token + user) depuis le stockage.
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    state = state.copyWith(isLoading: true);

    try {
      final hasToken = await SecureStorageService.hasToken();
      if (hasToken) {
        final userData = await SecureStorageService.getUserData();
        if (userData != null) {
          final user = User.fromJson(userData);
          state = state.copyWith(
            user: user,
            isAuthenticated: true,
            isLoading: false,
          );
          return;
        }
      }

      state = state.copyWith(isLoading: false);
    } catch (e) {
      AppLogger.error('Failed to initialize auth', error: e);
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to initialize authentication',
      );
    }
  }

  Future<void> login(String email, String password) async {
    // Pattern standard :
    // - isLoading=true
    // - appel réseau (ou mock)
    // - succès => user + isAuthenticated
    // - erreur => message
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock successful login
      final mockUser = User(
        id: 1,
        firstName: 'John',
        lastName: 'Doe',
        email: email,
        phoneNumber: '+1234567890',
        addresses: [],
        paymentMethods: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await SecureStorageService.storeToken('mock_token');
      await SecureStorageService.storeUserData(mockUser.toJson());

      state = state.copyWith(
        user: mockUser,
        isAuthenticated: true,
        isLoading: false,
      );

      AppLogger.info('User logged in successfully');
    } catch (e) {
      AppLogger.error('Login failed', error: e);
      state = state.copyWith(
        isLoading: false,
        error: 'Login failed: ${e.toString()}',
      );
    }
  }

  Future<void> register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    // Identique à login() mais pour l'inscription.
    // Pour l'instant c'est une simulation locale.
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock successful registration
      final mockUser = User(
        id: 1,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: '+1234567890',
        addresses: [],
        paymentMethods: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await SecureStorageService.storeToken('mock_token');
      await SecureStorageService.storeUserData(mockUser.toJson());

      state = state.copyWith(
        user: mockUser,
        isAuthenticated: true,
        isLoading: false,
      );

      AppLogger.info('User registered successfully');
    } catch (e) {
      AppLogger.error('Registration failed', error: e);
      state = state.copyWith(
        isLoading: false,
        error: 'Registration failed: ${e.toString()}',
      );
    }
  }

  Future<void> logout() async {
    // Déconnexion = suppression token + user et remise à zéro de l'état.
    state = state.copyWith(isLoading: true);

    try {
      await SecureStorageService.removeToken();
      await SecureStorageService.removeUserData();

      state = AuthState(isLoading: false);

      AppLogger.info('User logged out successfully');
    } catch (e) {
      AppLogger.error('Logout failed', error: e);
      state = state.copyWith(
        isLoading: false,
        error: 'Logout failed: ${e.toString()}',
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider principal : donne accès à l'état d'auth + aux actions (login/register/logout).
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// Expose uniquement l'utilisateur (pratique pour l'UI).
final userProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

// Expose uniquement le bool d'auth (pratique pour le router et les guards).
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});
