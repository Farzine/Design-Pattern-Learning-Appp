import 'package:dpla/core/token_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dpla/repositories/user_repository.dart';
import 'package:dio/dio.dart';
import 'package:dpla/models/user.dart';
import 'package:dpla/models/user_suggestion.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(Dio());
});

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

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(ref.watch(userRepositoryProvider));
});

class UserNotifier extends StateNotifier<UserState> {
  final UserRepository _repository;

  UserNotifier(this._repository) : super(UserState()) {
    loadUserProfile();
  }

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

  Future<void> updateProfile({
    required String name,
    required String email,
    DateTime? birthdate,
    required double latitude,
    required double longitude,
  }) async {
    state = state.copyWith(isUpdating: true, error: null);
    try {
      await _repository.updateUserProfile(
        userId: state.user!.id,
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

  Future<void> followUser(String targetUserId) async {
    try {
      await _repository.followUser(state.user!.id, targetUserId);
      await loadUserProfile();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> unfollowUser(String targetUserId) async {
    try {
      await _repository.unfollowUser(state.user!.id, targetUserId);
      state = state.copyWith(
        following: state.following.where((u) => u.id != targetUserId).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> signOut() async {
    await TokenStorage.deleteToken();
    state = UserState();
  }
}

class UserListState {
  final List<UserSuggestion> users;
  final bool isLoading;
  final String? error;

  UserListState({this.users = const [], this.isLoading = false, this.error});

  UserListState copyWith({List<UserSuggestion>? users, bool? isLoading, String? error}) {
    return UserListState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// PROVIDER FOR FETCHING ALL USERS
final userListProvider = StateNotifierProvider<UserListNotifier, UserListState>((ref) {
  return UserListNotifier(ref.watch(userRepositoryProvider));
});

class UserListNotifier extends StateNotifier<UserListState> {
  final UserRepository _repo;

  UserListNotifier(this._repo) : super(UserListState()) {
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final users = await _repo.fetchUsers();
      state = state.copyWith(users: users, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

class UserProfileState {
  final UserSuggestion? user;
  final bool isLoading;
  final String? error;

  UserProfileState({this.user, this.isLoading = false, this.error});
}


final userProfileProvider =
    StateNotifierProvider.family<UserProfileNotifier, UserProfileState, String>((ref, userId) {
  return UserProfileNotifier(ref.watch(userRepositoryProvider), userId);
});

class UserProfileNotifier extends StateNotifier<UserProfileState> {
  final UserRepository _repo;
  final String userId;

  UserProfileNotifier(this._repo, this.userId) : super(UserProfileState()) {
    loadUser();
  }

  Future<void> loadUser() async {
    state = UserProfileState(isLoading: true);
    try {
      final user = await _repo.fetchUserById(userId);
      state = UserProfileState(user: user, isLoading: false);
    } catch (e) {
      state = UserProfileState(error: e.toString());
    }
  }

  Future<void> followUser() async {
    try {
      await _repo.followUser('currentUserId', userId); 
      await loadUser();
    } catch (e) {
      state = UserProfileState(error: e.toString(), user: state.user);
    }
  }

  Future<void> unfollowUser() async {
    try {
      await _repo.unfollowUser('currentUserId', userId); 
      await loadUser();
    } catch (e) {
      state = UserProfileState(error: e.toString(), user: state.user);
    }
  }
}
