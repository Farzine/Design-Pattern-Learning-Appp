// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:design_patterns_app/models/message.dart';
// import 'package:design_patterns_app/repositories/message_repository.dart';
// import 'package:dio/dio.dart';
// import 'package:design_patterns_app/core/exceptions.dart';

// // Define the state for messages
// class MessageState {
//   final List<Message> messages;
//   final bool isLoading;
//   final bool isSending;
//   final String? error;

//   MessageState({
//     this.messages = const [],
//     this.isLoading = false,
//     this.isSending = false,
//     this.error,
//   });

//   MessageState copyWith({
//     List<Message>? messages,
//     bool? isLoading,
//     bool? isSending,
//     String? error,
//   }) {
//     return MessageState(
//       messages: messages ?? this.messages,
//       isLoading: isLoading ?? this.isLoading,
//       isSending: isSending ?? this.isSending,
//       error: error,
//     );
//   }
// }

// // Provider for MessageRepository
// final messageRepositoryProvider = Provider<MessageRepository>((ref) {
//   return MessageRepository(Dio());
// });

// // StateNotifier for MessageState
// final messageProvider = StateNotifierProvider.family<MessageNotifier, MessageState, String>((ref, chatWithUserId) {
//   return MessageNotifier(ref.watch(messageRepositoryProvider), chatWithUserId);
// });

// class MessageNotifier extends StateNotifier<MessageState> {
//   final MessageRepository _repository;
//   final String chatWithUserId;

//   MessageNotifier(this._repository, this.chatWithUserId) : super(MessageState()) {
//     loadMessages();
//   }

//   Future<void> loadMessages() async {
//     state = state.copyWith(isLoading: true, error: null);
//     try {
//       final messages = await _repository.fetchMessages(chatWithUserId);
//       state = state.copyWith(messages: messages.reversed.toList(), isLoading: false);
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//     }
//   }

//   Future<void> sendMessage(String content) async {
//     state = state.copyWith(isSending: true, error: null);
//     try {
//       final message = await _repository.sendMessage(chatWithUserId, content);
//       state = state.copyWith(
//         messages: [message, ...state.messages],
//         isSending: false,
//       );
//     } catch (e) {
//       state = state.copyWith(isSending: false, error: e.toString());
//     }
//   }
// }
