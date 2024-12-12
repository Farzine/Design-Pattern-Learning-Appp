// import 'package:flutter/material.dart';
// import 'package:design_patterns_app/models/post.dart';

// class PostTile extends StatelessWidget {
//   final Post post;
//   final VoidCallback onLike;
//   final VoidCallback onComment;

//   const PostTile({Key? key, required this.post, required this.onLike, required this.onComment}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 1,
//       child: ListTile(
//         leading: CircleAvatar(backgroundImage: NetworkImage(post.user.profile_picture_url ?? '')),
//         title: Text(post.content),
//         subtitle: Text('By ${post.user.name}'),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(icon: const Icon(Icons.thumb_up), onPressed: onLike),
//             IconButton(icon: const Icon(Icons.comment), onPressed: onComment),
//           ],
//         ),
//       ),
//     );
//   }
// }
