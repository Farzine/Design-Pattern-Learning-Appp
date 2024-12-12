// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:design_patterns_app/models/practice_question.dart';
// import 'package:design_patterns_app/repositories/practice_repository.dart';
// import 'package:dio/dio.dart';
// import 'package:design_patterns_app/core/exceptions.dart';

// // Define the state for practice
// class PracticeState {
//   final List<PracticeQuestion> questions;
//   final bool isLoading;
//   final bool isSubmitting;
//   final String? feedback;
//   final String? error;

//   PracticeState({
//     this.questions = const [],
//     this.isLoading = false,
//     this.isSubmitting = false,
//     this.feedback,
//     this.error,
//   });

//   PracticeState copyWith({
//     List<PracticeQuestion>? questions,
//     bool? isLoading,
//     bool? isSubmitting,
//     String? feedback,
//     String? error,
//   }) {
//     return PracticeState(
//       questions: questions ?? this.questions,
//       isLoading: isLoading ?? this.isLoading,
//       isSubmitting: isSubmitting ?? this.isSubmitting,
//       feedback: feedback,
//       error: error,
//     );
//   }
// }

// // Provider for PracticeRepository
// final practiceRepositoryProvider = Provider<PracticeRepository>((ref) {
//   return PracticeRepository(Dio());
// });

// // StateNotifier for PracticeState
// final practiceProvider = StateNotifierProvider.family<PracticeNotifier, PracticeState, String>((ref, patternId) {
//   return PracticeNotifier(ref.watch(practiceRepositoryProvider), patternId);
// });

// class PracticeNotifier extends StateNotifier<PracticeState> {
//   final PracticeRepository _repository;
//   final String patternId;

//   PracticeNotifier(this._repository, this.patternId) : super(PracticeState()) {
//     loadPracticeQuestions();
//   }

//   Future<void> loadPracticeQuestions() async {
//     state = state.copyWith(isLoading: true, error: null);
//     try {
//       final questions = await _repository.fetchPracticeQuestions(patternId);
//       state = state.copyWith(questions: questions, isLoading: false);
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//     }
//   }

//   Future<void> submitAnswers(Map<int, String> answers) async {
//     state = state.copyWith(isSubmitting: true, error: null, feedback: null);
//     try {
//       final feedback = await _repository.submitAnswers(patternId, answers);
//       state = state.copyWith(isSubmitting: false, feedback: feedback);
//     } catch (e) {
//       state = state.copyWith(isSubmitting: false, error: e.toString());
//     }
//   }
// }
