//models/practice_question.dart
import 'package:json_annotation/json_annotation.dart';

part 'practice_question.g.dart';

@JsonSerializable()
class PracticeQuestion {
  final String question;
  final Map<String, String> options;
  final String correctAnswer;

  PracticeQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory PracticeQuestion.fromJson(Map<String, dynamic> json) => _$PracticeQuestionFromJson(json);
  Map<String, dynamic> toJson() => _$PracticeQuestionToJson(this);
}
