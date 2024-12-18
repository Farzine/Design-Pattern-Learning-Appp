import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dpla/providers/post_provider.dart';
import 'package:dpla/providers/user_provider.dart';
import 'package:intl/intl.dart';
import '../models/post.dart';
import 'user_profile_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postState = ref.watch(postFeedProvider);
    final posts = postState.posts;

    final userListState = ref.watch(userListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.purple[100],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(postFeedProvider.notifier).loadFeed();
          await ref.read(userListProvider.notifier).fetchUsers();
        },
        child: ListView(
          children: [
            // Create Post Section
            _buildCreatePostSection(context, ref),

            const Divider(height: 1),

            // Friend Suggestions Section
            if (userListState.isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (userListState.error != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: Text('Error: ${userListState.error}')),
              )
            else if (userListState.users.isNotEmpty)
              _buildFriendSuggestionSection(context, userListState.users),

            const Divider(height: 1),

            // Posts Section
            if (postState.isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (postState.error != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: Text('Error: ${postState.error}')),
              )
            else if (posts.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: Text('No posts available')),
              )
            else
              ...posts.map((post) => _buildPostCard(context, ref, post)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatePostSection(BuildContext context, WidgetRef ref) {
    final TextEditingController postController = TextEditingController();
    const avatarUrl = 'https://via.placeholder.com/150';

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: postController,
                decoration: const InputDecoration(
                  hintText: "What's on your mind?",
                  border: InputBorder.none,
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
    );
  }

  Widget _buildFriendSuggestionSection(BuildContext context, List<dynamic> users) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'People You May Know',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => UserProfileScreen(userId: user.id)),
                  );
                },
                child: _buildUserSuggestionItem(user),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserSuggestionItem(dynamic user) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: const AssetImage('assets/logo.png') as ImageProvider,
          ),
          const SizedBox(height: 8),
          Text(
            user.name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          Text(
            user.email,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text(post.content, style: const TextStyle(fontSize: 16, height: 1.4)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${post.likes.length} ${post.likes.length == 1 ? 'Like' : 'Likes'}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  '${post.comments.length} ${post.comments.length == 1 ? 'Comment' : 'Comments'}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const Divider(height: 20),
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
              ],
            ),
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
}
