// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_suggestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSuggestion _$UserSuggestionFromJson(Map<String, dynamic> json) =>
    UserSuggestion(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      birthdate: json['birthdate'] == null
          ? null
          : DateTime.parse(json['birthdate'] as String),
      points: (json['points'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$UserSuggestionToJson(UserSuggestion instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'birthdate': instance.birthdate?.toIso8601String(),
      'points': instance.points,
    };
