// import 'package:flutter/material.dart';
// import 'package:design_patterns_app/models/design_pattern.dart';
// import 'package:design_patterns_app/widgets/user_avatar.dart';

// class PatternTile extends StatelessWidget {
//   final DesignPattern designPattern;
//   final VoidCallback onTap;

//   const PatternTile({Key? key, required this.designPattern, required this.onTap}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: designPattern.videoUrl.isNotEmpty
//           ? IconButton(
//               icon: const Icon(Icons.play_circle_fill),
//               onPressed: () {
//                 // Implement video playback or navigation
//               },
//             )
//           : const Icon(Icons.design_services),
//       title: Text(designPattern.name),
//       subtitle: Text(designPattern.description),
//       trailing: const Icon(Icons.arrow_forward_ios),
//       onTap: onTap,
//     );
//   }
// }
