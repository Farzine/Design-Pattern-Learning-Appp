// lib/screens/profile_screen.dart

import 'package:dpla/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_nav_bar.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // Controllers for profile editing
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  DateTime? _selectedBirthdate;

  bool _isEditing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  /// Opens the date picker to select birthdate.
  Future<void> _selectBirthdate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthdate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthdate) {
      setState(() {
        _selectedBirthdate = picked;
        _birthdateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  /// Initiates the editing process.
  void _startEditing(User user) {
    setState(() {
      _isEditing = true;
      _nameController.text = user.name;
      _emailController.text = user.email;
      _birthdateController.text = user.birthdate != null
          ? DateFormat('yyyy-MM-dd').format(user.birthdate!)
          : '';
      _selectedBirthdate = user.birthdate;
    });
  }

  /// Cancels the editing process.
  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _nameController.clear();
      _emailController.clear();
      _birthdateController.clear();
      _selectedBirthdate = null;
    });
  }

  /// Saves the updated profile.
  Future<void> _saveProfile(User user) async {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final DateTime? birthdate = _selectedBirthdate;

    // Assuming location remains the same; you can implement location updates as needed.
    final double latitude = user.location?.latitude ?? 0.0;
    final double longitude = user.location?.longitude ?? 0.0;

    await ref.read(userProvider.notifier).updateProfile(
          name: name,
          email: email,
          birthdate: birthdate,
          latitude: latitude,
          longitude: longitude,
        );

    setState(() {
      _isEditing = false;
    });

    if (ref.read(userProvider).error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ref.read(userProvider).error!)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);

    return Scaffold(
      appBar: CustomNavBar(
        logoPath: 'assets/logo.png', // Ensure this path is correct
        searchController: TextEditingController(),
      ),
      body: userState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : userState.error != null
              ? Center(child: Text('Error: ${userState.error}'))
              : userState.user == null
                  ? const Center(child: Text('No user data available'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Profile Picture
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: const AssetImage('assets/logo.png') as ImageProvider,
                          ),
                          const SizedBox(height: 20),
                          // User Name
                          _isEditing
                              ? TextField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Name',
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                )
                              : Text(
                                  userState.user!.name,
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                          const SizedBox(height: 10),
                          // Email
                          _isEditing
                              ? TextField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: Icon(Icons.email),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.email, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Text(
                                      userState.user!.email,
                                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                          const SizedBox(height: 10),
                          // Birthdate
                          _isEditing
                              ? GestureDetector(
                                  onTap: () => _selectBirthdate(context),
                                  child: AbsorbPointer(
                                    child: TextField(
                                      controller: _birthdateController,
                                      decoration: const InputDecoration(
                                        labelText: 'Birthdate',
                                        prefixIcon: Icon(Icons.cake),
                                      ),
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.cake, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Text(
                                      userState.user!.birthdate != null
                                          ? DateFormat('yyyy-MM-dd').format(userState.user!.birthdate!)
                                          : 'N/A',
                                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                          const SizedBox(height: 20),
                          // Location
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                'Lat: ${userState.user!.location?.latitude.toStringAsFixed(2) ?? 'N/A'}, Lon: ${userState.user!.location?.longitude.toStringAsFixed(2) ?? 'N/A'}',
                                style: const TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          // Following List
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Following (${userState.following.length})',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10),
                          userState.following.isEmpty
                              ? const Text('You are not following anyone yet.')
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: userState.following.length,
                                  itemBuilder: (context, index) {
                                    final followedUser = userState.following[index];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage:  const AssetImage('assets/logo.png') as ImageProvider,
                                      ),
                                      title: Text(followedUser.name),
                                      subtitle: Text(followedUser.email),
                                      trailing: ElevatedButton(
                                        onPressed: () {
                                          // Unfollow user
                                          ref.read(userProvider.notifier).unfollowUser(followedUser.id);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        child: const Text('Unfollow'),
                                      ),
                                    );
                                  },
                                ),
                          const SizedBox(height: 30),
                          // Edit Profile Button
                          !_isEditing
                              ? ElevatedButton(
                                  onPressed: () => _startEditing(userState.user!),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple[400],
                                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    'Edit Profile',
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => _saveProfile(userState.user!),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.purple[400],
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      ),
                                      child: const Text('Save', style: TextStyle(color: Colors.white)),
                                    ),
                                    const SizedBox(width: 20),
                                    ElevatedButton(
                                      onPressed: _cancelEditing,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green[400],
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      ),
                                      child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
    );
  }
}
