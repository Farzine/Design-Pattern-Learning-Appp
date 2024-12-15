import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  // Controllers for profile editing
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  DateTime? _selectedBirthdate;
  bool _isEditing = false;
  String _currentLocation = "Fetching location...";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
      _fetchLocation();
    });
  }

  /// Fetch location using latitude and longitude
  Future<void> _fetchLocation() async {
    final user = ref.read(userProvider).user;
    if (user?.location?.latitude != null && user?.location?.longitude != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          user!.location!.latitude,
          user.location!.longitude,
        );
        setState(() {
          _currentLocation =
              "${placemarks.first.locality}, ${placemarks.first.country}";
        });
      } catch (_) {
        setState(() {
          _currentLocation = "Location unavailable";
        });
      }
    } else {
      setState(() {
        _currentLocation = "Location not set";
      });
    }
  }

  /// Initialize data for editing fields
  void _initializeData() {
    final user = ref.read(userProvider).user;
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      if (user.birthdate != null) {
        _selectedBirthdate = user.birthdate;
        _birthdateController.text =
            DateFormat('yyyy-MM-dd').format(user.birthdate!);
      }
    }
  }

  /// Opens date picker to select birthdate
  Future<void> _selectBirthdate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthdate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedBirthdate = picked;
        _birthdateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  /// Save updated profile
  Future<void> _saveProfile(User user) async {
    await ref.read(userProvider.notifier).updateProfile(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          birthdate: _selectedBirthdate,
          latitude: user.location?.latitude ?? 0.0,
          longitude: user.location?.longitude ?? 0.0,
        );

    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);

    if (userState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = userState.user;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.purple[100],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(user!),

            const SizedBox(height: 20),

            // Followers Section
            _buildFollowersSection(userState.following.length),

            const SizedBox(height: 20),

            // Edit Section or Details
            _isEditing
                ? _buildEditableForm(user)
                : _buildProfileDetails(user),

            const SizedBox(height: 20),

            // Action Buttons
            _buildActionButtons(user),
          ],
        ),
      ),
    );
  }

  /// Builds the profile header with avatar, name, and location
  Widget _buildProfileHeader(User user) {
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
          'Hi, ${user.name}!',
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        subtitle: Row(
          children: [
             Icon(Icons.location_on, color: Colors.purple[400], size: 16),
            const SizedBox(width: 4),
            Text(
              _currentLocation,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the followers section
  Widget _buildFollowersSection(int followersCount) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.people, color: Colors.purple),
        title: const Text(
          "Followers",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        trailing: Text(
          followersCount.toString(),
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }

  /// Builds editable form
  Widget _buildEditableForm(User user) {
    return Column(
      children: [
        _buildTextField('Name', _nameController, Icons.person),
        _buildTextField('Email', _emailController, Icons.email),
        GestureDetector(
          onTap: () => _selectBirthdate(context),
          child: AbsorbPointer(
            child: _buildTextField('Birthdate', _birthdateController, Icons.cake),
          ),
        ),
      ],
    );
  }

  /// Builds profile details
  Widget _buildProfileDetails(User user) {
    return Column(
      children: [
        _buildDetailTile(Icons.email, 'Email', user.email),
        _buildDetailTile(Icons.cake, 'Birthdate',
            user.birthdate != null ? DateFormat('yyyy-MM-dd').format(user.birthdate!) : 'N/A'),
        _buildDetailTile(Icons.location_on, 'Location', _currentLocation),
      ],
    );
  }

  /// Builds text fields
  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.purple),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  /// Builds detail tile
  Widget _buildDetailTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.purple),
      title: Text(title),
      subtitle: Text(value, style: const TextStyle(color: Colors.grey)),
    );
  }

  /// Builds action buttons
  Widget _buildActionButtons(User user) {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          if (_isEditing) _saveProfile(user);
          _isEditing = !_isEditing;
        });
      },
      icon: Icon(_isEditing ? Icons.save : Icons.edit, color: Colors.white),
      label: Text(_isEditing ? 'Save' : 'Edit Profile',
          style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple[400],
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
