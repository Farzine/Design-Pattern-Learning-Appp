// lib/providers/comment_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dpla/repositories/comment_repository.dart';
import 'package:dio/dio.dart';

final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  return CommentRepository(Dio());
});

final commentProvider = Provider((ref) => CommentNotifier(ref.watch(commentRepositoryProvider)));

class CommentNotifier {
  final CommentRepository _repository;
  CommentNotifier(this._repository);

  Future<void> commentOnPost(String postId, String content) async {
    await _repository.commentOnPost(postId, content);
  }
}
