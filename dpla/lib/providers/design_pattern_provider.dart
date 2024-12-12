// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:design_patterns_app/models/design_pattern.dart';
// import 'package:design_patterns_app/repositories/design_pattern_repository.dart';
// import 'package:dio/dio.dart';
// import 'package:design_patterns_app/core/exceptions.dart';

// // Define the state for design patterns
// class DesignPatternState {
//   final List<DesignPattern> patterns;
//   final bool isLoading;
//   final String? error;

//   DesignPatternState({
//     this.patterns = const [],
//     this.isLoading = false,
//     this.error,
//   });

//   DesignPatternState copyWith({
//     List<DesignPattern>? patterns,
//     bool? isLoading,
//     String? error,
//   }) {
//     return DesignPatternState(
//       patterns: patterns ?? this.patterns,
//       isLoading: isLoading ?? this.isLoading,
//       error: error,
//     );
//   }
// }

// // Provider for DesignPatternRepository
// final designPatternRepositoryProvider = Provider<DesignPatternRepository>((ref) {
//   return DesignPatternRepository(Dio());
// });

// // StateNotifier for DesignPatternState
// final designPatternProvider = StateNotifierProvider<DesignPatternNotifier, DesignPatternState>((ref) {
//   return DesignPatternNotifier(ref.watch(designPatternRepositoryProvider));
// });

// class DesignPatternNotifier extends StateNotifier<DesignPatternState> {
//   final DesignPatternRepository _repository;

//   DesignPatternNotifier(this._repository) : super(DesignPatternState()) {
//     loadDesignPatterns();
//   }

//   Future<void> loadDesignPatterns() async {
//     state = state.copyWith(isLoading: true, error: null);
//     try {
//       final patterns = await _repository.fetchDesignPatterns();
//       state = state.copyWith(patterns: patterns, isLoading: false);
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//     }
//   }
// }
