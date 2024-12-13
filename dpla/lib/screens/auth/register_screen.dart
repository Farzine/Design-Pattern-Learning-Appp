
// lib/screens/auth/register_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../utils/geocoding_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_routes.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  static const routeName = '/register';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  DateTime? _selectedBirthdate;
  LatLng _selectedLocation = const LatLng(37.7749, -122.4194); // Default location (San Francisco)
  String _selectedAddress = 'Fetching location...';

  bool _isSubmitting = false; // Indicates if form submission is in progress
  bool _isMapLoading = true; // Indicates if the map is still loading
  GoogleMapController? _mapController; // Controller for GoogleMap

  Set<Marker> _markers = {}; // Set of markers on the map

  @override
  void initState() {
    super.initState();
    _initializeMarker();
    _requestLocationPermissionAndFetchLocation();
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  /// Initializes the marker at the default location
  void _initializeMarker() {
    _markers.add(
      Marker(
        markerId: const MarkerId('selected_location'),
        position: _selectedLocation,
        draggable: true,
        onDragEnd: (newPosition) async {
          setState(() {
            _selectedLocation = newPosition;
            _selectedAddress = 'Fetching address...';
          });
          // Fetch address for the new position
          String address = await GeocodingUtils.getAddressFromLatLng(
            newPosition.latitude,
            newPosition.longitude,
          );
          setState(() {
            _selectedAddress = address;
          });
        },
      ),
    );
  }

  /// Requests location permission and fetches current location if granted
  Future<void> _requestLocationPermissionAndFetchLocation() async {
    try {
      var status = await Permission.location.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        // Inform the user that location permission is required
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission is required.')),
        );
        openAppSettings(); // Opens app settings for the user to grant permission
        return;
      }

      if (status.isGranted) {
        await _fetchCurrentLocation();
      }
    } catch (e) {
      // Handle any errors during permission request
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch location: $e')),
      );
    }
  }

  /// Fetches the current location of the user
  Future<void> _fetchCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      // Get the current position with high accuracy
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
        _selectedAddress = 'Fetching address...';
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('selected_location'),
            position: _selectedLocation,
            draggable: true,
            onDragEnd: (newPosition) async {
              setState(() {
                _selectedLocation = newPosition;
                _selectedAddress = 'Fetching address...';
              });
              // Fetch address for the new position
              String address = await GeocodingUtils.getAddressFromLatLng(
                newPosition.latitude,
                newPosition.longitude,
              );
              setState(() {
                _selectedAddress = address;
              });
            },
          ),
        );
      });

      // Fetch the address for the current location
      String address = await GeocodingUtils.getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _selectedAddress = address;
      });

      // Move the camera to the current location
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(_selectedLocation),
      );
    } catch (e) {
      // Handle any errors during location fetching
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
    } finally {
      setState(() {
        _isMapLoading = false; // Hide loader once location is fetched
      });
    }
  }

  /// Opens a date picker dialog for the user to select their birthdate
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

  /// Handles the registration process
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return; // Validate form fields

    if (_selectedAddress == 'Fetching address...') {
      // Ensure the address has been fetched
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait for location to be fetched')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true; // Show loading indicator on submit button
    });

    try {
      final String name = _nameController.text.trim();
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      final DateTime birthdate = _selectedBirthdate!;

      // Call the register method from AuthProvider
      await ref.read(authProvider.notifier).register(
            name,
            email,
            password,
            birthdate,
            _selectedLocation.latitude,
            _selectedLocation.longitude,
          );

      final authState = ref.read(authProvider);

      if (authState.user != null) {
        // If registration is successful, set the onboarding flag and navigate to home
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('seenOnboarding', true);
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else if (authState.error != null) {
        // Show error message if registration failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authState.error!)),
        );
      }
    } catch (e) {
      // Handle any unexpected errors during registration
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false; // Hide loading indicator
      });
    }
  }

  /// Handles map taps to select a new location
  Future<void> _onMapTapped(LatLng latlng) async {
    setState(() {
      _selectedLocation = latlng;
      _selectedAddress = 'Fetching address...';
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('selected_location'),
          position: _selectedLocation,
          draggable: true,
          onDragEnd: (newPosition) async {
            setState(() {
              _selectedLocation = newPosition;
              _selectedAddress = 'Fetching address...';
            });
            // Fetch address for the new position
            String address = await GeocodingUtils.getAddressFromLatLng(
              newPosition.latitude,
              newPosition.longitude,
            );
            setState(() {
              _selectedAddress = address;
            });
          },
        ),
      );
    });

    // Fetch the address for the new location
    String address = await GeocodingUtils.getAddressFromLatLng(
      latlng.latitude,
      latlng.longitude,
    );

    setState(() {
      _selectedAddress = address;
    });

    // Move camera to the new location
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(_selectedLocation),
    );
  }

  /// Navigates to the Login Screen
  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade100, // Light purple background
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Gradient Section with Welcome Text
            Container(
              height: MediaQuery.of(context).size.height * 0.25, // 25% of screen height
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF261FF), Color(0xFFC81ADE)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Sign Up to Continue",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // Registration Form
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey, // Form key for validation
                child: Column(
                  children: [
                    const SizedBox(height: 30), // Spacing

                    // Full Name Input Field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "User Name",
                        prefixIcon: const Icon(Icons.person),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none, // Remove border
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20), // Spacing

                    // Email Input Field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "E-mail",
                        prefixIcon: const Icon(Icons.email),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none, // Remove border
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20), // Spacing

                    // Password Input Field
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none, // Remove border
                        ),
                      ),
                      obscureText: true, // Hide password
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.trim().length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20), // Spacing

                    // Birthdate Input Field
                    TextFormField(
                      controller: _birthdateController,
                      decoration: InputDecoration(
                        labelText: "Select Birthdate",
                        prefixIcon: const Icon(Icons.calendar_today),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none, // Remove border
                        ),
                        suffixIcon: const Icon(Icons.arrow_drop_down), // Dropdown icon
                      ),
                      readOnly: true, // Prevent manual editing
                      onTap: () => _selectBirthdate(context), // Open date picker
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please select your birthdate';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20), // Spacing

                    // Title for Location Selection
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select Location",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10), // Spacing

                    // Google Maps Section with Loader
                    SizedBox(
                      height: 300, // Fixed height for the map
                      child: Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: _selectedLocation,
                              zoom: 14.0,
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              _mapController = controller;
                              setState(() {
                                _isMapLoading = false; // Hide loader once map is ready
                              });
                            },
                            markers: _markers, // Current markers
                            onTap: _onMapTapped, // Handle map taps
                            myLocationEnabled: true, // Show user's location
                            myLocationButtonEnabled: true, // Show location button
                          ),
                          if (_isMapLoading)
                            const Center(
                              child: CircularProgressIndicator(), // Loader while map is loading
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10), // Spacing

                    // Display Selected Address
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50, // Light blue background
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.blue.shade200), // Border color
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.blue), // Location icon
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedAddress, // Display fetched address
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24), // Spacing

                    // Submit Button
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _register, // Disable button if submitting
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(), // Circular button
                        padding: const EdgeInsets.all(20),
                        backgroundColor: Colors.purple, // Button color
                      ),
                      child: _isSubmitting
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white), // Loader inside button
                            )
                          : const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 30,
                            ),
                    ),
                    const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

