// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:design_patterns_app/models/practice_question.dart';
// import 'package:design_patterns_app/providers/practice_provider.dart';

// class PracticeScreen extends ConsumerStatefulWidget {
//   final String designPatternId;

//   const PracticeScreen({Key? key, required this.designPatternId}) : super(key: key);

//   @override
//   ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
// }

// class _PracticeScreenState extends ConsumerState<PracticeScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final Map<int, String> _answers = {};

//   @override
//   void initState() {
//     super.initState();
//     ref.read(practiceProvider(widget.designPatternId).notifier).loadPracticeQuestions();
//   }

//   void _submitAnswers() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       await ref.read(practiceProvider(widget.designPatternId).notifier).submitAnswers(_answers);
//       // Optionally, display feedback
//       final feedback = ref.read(practiceProvider(widget.designPatternId)).feedback;
//       if (feedback != null) {
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Feedback'),
//             content: Text(feedback),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('OK'),
//               ),
//             ],
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final practiceState = ref.watch(practiceProvider(widget.designPatternId));

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Practice Questions'),
//       ),
//       body: practiceState.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : practiceState.error != null
//               ? Center(child: Text(practiceState.error!))
//               : practiceState.questions.isEmpty
//                   ? const Center(child: Text('No practice questions available.'))
//                   : Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Form(
//                         key: _formKey,
//                         child: ListView(
//                           children: [
//                             ...practiceState.questions.asMap().entries.map((entry) {
//                               int index = entry.key;
//                               PracticeQuestion question = entry.value;
//                               return Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Q${index + 1}: ${question.text}',
//                                       style: Theme.of(context).textTheme.subtitle1,
//                                     ),
//                                     const SizedBox(height: 8),
//                                     if (question.type == 'text')
//                                       TextFormField(
//                                         decoration: const InputDecoration(
//                                           labelText: 'Your Answer',
//                                           border: OutlineInputBorder(),
//                                         ),
//                                         maxLines: null,
//                                         validator: (val) =>
//                                             val == null || val.isEmpty ? 'Answer is required' : null,
//                                         onSaved: (val) => _answers[index] = val ?? '',
//                                       )
//                                     else if (question.type == 'code')
//                                       TextFormField(
//                                         decoration: const InputDecoration(
//                                           labelText: 'Your Code',
//                                           border: OutlineInputBorder(),
//                                         ),
//                                         maxLines: 10,
//                                         keyboardType: TextInputType.multiline,
//                                         validator: (val) =>
//                                             val == null || val.isEmpty ? 'Code is required' : null,
//                                         onSaved: (val) => _answers[index] = val ?? '',
//                                       ),
//                                   ],
//                                 ),
//                               );
//                             }).toList(),
//                             const SizedBox(height: 24),
//                             ElevatedButton(
//                               onPressed: _submitAnswers,
//                               child: const Text('Submit Answers'),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//     );
//   }
// }
