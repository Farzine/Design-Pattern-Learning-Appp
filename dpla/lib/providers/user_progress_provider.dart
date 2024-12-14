// lib/providers/user_progress_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dpla/models/user_progress.dart';
import 'package:dpla/repositories/user_progress_repository.dart';
import 'package:dio/dio.dart';

// Provider for Dio instance
final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

// Provider for UserProgressRepository
final userProgressRepositoryProvider = Provider<UserProgressRepository>((ref) {
  return UserProgressRepository(ref.watch(dioProvider));
});

// StateNotifier for managing user progress state
class UserProgressState {
  final List<UserProgress> progress;
  final bool isLoading;
  final String? error;

  UserProgressState({
    this.progress = const [],
    this.isLoading = false,
    this.error,
  });

  UserProgressState copyWith({
    List<UserProgress>? progress,
    bool? isLoading,
    String? error,
  }) {
    return UserProgressState(
      progress: progress ?? this.progress,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class UserProgressNotifier extends StateNotifier<UserProgressState> {
  final UserProgressRepository _repository;

  UserProgressNotifier(this._repository) : super(UserProgressState()) {
    fetchUserProgress();
  }

  /// Fetches all user progress entries.
  Future<void> fetchUserProgress() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final progress = await _repository.fetchAllUserProgress();
      state = state.copyWith(progress: progress, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// Fetches progress for a specific design pattern.
  Future<void> fetchProgressByDesignPattern(String patternId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final progress = await _repository.fetchProgressByDesignPattern(patternId);
      state = state.copyWith(progress: [progress], isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}

// Provider for UserProgressNotifier
final userProgressProvider = StateNotifierProvider<UserProgressNotifier, UserProgressState>((ref) {
  return UserProgressNotifier(ref.watch(userProgressRepositoryProvider));
});
