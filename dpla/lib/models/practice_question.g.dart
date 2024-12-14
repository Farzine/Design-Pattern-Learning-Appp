// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PracticeQuestion _$PracticeQuestionFromJson(Map<String, dynamic> json) =>
    PracticeQuestion(
      question: json['question'] as String,
      options: Map<String, String>.from(json['options'] as Map),
      correctAnswer: json['correctAnswer'] as String,
    );

Map<String, dynamic> _$PracticeQuestionToJson(PracticeQuestion instance) =>
    <String, dynamic>{
      'question': instance.question,
      'options': instance.options,
      'correctAnswer': instance.correctAnswer,
    };
