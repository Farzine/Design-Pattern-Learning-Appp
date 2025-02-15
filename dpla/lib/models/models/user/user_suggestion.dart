import 'package:json_annotation/json_annotation.dart';

part 'user_suggestion.g.dart';

@JsonSerializable()
class UserSuggestion {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String email;
  final DateTime? birthdate;
  final int points;

  var isFollowing;

  UserSuggestion({
    required this.id,
    required this.name,
    required this.email,
    this.birthdate,
    this.points = 0,
  });

  factory UserSuggestion.fromJson(Map<String, dynamic> json) => _$UserSuggestionFromJson(json);
  Map<String, dynamic> toJson() => _$UserSuggestionToJson(this);
}
