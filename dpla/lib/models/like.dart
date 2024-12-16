// lib/models/like.dart
import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'like.g.dart';

@JsonSerializable(explicitToJson: true)
class Like {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'post_id')
  final String postId;
  @JsonKey(name: 'user_id')
  final UserRef user;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  Like({
    required this.id,
    required this.postId,
    required this.user,
    required this.createdAt,
  });

  factory Like.fromJson(Map<String, dynamic> json) => _$LikeFromJson(json);
  Map<String, dynamic> toJson() => _$LikeToJson(this);
}
