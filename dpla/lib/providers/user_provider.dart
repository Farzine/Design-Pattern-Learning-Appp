// lib/providers/user_provider.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/token_storage.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';

// Define the state for the user
class UserState {
  final User? user;
  final List<User> following;
  final bool isLoading;
  final bool isUpdating;
  final String? error;

  UserState({
    this.user,
    this.following = const [],
    this.isLoading = false,
    this.isUpdating = false,
    this.error,
  });

  UserState copyWith({
    User? user,
    List<User>? following,
    bool? isLoading,
    bool? isUpdating,
    String? error,
  }) {
    return UserState(
      user: user ?? this.user,
      following: following ?? this.following,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      error: error,
    );
  }
}

// Provider for UserRepository
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(Dio());
});

// StateNotifier for UserState
final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(ref.watch(userRepositoryProvider));
});

class UserNotifier extends StateNotifier<UserState> {
  final UserRepository _repository;

  UserNotifier(this._repository) : super(UserState()) {
    loadUserProfile();
  }

  /// Loads the current user's profile and following list.
  Future<void> loadUserProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repository.fetchUserProfile();
      final following = await _repository.fetchFollowing(user.id);
      state = state.copyWith(user: user, following: following, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Updates the current user's profile.
  Future<void> updateProfile({
    required String name,
    required String email,
    DateTime? birthdate,
    required double latitude,
    required double longitude,
  }) async {
    state = state.copyWith(isUpdating: true, error: null);
    try {
      if (state.user == null) {
        throw Exception('No user logged in');
      }
      String userId = state.user!.id;
      await _repository.updateUserProfile(
        userId: userId,
        name: name,
        email: email,
        birthdate: birthdate,
        latitude: latitude,
        longitude: longitude,
      );
      await loadUserProfile();
    } catch (e) {
      state = state.copyWith(isUpdating: false, error: e.toString());
    }
  }

  /// Unfollows a user by their user ID.
  Future<void> unfollowUser(String targetUserId) async {
    try {
      if (state.user == null) {
        throw Exception('No user logged in');
      }
      String userId = state.user!.id;
      await _repository.unfollowUser(userId, targetUserId);
      // Remove the unfollowed user from the following list
      state = state.copyWith(
        following: state.following.where((user) => user.id != targetUserId).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Follows a user by their user ID.
  Future<void> followUser(String targetUserId) async {
    try {
      if (state.user == null) {
        throw Exception('No user logged in');
      }
      String userId = state.user!.id;
      await _repository.followUser(userId, targetUserId);
      // Reload the following list to include the newly followed user
      await loadUserProfile();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
  /// Signs out the user by deleting the token and resetting the state.
  Future<void> signOut() async {
    await TokenStorage.deleteToken();
    state = UserState();
  }
}
