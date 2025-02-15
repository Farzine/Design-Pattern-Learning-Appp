import 'package:dpla/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dpla/models/design_pattern.dart';
import 'package:dpla/repositories/design_pattern_repository.dart';

class DesignPatternState {
  final List<DesignPattern> patterns;
  final bool isLoading;
  final String? error;

  DesignPatternState({
    this.patterns = const [],
    this.isLoading = false,
    this.error,
  });

  DesignPatternState copyWith({
    List<DesignPattern>? patterns,
    bool? isLoading,
    String? error,
  }) {
    return DesignPatternState(
      patterns: patterns ?? this.patterns,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Provider for DesignPatternRepository
final designPatternRepositoryProvider = Provider<DesignPatternRepository>((ref) {
  return DesignPatternRepository(ref.watch(apiClientProvider).client);
});

// StateNotifier for DesignPatternState
final designPatternProvider =
    StateNotifierProvider<DesignPatternNotifier, DesignPatternState>((ref) {
  return DesignPatternNotifier(ref.watch(designPatternRepositoryProvider));
});

class DesignPatternNotifier extends StateNotifier<DesignPatternState> {
  final DesignPatternRepository _repository;

  DesignPatternNotifier(this._repository) : super(DesignPatternState()) {
    loadDesignPatterns();
  }

  Future<void> loadDesignPatterns() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final patterns = await _repository.fetchDesignPatterns();
      state = state.copyWith(patterns: patterns, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Searches design patterns based on a query string.
  Future<void> searchDesignPatterns(String query) async {
    if (query.isEmpty) {
      await loadDesignPatterns();
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await _repository.searchDesignPatterns(query);
      state = state.copyWith(patterns: results, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

}
