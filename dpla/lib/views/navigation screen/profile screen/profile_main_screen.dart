import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import '../../../controllers/providers/user/user_provider.dart';
import 'profile_screen.dart';
import 'message_screen.dart';
import '../dashboard_screen.dart';
import 'settings_screen.dart';
import 'help_center_screen.dart';
import 'invite_friends_screen.dart';

class ProfileMainScreen extends ConsumerStatefulWidget {
  const ProfileMainScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileMainScreen> createState() => _ProfileMainScreenState();
}

class _ProfileMainScreenState extends ConsumerState<ProfileMainScreen>
    with SingleTickerProviderStateMixin {
  String _userLocation = 'Fetching location...';

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();


    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
      _fetchLocation();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    final user = ref.read(userProvider).user;
    if (user?.location?.latitude != null && user?.location?.longitude != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          user!.location!.latitude,
          user.location!.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          setState(() {
            _userLocation = "${place.locality ?? 'Unknown city'}, ${place.country ?? 'Unknown country'}";
          });
        } else {
          setState(() {
            _userLocation = 'Location not found';
          });
        }
      } catch (e) {
        setState(() {
          _userLocation = 'Failed to fetch location';
        });
        debugPrint('Error fetching location: $e');
      }
    } else {
      setState(() {
        _userLocation = 'Location not set';
      });
    }
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('OK')),
        ],
      ),
    );

    if (shouldLogout == true) {
      await ref.read(userProvider.notifier).signOut();
      if (mounted) Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);

    if (userState.isLoading || userState.user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = userState.user!;
    const avatarUrl = 'assets/logo.png';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.purple[100],
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          const SizedBox(height: 20),
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(avatarUrl),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi ${user.name}!',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.purple),
                          const SizedBox(width: 4),
                          Text(
                            _userLocation,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(context, icon: Icons.person_outline, title: 'My Profile', screen: const ProfileScreen()),
                _buildMenuItem(context, icon: Icons.message_outlined, title: 'Message', screen: const MessageScreen()),
                _buildMenuItem(context, icon: Icons.bar_chart, title: 'Progress', screen: const DashboardScreen()),
                _buildMenuItem(context, icon: Icons.settings, title: 'Settings', screen: const SettingsScreen()),
                _buildMenuItem(context, icon: Icons.help_outline, title: 'Help Center', screen: const HelpCenterScreen()),
                _buildMenuItem(context, icon: Icons.send, title: 'Invite Friends', screen: const InviteFriendsScreen()),
                _buildLogoutItem(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String title, required Widget screen}) {
    return ListTile(
      leading: Icon(icon, color: Colors.purple[400]),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () => _navigateTo(context, screen),
    );
  }

  Widget _buildLogoutItem() {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.purple),
      title: const Text('Logout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      onTap: () => _showLogoutDialog(context),
    );
  }
}
