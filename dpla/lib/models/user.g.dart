// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profilePictureUrl: json['profile_picture_url'] as String?,
      birthdate: json['birthdate'] == null
          ? null
          : DateTime.parse(json['birthdate'] as String),
      location: json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, dynamic>),
      points: (json['points'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'profile_picture_url': instance.profilePictureUrl,
      'birthdate': instance.birthdate?.toIso8601String(),
      'location': instance.location?.toJson(),
      'points': instance.points,
    };

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };