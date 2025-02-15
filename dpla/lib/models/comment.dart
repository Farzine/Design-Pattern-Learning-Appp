import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'comment.g.dart';

@JsonSerializable(explicitToJson: true)
class Comment {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'post_id')
  final String postId;
  @JsonKey(name: 'user_id')
  final UserRef user;
  final String content;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Comment({
    required this.id,
    required this.postId,
    required this.user,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
