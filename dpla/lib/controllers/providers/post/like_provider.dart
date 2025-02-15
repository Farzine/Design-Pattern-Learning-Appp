// lib/providers/like_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dpla/models/repositories/post/like_repository.dart';
import 'package:dio/dio.dart';

final likeRepositoryProvider = Provider<LikeRepository>((ref) {
  return LikeRepository(Dio());
});

final likeProvider = Provider((ref) => LikeNotifier(ref.watch(likeRepositoryProvider)));

class LikeNotifier {
  final LikeRepository _repository;
  LikeNotifier(this._repository);

  Future<void> likePost(String postId) async {
    await _repository.likePost(postId);
  }
}
