import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:dpla/providers/user_provider.dart';

class UserProfileScreen extends ConsumerWidget {
  final String userId;
  const UserProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProfileProvider(userId));
    final userNotifier = ref.read(userProfileProvider(userId).notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        centerTitle: true,
        backgroundColor: Colors.purple[100],
        elevation: 4,
      ),
      body: userState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : userState.error != null
              ? Center(child: Text('Error: ${userState.error}'))
              : userState.user == null
                  ? const Center(child: Text('User not found'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildProfileHeader(userState.user!),
                          const SizedBox(height: 20),
                          _buildProfileDetails(userState.user!),
                          const SizedBox(height: 20),
                          _buildFollowButton(context, ref, userId, userState.user!),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildProfileHeader(dynamic user) {
    return Card(
      color: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 45,
          backgroundImage: const AssetImage('assets/logo.png'),
        ),
        title: Text(
          user.name ?? "N/A",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          user.email ?? "N/A",
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildProfileDetails(dynamic user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailTile(Icons.email, 'Email', user.email ?? "N/A"),
        _buildDetailTile(Icons.cake, 'Birthdate',
            user.birthdate != null ? DateFormat('yyyy-MM-dd').format(user.birthdate!) : 'N/A'),
        _buildDetailTile(Icons.location_on, 'Address', '123 Dummy Street, Dummy City'),
        _buildDetailTile(Icons.info_outline, 'About', 'This is a dummy user profile.'),
        _buildDetailTile(Icons.star_border, 'Skills', 'Flutter, Dart, Firebase'),
      ],
    );
  }

  Widget _buildDetailTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.purple[600]),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _buildFollowButton(BuildContext context, WidgetRef ref, String userId, dynamic user) {
    final userNotifier = ref.read(userProfileProvider(userId).notifier);
    final isFollowing = user?.isFollowing ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: ElevatedButton.icon(
        onPressed: () async {
          if (isFollowing) {
            await userNotifier.unfollowUser();
            _showFollowMessage(context, 'You unfollowed ${user.name}');
          } else {
            await userNotifier.followUser();
            _showFollowMessage(context, 'You followed ${user.name}');
          }
        },
        icon: Icon(isFollowing ? Icons.check : Icons.person_add, color: Colors.white),
        label: Text(isFollowing ? 'Followed' : 'Follow', style: const TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple[600],
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  void _showFollowMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message, textAlign: TextAlign.center),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
