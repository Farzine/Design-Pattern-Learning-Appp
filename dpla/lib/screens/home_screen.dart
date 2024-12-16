// lib/screens/home_screen.dart

import 'package:dpla/models/comment.dart';
import 'package:dpla/models/like.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dpla/providers/post_provider.dart';
import 'package:intl/intl.dart';
import '../models/post.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postState = ref.watch(postFeedProvider);
    final posts = postState.posts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.purple[100],
      ),
      body: Column(
        children: [
          // Create Post Section
          _buildCreatePostSection(context, ref),
          const Divider(height: 1),
          Expanded(
            child: postState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : postState.error != null
                    ? Center(child: Text('Error: ${postState.error}'))
                    : posts.isEmpty
                        ? const Center(child: Text('No posts available'))
                        : ListView.builder(
                            itemCount: posts.length,
                            padding: const EdgeInsets.all(16.0),
                            itemBuilder: (context, index) {
                              final post = posts[index];
                              return _buildPostCard(context, ref, post);
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreatePostSection(BuildContext context, WidgetRef ref) {
    final TextEditingController postController = TextEditingController();
    final avatarUrl = 'https://via.placeholder.com/150'; // Replace with user's avatar URL if available

    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: const RoundedRectangleBorder(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: postController,
                decoration: InputDecoration(
                  hintText: "What's on your mind?",
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                final content = postController.text.trim();
                if (content.isNotEmpty) {
                  ref.read(postFeedProvider.notifier).createPost(content);
                  postController.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('Post', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, WidgetRef ref, Post post) {
    final dateStr = DateFormat('yyyy-MM-dd HH:mm').format(post.createdAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Row
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: const AssetImage('assets/logo.png') as ImageProvider,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    post.user.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Text(
                  dateStr,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Post Content
            Text(
              post.content,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 10),
            // Post Image (Optional)
            // If your posts can have images, include them here
            // Example:
            // post.imageUrl != null
            //     ? Padding(
            //         padding: const EdgeInsets.only(top: 10.0),
            //         child: Image.network(post.imageUrl!),
            //       )
            //     : Container(),
            // Likes and Comments Count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${post.likes.length} Likes',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  '${post.comments.length} Comments',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const Divider(height: 20),
            // Action Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.thumb_up_alt_outlined,
                  label: 'Like',
                  color: Colors.purple[400]!,
                  onTap: () {
                    ref.read(postFeedProvider.notifier).likePost(post.id);
                  },
                ),
                _buildActionButton(
                  icon: Icons.comment_outlined,
                  label: 'Comment',
                  color: Colors.purple[400]!,
                  onTap: () {
                    _showCommentDialog(context, ref, post.id);
                  },
                ),
                // You can add more actions like Share, etc.
              ],
            ),
            // Display Comments
            if (post.comments.isNotEmpty) _buildCommentsSection(post.comments),
            // Display Likes
            if (post.likes.isNotEmpty) _buildLikesSection(post.likes),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _showCommentDialog(BuildContext context, WidgetRef ref, String postId) {
    final TextEditingController commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Comment'),
        content: TextField(
          controller: commentController,
          decoration: const InputDecoration(hintText: 'Enter your comment'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final content = commentController.text.trim();
              if (content.isNotEmpty) {
                ref.read(postFeedProvider.notifier).commentOnPost(postId, content);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Comment'),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection(List<Comment> comments) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: comments
            .map(
              (comment) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundImage:  const AssetImage('assets/logo.png') as ImageProvider,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${comment.user.name} ',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            TextSpan(
                              text: comment.content,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildLikesSection(List<Like> likes) {
    // Display first few likes and a count of additional likes
    int displayCount = likes.length > 3 ? 3 : likes.length;
    List<Widget> likeWidgets = likes.take(displayCount).map((like) {
      return CircleAvatar(
        radius: 10,
        backgroundImage: const AssetImage('assets/logo.png') as ImageProvider,
      );
    }).toList();

    if (likes.length > 3) {
      likeWidgets.add(
        CircleAvatar(
          radius: 10,
          backgroundColor: Colors.grey[300],
          child: Text(
            '+${likes.length - 3}',
            style: const TextStyle(fontSize: 10, color: Colors.black),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          Stack(
            children: likeWidgets.asMap().entries.map((entry) {
              int idx = entry.key;
              Widget avatar = entry.value;
              return Positioned(
                left: idx * 15.0,
                child: avatar,
              );
            }).toList(),
          ),
          const SizedBox(width: 50),
          Text(
            'Liked by ${likes.first.user.name} and ${likes.length - 1} others',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
