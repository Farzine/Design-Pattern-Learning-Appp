import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dpla/models/post.dart';
import 'package:dpla/repositories/post_repository.dart';
import 'package:dio/dio.dart';

// State of the Post feed
class PostFeedState {
  final List<Post> posts;
  final bool isLoading;
  final String? error;

  PostFeedState({this.posts = const [], this.isLoading = false, this.error});

  PostFeedState copyWith({List<Post>? posts, bool? isLoading, String? error}) {
    return PostFeedState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Provider for PostRepository
final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository(Dio());
});

// StateNotifier for PostFeedState
final postFeedProvider =
    StateNotifierProvider<PostFeedNotifier, PostFeedState>((ref) {
  return PostFeedNotifier(ref.watch(postRepositoryProvider));
});

class PostFeedNotifier extends StateNotifier<PostFeedState> {
  final PostRepository _repository;

  PostFeedNotifier(this._repository) : super(PostFeedState()) {
    loadFeed();
  }

  Future<void> loadFeed() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final posts = await _repository.fetchFeed(page: 1, limit: 10);
      state = state.copyWith(posts: posts, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> likePost(String postId) async {
    try {
      await _repository.likePost(postId);
      await loadFeed();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      
    }
  }

  Future<void> commentOnPost(String postId, String content) async {
    try {
      await _repository.commentOnPost(postId, content);
      await loadFeed();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> createPost(String content) async {
  try {
    await _repository.createPost(content);
    // After posting, reload feed
    await loadFeed();
  } catch (e) {
    state = state.copyWith(error: e.toString());
  }
}
}
