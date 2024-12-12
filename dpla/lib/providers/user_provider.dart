// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:design_patterns_app/models/user.dart';
// import 'package:design_patterns_app/repositories/user_repository.dart';
// import 'package:dio/dio.dart';

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

//   Future<void> loadUserProfile() async {
//     state = state.copyWith(isLoading: true, error: null);
//     try {
//       // Assuming the user ID is stored or can be fetched from the token
//       // For simplicity, let's assume the user ID is available in the state.user
//       // Alternatively, implement a method to get current user ID
//       // Here, we fetch the token and extract user ID if encoded
//       // For now, let's assume the user ID is known or fetched elsewhere
//       // Replace 'currentUserId' with actual logic
//       String? token = await _repository._dio.options.headers['Authorization'];
//       // Decode token to get user ID or implement a /me endpoint
//       // Here, assuming a '/me' endpoint exists to fetch current user
//       // Adjust accordingly
//       // For demonstration, we'll use userId as 'currentUserId'
//       String userId = 'currentUserId'; // Replace with actual user ID
//       final user = await _repository.fetchUserProfile(userId);
//       final following = await _repository.fetchFollowing(userId);
//       state = state.copyWith(user: user, following: following, isLoading: false);
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//     }
//   }

//   Future<void> updateProfile({
//     required String name,
//     required String email,
//     DateTime? birthdate,
//     required double latitude,
//     required double longitude,
//     String? profilePictureUrl,
//   }) async {
//     state = state.copyWith(isUpdating: true, error: null);
//     try {
//       String userId = state.user!.id;
//       await _repository.updateUserProfile(
//         userId: userId,
//         name: name,
//         email: email,
//         birthdate: birthdate,
//         latitude: latitude,
//         longitude: longitude,
//         profilePictureUrl: profilePictureUrl,
//       );
//       await loadUserProfile();
//     } catch (e) {
//       state = state.copyWith(isUpdating: false, error: e.toString());
//     }
//   }

//   Future<void> unfollowUser(String targetUserId) async {
//     try {
//       String userId = state.user!.id;
//       await _repository.unfollowUser(userId, targetUserId);
//       // Remove from following list
//       state = state.copyWith(
//         following: state.following.where((user) => user.id != targetUserId).toList(),
//       );
//     } catch (e) {
//       state = state.copyWith(error: e.toString());
//     }
//   }

//   // Similarly, implement followUser if needed
// }
