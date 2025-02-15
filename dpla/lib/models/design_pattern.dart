import 'package:json_annotation/json_annotation.dart';

part 'design_pattern.g.dart';

@JsonSerializable()
class DesignPattern {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String description;
  @JsonKey(name: 'video_url')
  final String videoUrl;
  final List<Example> examples;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  DesignPattern({
    required this.id,
    required this.name,
    required this.description,
    required this.videoUrl,
    required this.examples,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DesignPattern.fromJson(Map<String, dynamic> json) => _$DesignPatternFromJson(json);
  Map<String, dynamic> toJson() => _$DesignPatternToJson(this);
}

@JsonSerializable()
class Example {
  final String language;
  final String code;

  Example({
    required this.language,
    required this.code,
  });

  factory Example.fromJson(Map<String, dynamic> json) => _$ExampleFromJson(json);
  Map<String, dynamic> toJson() => _$ExampleToJson(this);
}
