import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';


@JsonSerializable(explicitToJson: true)
class User {

  final String id;
  final String name;
  final String email;
  final DateTime? birthdate;
  final Location? location;
  final int points;

  final List<User>? followers;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.birthdate,
    this.location,
    this.points = 0,
    this.followers,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}


@JsonSerializable()
class UserRef {
  final String name;


  UserRef({required this.name});
  factory UserRef.fromJson(Map<String, dynamic> json) => _$UserRefFromJson(json);
  Map<String, dynamic> toJson() => _$UserRefToJson(this);
}


/// Represents a geographical location using GeoJSON.
@JsonSerializable()
class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);

  double get longitude => coordinates[0];
  double get latitude => coordinates[1];
}
