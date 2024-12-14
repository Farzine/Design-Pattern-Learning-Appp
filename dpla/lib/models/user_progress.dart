// lib/models/user_progress.dart

import 'package:json_annotation/json_annotation.dart';

part 'user_progress.g.dart';

@JsonSerializable()
class UserProgress {
  final String designPattern;
  final int progress; // Progress percentage
  final int points;
  final bool learningCompleted;
  final int practiceCompleted;
  final bool testCompleted;
  final DateTime updatedAt;

  UserProgress({
    required this.designPattern,
    required this.progress,
    required this.points,
    required this.learningCompleted,
    required this.practiceCompleted,
    required this.testCompleted,
    required this.updatedAt,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) =>
      _$UserProgressFromJson(json);
  Map<String, dynamic> toJson() => _$UserProgressToJson(this);
}
