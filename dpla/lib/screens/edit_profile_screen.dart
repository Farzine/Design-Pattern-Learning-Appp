// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:design_patterns_app/providers/user_provider.dart';
// import 'package:design_patterns_app/core/validators.dart';

// class EditProfileScreen extends ConsumerStatefulWidget {
//   const EditProfileScreen({Key? key}) : super(key: key);

//   @override
//   ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String _name = '';
//   String _email = '';
//   DateTime? _birthdate;
//   double? _latitude;
//   double? _longitude;
//   String? _profilePictureUrl;

//   @override
//   void initState() {
//     super.initState();
//     final user = ref.read(userProvider).user;
//     if (user != null) {
//       _name = user.name;
//       _email = user.email;
//       _latitude = user.location.coordinates[1];
//       _longitude = user.location.coordinates[0];
//       _profilePictureUrl = user.profilePictureUrl;
//       // Initialize birthdate if available
//     }
//   }

//   Future<void> _submit() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       await ref.read(userProvider.notifier).updateProfile(
//             name: _name,
//             email: _email,
//             birthdate: _birthdate,
//             latitude: _latitude,
//             longitude: _longitude,
//             profilePictureUrl: _profilePictureUrl,
//           );
//       Navigator.pop(context);
//     }
//   }

//   Future<void> _selectBirthdate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _birthdate ?? DateTime(1990, 1),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null && picked != _birthdate) {
//       setState(() {
//         _birthdate = picked;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userState = ref.watch(userProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Profile'),
//       ),
//       body: userState.isUpdating
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: ListView(
//                   children: [
//                     // Name
//                     TextFormField(
//                       initialValue: _name,
//                       decoration: const InputDecoration(labelText: 'Name'),
//                       validator: (val) => val == null || val.isEmpty ? 'Name is required' : null,
//                       onSaved: (val) => _name = val ?? '',
//                     ),
//                     const SizedBox(height: 16),
//                     // Email
//                     TextFormField(
//                       initialValue: _email,
//                       decoration: const InputDecoration(labelText: 'Email'),
//                       validator: Validators.validateEmail,
//                       onSaved: (val) => _email = val ?? '',
//                     ),
//                     const SizedBox(height: 16),
//                     // Birthdate
//                     ListTile(
//                       contentPadding: EdgeInsets.zero,
//                       title: const Text('Birthdate'),
//                       subtitle: Text(
//                         _birthdate != null
//                             ? "${_birthdate!.toLocal()}".split(' ')[0]
//                             : 'Select your birthdate',
//                       ),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.calendar_today),
//                         onPressed: () => _selectBirthdate(context),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     // Location
//                     TextFormField(
//                       initialValue: _latitude != null ? _latitude.toString() : '',
//                       decoration: const InputDecoration(labelText: 'Latitude'),
//                       keyboardType: TextInputType.numberWithOptions(decimal: true),
//                       validator: (val) =>
//                           val == null || val.isEmpty ? 'Latitude is required' : null,
//                       onSaved: (val) => _latitude = double.tryParse(val!),
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       initialValue: _longitude != null ? _longitude.toString() : '',
//                       decoration: const InputDecoration(labelText: 'Longitude'),
//                       keyboardType: TextInputType.numberWithOptions(decimal: true),
//                       validator: (val) =>
//                           val == null || val.isEmpty ? 'Longitude is required' : null,
//                       onSaved: (val) => _longitude = double.tryParse(val!),
//                     ),
//                     const SizedBox(height: 16),
//                     // Profile Picture URL
//                     TextFormField(
//                       initialValue: _profilePictureUrl ?? '',
//                       decoration: const InputDecoration(labelText: 'Profile Picture URL'),
//                       onSaved: (val) => _profilePictureUrl = val,
//                     ),
//                     const SizedBox(height: 32),
//                     ElevatedButton(
//                       onPressed: _submit,
//                       child: const Text('Save Changes'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
