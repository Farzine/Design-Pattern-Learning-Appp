// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:design_patterns_app/models/message.dart';
// import 'package:design_patterns_app/providers/message_provider.dart';
// import 'package:design_patterns_app/widgets/message_bubble.dart';

// class MessagesScreen extends ConsumerStatefulWidget {
//   final String chatWithUserId;
//   final String chatWithUserName;

//   const MessagesScreen({
//     Key? key,
//     required this.chatWithUserId,
//     required this.chatWithUserName,
//   }) : super(key: key);

//   @override
//   ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
// }

// class _MessagesScreenState extends ConsumerState<MessagesScreen> {
//   final _controller = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     ref.read(messageProvider(widget.chatWithUserId).notifier).loadMessages();
//   }

//   void _sendMessage() async {
//     final content = _controller.text.trim();
//     if (content.isEmpty) return;

//     await ref.read(messageProvider(widget.chatWithUserId).notifier).sendMessage(content);
//     _controller.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final messagesState = ref.watch(messageProvider(widget.chatWithUserId));

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat with ${widget.chatWithUserName}'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: messagesState.isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : messagesState.error != null
//                     ? Center(child: Text(messagesState.error!))
//                     : ListView.builder(
//                         reverse: true,
//                         itemCount: messagesState.messages.length,
//                         itemBuilder: (context, index) {
//                           final message = messagesState.messages[index];
//                           return MessageBubble(message: message);
//                         },
//                       ),
//           ),
//           if (messagesState.isSending) const LinearProgressIndicator(),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: const InputDecoration(
//                       hintText: 'Type your message...',
//                       border: OutlineInputBorder(),
//                     ),
//                     onSubmitted: (_) => _sendMessage(),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: _sendMessage,
//                   child: const Icon(Icons.send),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
