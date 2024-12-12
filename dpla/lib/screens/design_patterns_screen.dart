// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:design_patterns_app/models/design_pattern.dart';
// import 'package:design_patterns_app/providers/design_pattern_provider.dart';
// import 'package:design_patterns_app/widgets/pattern_tile.dart';
// import 'package:design_patterns_app/screens/design_pattern_detail_screen.dart';

// class DesignPatternsScreen extends ConsumerWidget {
//   const DesignPatternsScreen({Key? key}) : super(key: key);

//   void _navigateToDetail(BuildContext context, DesignPattern pattern) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DesignPatternDetailScreen(designPattern: pattern),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final patternsState = ref.watch(designPatternProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Design Patterns'),
//       ),
//       body: patternsState.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : patternsState.error != null
//               ? Center(child: Text(patternsState.error!))
//               : patternsState.patterns.isEmpty
//                   ? const Center(child: Text('No design patterns available.'))
//                   : ListView.builder(
//                       itemCount: patternsState.patterns.length,
//                       itemBuilder: (context, index) {
//                         final pattern = patternsState.patterns[index];
//                         return PatternTile(
//                           designPattern: pattern,
//                           onTap: () => _navigateToDetail(context, pattern),
//                         );
//                       },
//                     ),
//     );
//   }
// }
