// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design_pattern.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DesignPattern _$DesignPatternFromJson(Map<String, dynamic> json) =>
    DesignPattern(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      videoUrl: json['videoUrl'] as String,
      examples: (json['examples'] as List<dynamic>)
          .map((e) => Example.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$DesignPatternToJson(DesignPattern instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'videoUrl': instance.videoUrl,
      'examples': instance.examples,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

Example _$ExampleFromJson(Map<String, dynamic> json) => Example(
      language: json['language'] as String,
      code: json['code'] as String,
    );

Map<String, dynamic> _$ExampleToJson(Example instance) => <String, dynamic>{
      'language': instance.language,
      'code': instance.code,
    };
