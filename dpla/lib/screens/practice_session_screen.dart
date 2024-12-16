// lib/screens/practice_session_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dpla/models/practice_question.dart';
import 'package:dpla/providers/practice_provider.dart';

class PracticeSessionScreen extends ConsumerStatefulWidget {
  final String designPatternId;
  final String designPatternName;

  const PracticeSessionScreen({
    Key? key,
    required this.designPatternId,
    required this.designPatternName,
  }) : super(key: key);

  @override
  _PracticeSessionScreenState createState() => _PracticeSessionScreenState();
}

class _PracticeSessionScreenState extends ConsumerState<PracticeSessionScreen> {
  // Map to store selected answers. Key: question index, Value: selected option
  final Map<int, String> _selectedAnswers = {};

  @override
  Widget build(BuildContext context) {
    final practiceState = ref.watch(practiceProvider(widget.designPatternId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Practice: ${widget.designPatternName}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: practiceState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : practiceState.error != null
                ? Center(child: Text(practiceState.error!))
                : practiceState.questions.isEmpty
                    ? const Center(child: Text('No practice questions available.'))
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: practiceState.questions.length,
                              itemBuilder: (context, index) {
                                final question = practiceState.questions[index];
                                return QuestionCard(
                                  question: question,
                                  index: index,
                                  selectedOption: _selectedAnswers[index],
                                  onOptionSelected: (option) {
                                    setState(() {
                                      _selectedAnswers[index] = option;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          practiceState.isSubmitting
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _selectedAnswers.length == practiceState.questions.length
                                      ? _submitAnswers
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple[400],
                                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: const Text(
                                    'Submit Answers',
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                ),
                        ],
                      ),
      ),
      floatingActionButton: practiceState.feedback != null
          ? FloatingActionButton(
              onPressed: () {
                _showFeedbackDialog(practiceState.feedback as Map<String, dynamic>);
              },
              backgroundColor: Colors.purple[400],
              child: const Icon(Icons.feedback),
            )
          : null,
    );
  }

  void _submitAnswers() {
    ref.read(practiceProvider(widget.designPatternId).notifier).submitAnswers(_selectedAnswers);
  }

  void _showFeedbackDialog(Map<String, dynamic> feedback) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Feedback'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...feedback['feedback'].map<Widget>((f) {
                  return ListTile(
                    leading: Icon(
                      f['correct'] ? Icons.check_circle : Icons.cancel,
                      color: f['correct'] ? Colors.green : Colors.red,
                    ),
                    title: Text(f['question']),
                    subtitle: Text(f['message']),
                  );
                }).toList(),
                const SizedBox(height: 10),
                Text('Correct Answers: ${feedback['correctCount']} / ${feedback['totalQuestions']}'),
                Text('Progress: ${feedback['progress']}%'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Optionally, navigate back or reset the practice session
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class QuestionCard extends StatelessWidget {
  final PracticeQuestion question;
  final int index;
  final String? selectedOption;
  final Function(String) onOptionSelected;

  const QuestionCard({
    Key? key,
    required this.question,
    required this.index,
    required this.selectedOption,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple[50],
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Question ${index + 1}:', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(
              question.question,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 12.0),
            ...question.options.entries.map((option) {
              return RadioListTile<String>(
                title: Text(option.value),
                value: option.key,
                groupValue: selectedOption,
                onChanged: (value) {
                  if (value != null) {
                    onOptionSelected(value);
                  }
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
