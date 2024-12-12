// import 'package:flutter/material.dart';
// import 'package:design_patterns_app/models/design_pattern.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // Optional: For video playback

// class DesignPatternDetailScreen extends StatelessWidget {
//   final DesignPattern designPattern;

//   const DesignPatternDetailScreen({Key? key, required this.designPattern}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Extract YouTube video ID if videoUrl is a YouTube link
//     String? videoId;
//     if (designPattern.videoUrl.contains('youtube.com')) {
//       videoId = YoutubePlayer.convertUrlToId(designPattern.videoUrl);
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(designPattern.name),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Video Section
//             if (videoId != null)
//               YoutubePlayer(
//                 controller: YoutubePlayerController(
//                   initialVideoId: videoId,
//                   flags: const YoutubePlayerFlags(
//                     autoPlay: false,
//                     mute: false,
//                   ),
//                 ),
//                 showVideoProgressIndicator: true,
//               )
//             else if (designPattern.videoUrl.isNotEmpty)
//               GestureDetector(
//                 onTap: () {
//                   // Implement video playback or navigation
//                 },
//                 child: Image.network(designPattern.videoUrl),
//               ),
//             const SizedBox(height: 16),
//             // Description
//             Text(
//               designPattern.description,
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//             const SizedBox(height: 16),
//             // Examples
//             Text(
//               'Examples:',
//               style: Theme.of(context).textTheme.headline6,
//             ),
//             const SizedBox(height: 8),
//             ...designPattern.examples.map((example) => Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Language: ${example.language}', style: Theme.of(context).textTheme.subtitle1),
//                         const SizedBox(height: 8),
//                         SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Text(
//                             example.code,
//                             style: const TextStyle(fontFamily: 'SourceCodePro', fontSize: 14),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )),
//             const SizedBox(height: 16),
//             // Add more sections as needed (e.g., videos, related patterns)
//           ],
//         ),
//       ),
//     );
//   }
// }
