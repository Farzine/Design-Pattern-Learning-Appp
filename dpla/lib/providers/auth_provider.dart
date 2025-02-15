import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dpla/repositories/auth_repository.dart';
import 'package:dpla/models/user.dart';
import 'package:dpla/core/api_client.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({User? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

/// Provides the AuthRepository instance, injecting the Dio client from ApiClient.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepository(apiClient.client);
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(AuthState());

  final AuthRepository _repository;

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authResponse = await _repository.login(email: email, password: password);
      state = state.copyWith(user: authResponse.user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Registers a new user.
  Future<void> register(String name, String email, String password, DateTime birthdate, double lat, double lng) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authResponse = await _repository.register(
        name: name,
        email: email,
        password: password,
        birthdate: birthdate,
        latitude: lat,
        longitude: lng,
      );
      state = state.copyWith(user: authResponse.user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      throw e;
    }
  }

  /// Logs out the user.
  Future<void> logout() async {
    try {
      await _repository.logout();
      state = AuthState();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
