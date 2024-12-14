// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design_pattern.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DesignPattern _$DesignPatternFromJson(Map<String, dynamic> json) =>
    DesignPattern(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      videoUrl: json['video_url'] as String,
      examples: (json['examples'] as List<dynamic>)
          .map((e) => Example.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$DesignPatternToJson(DesignPattern instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'video_url': instance.videoUrl,
      'examples': instance.examples,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

Example _$ExampleFromJson(Map<String, dynamic> json) => Example(
      language: json['language'] as String,
      code: json['code'] as String,
    );

Map<String, dynamic> _$ExampleToJson(Example instance) => <String, dynamic>{
      'language': instance.language,
      'code': instance.code,
    };
