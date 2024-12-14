// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProgress _$UserProgressFromJson(Map<String, dynamic> json) => UserProgress(
      designPattern: json['designPattern'] as String,
      progress: (json['progress'] as num).toInt(),
      points: (json['points'] as num).toInt(),
      learningCompleted: json['learningCompleted'] as bool,
      practiceCompleted: (json['practiceCompleted'] as num).toInt(),
      testCompleted: json['testCompleted'] as bool,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserProgressToJson(UserProgress instance) =>
    <String, dynamic>{
      'designPattern': instance.designPattern,
      'progress': instance.progress,
      'points': instance.points,
      'learningCompleted': instance.learningCompleted,
      'practiceCompleted': instance.practiceCompleted,
      'testCompleted': instance.testCompleted,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
