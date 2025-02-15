// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Like _$LikeFromJson(Map<String, dynamic> json) => Like(
      id: json['_id'] as String,
      postId: json['post_id'] as String,
      user: UserRef.fromJson(json['user_id'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$LikeToJson(Like instance) => <String, dynamic>{
      '_id': instance.id,
      'post_id': instance.postId,
      'user_id': instance.user.toJson(),
      'created_at': instance.createdAt.toIso8601String(),
    };
