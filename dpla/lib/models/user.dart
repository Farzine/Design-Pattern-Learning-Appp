import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// Represents a user in the Design Pattern Learning App.
@JsonSerializable(explicitToJson: true)
class User {
  /// Unique identifier for the user.
  final String id;

  /// Full name of the user.
  final String name;

  /// Email address of the user.
  final String email;


  /// Birthdate of the user.
  final DateTime? birthdate;

  /// Geographical location of the user.
  final Location? location;

  /// Points accumulated by the user.
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

  /// Creates a new `User` instance from a JSON map.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Converts the `User` instance to a JSON map.
  Map<String, dynamic> toJson() => _$UserToJson(this);
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

  /// Convenience getters
  double get longitude => coordinates[0];
  double get latitude => coordinates[1];
}
