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
                          _buildFollowButton(context, userNotifier),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildProfileHeader(dynamic user) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 40,
          backgroundImage: const AssetImage('assets/logo.png'),
        ),
        title: Text(
          user.name ?? "N/A",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          user.email ?? "N/A",
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildProfileDetails(dynamic user) {
    return Column(
      children: [
        _buildDetailTile(Icons.email, 'Email', user.email ?? "N/A"),
        _buildDetailTile(Icons.cake, 'Birthdate',
            user.birthdate != null ? DateFormat('yyyy-MM-dd').format(user.birthdate!) : 'N/A'),
      ],
    );
  }

  Widget _buildDetailTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.purple),
      title: Text(title),
      subtitle: Text(value, style: const TextStyle(color: Colors.grey)),
    );
  }

  Widget _buildFollowButton(BuildContext context, UserProfileNotifier notifier) {
    return ElevatedButton.icon(
      onPressed: () {
        notifier.followUser(); // Follow logic
      },
      icon: const Icon(Icons.person_add, color: Colors.white),
      label: const Text('Follow', style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple[400],
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
