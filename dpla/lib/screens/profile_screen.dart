// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dpla/models/user.dart';
import 'package:dpla/providers/auth_provider.dart';
import 'package:dpla/utils/geocoding_utils.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  static const routeName = '/home';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String _locationName = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchLocationName();
  }

  /// Fetches the human-readable address from latitude and longitude.
  Future<void> _fetchLocationName() async {
    final authState = ref.read(authProvider);
    final User? user = authState.user;

    if (user != null && user.location != null) {
      String address = await GeocodingUtils.getAddressFromLatLng(
        user.location?.latitude ?? 0.0,
        user.location?.longitude ?? 0.0,
      );

      setState(() {
        _locationName = address;
      });
    } else {
      setState(() {
        _locationName = 'Location not set';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final User? user = authState.user;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('No user information available.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 50,
              backgroundImage: user.profilePictureUrl != null
                  ? NetworkImage(user.profilePictureUrl!)
                  : const AssetImage('assets/default_avatar.png')
                      as ImageProvider,
            ),
            const SizedBox(height: 16),

            // Name
            Text(
              user.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),

            // Email
            Text(
              user.email,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // Birthdate
            if (user.birthdate != null)
              Text(
                'Birthdate: ${DateFormat('yyyy-MM-dd').format(user.birthdate!)}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            if (user.birthdate != null) const SizedBox(height: 8),

            // Location
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _locationName,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Points
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  'Points: ${user.points}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),

            // Add more user details as needed (e.g., progress, posts)
          ],
        ),
      ),
    );
  }
}
