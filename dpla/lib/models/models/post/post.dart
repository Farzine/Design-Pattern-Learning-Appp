import 'package:json_annotation/json_annotation.dart';
import 'comment.dart';
import 'like.dart';


part 'post.g.dart';

@JsonSerializable(explicitToJson: true)
class Post {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'user_id')
  final UserRef user; 
  final String content;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  final List<Like> likes;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.user,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.likes = const [],
    this.comments = const [],
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}

@JsonSerializable()
class UserRef {
  final String name;

  UserRef({required this.name});

  factory UserRef.fromJson(Map<String, dynamic> json) => _$UserRefFromJson(json);
  Map<String, dynamic> toJson() => _$UserRefToJson(this);
}
