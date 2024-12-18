// // lib/providers/user_provider.dart

// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../core/token_storage.dart';
// import '../models/user.dart';
// import '../repositories/user_repository.dart';

// // Define the state for the user
// class UserState {
//   final User? user;
//   final List<User> following;
//   final bool isLoading;
//   final bool isUpdating;
//   final String? error;

//   UserState({
//     this.user,
//     this.following = const [],
//     this.isLoading = false,
//     this.isUpdating = false,
//     this.error,
//   });

//   UserState copyWith({
//     User? user,
//     List<User>? following,
//     bool? isLoading,
//     bool? isUpdating,
//     String? error,
//   }) {
//     return UserState(
//       user: user ?? this.user,
//       following: following ?? this.following,
//       isLoading: isLoading ?? this.isLoading,
//       isUpdating: isUpdating ?? this.isUpdating,
//       error: error,
//     );
//   }
// }

// // Provider for UserRepository
// final userRepositoryProvider = Provider<UserRepository>((ref) {
//   return UserRepository(Dio());
// });

// // StateNotifier for UserState
// final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
//   return UserNotifier(ref.watch(userRepositoryProvider));
// });

// class UserNotifier extends StateNotifier<UserState> {
//   final UserRepository _repository;

//   UserNotifier(this._repository) : super(UserState()) {
//     loadUserProfile();
//   }

//   /// Loads the current user's profile and following list.
//   Future<void> loadUserProfile() async {
//     state = state.copyWith(isLoading: true, error: null);
//     try {
//       final user = await _repository.fetchUserProfile();
//       final following = await _repository.fetchFollowing(user.id);
//       state = state.copyWith(user: user, following: following, isLoading: false);
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//     }
//   }

//   /// Updates the current user's profile.
//   Future<void> updateProfile({
//     required String name,
//     required String email,
//     DateTime? birthdate,
//     required double latitude,
//     required double longitude,
//   }) async {
//     state = state.copyWith(isUpdating: true, error: null);
//     try {
//       if (state.user == null) {
//         throw Exception('No user logged in');
//       }
//       String userId = state.user!.id;
//       await _repository.updateUserProfile(
//         userId: userId,
//         name: name,
//         email: email,
//         birthdate: birthdate,
//         latitude: latitude,
//         longitude: longitude,
//       );
//       await loadUserProfile();
//     } catch (e) {
//       state = state.copyWith(isUpdating: false, error: e.toString());
//     }
//   }

//   /// Unfollows a user by their user ID.
//   Future<void> unfollowUser(String targetUserId) async {
//     try {
//       if (state.user == null) {
//         throw Exception('No user logged in');
//       }
//       String userId = state.user!.id;
//       await _repository.unfollowUser(userId, targetUserId);
//       // Remove the unfollowed user from the following list
//       state = state.copyWith(
//         following: state.following.where((user) => user.id != targetUserId).toList(),
//       );
//     } catch (e) {
//       state = state.copyWith(error: e.toString());
//     }
//   }

//   /// Follows a user by their user ID.
//   Future<void> followUser(String targetUserId) async {
//     try {
//       if (state.user == null) {
//         throw Exception('No user logged in');
//       }
//       String userId = state.user!.id;
//       await _repository.followUser(userId, targetUserId);
//       // Reload the following list to include the newly followed user
//       await loadUserProfile();
//     } catch (e) {
//       state = state.copyWith(error: e.toString());
//     }
//   }
//   /// Signs out the user by deleting the token and resetting the state.
//   Future<void> signOut() async {
//     await TokenStorage.deleteToken();
//     state = UserState();
//   }
// }

// lib/providers/user_provider.dart
import 'package:dpla/core/token_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dpla/repositories/user_repository.dart';
import 'package:dio/dio.dart';
import 'package:dpla/models/user.dart';
import 'package:dpla/models/user_suggestion.dart';

// USER REPOSITORY PROVIDER
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(Dio());
});

// STATE FOR CURRENT USER (LOGGED IN USER)
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

// PROVIDER FOR CURRENT USER STATE
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

// USER LIST STATE (FOR FRIEND SUGGESTIONS)
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

// USER PROFILE STATE FOR FETCHING A SINGLE USER BY ID
class UserProfileState {
  final UserSuggestion? user;
  final bool isLoading;
  final String? error;

  UserProfileState({this.user, this.isLoading = false, this.error});
}

// PROVIDER FOR FETCHING A SINGLE USER BY ID
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
      await _repo.followUser('currentUserId', userId); // Replace 'currentUserId' with actual logic if needed.
      await loadUser();
    } catch (e) {
      state = UserProfileState(error: e.toString(), user: state.user);
    }
  }

  Future<void> unfollowUser() async {
    try {
      await _repo.unfollowUser('currentUserId', userId); // Replace 'currentUserId' with actual logic if needed.
      await loadUser();
    } catch (e) {
      state = UserProfileState(error: e.toString(), user: state.user);
    }
  }
}
