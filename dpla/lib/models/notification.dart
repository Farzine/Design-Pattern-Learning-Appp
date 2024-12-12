// import 'package:json_annotation/json_annotation.dart';

// part 'notification.g.dart';

// @JsonSerializable()
// class AppNotification {
//   final String id;
//   final String userId;
//   final String type;
//   final Map<String, dynamic> content;
//   final bool isRead;
//   final DateTime createdAt;

//   AppNotification({
//     required this.id,
//     required this.userId,
//     required this.type,
//     required this.content,
//     required this.isRead,
//     required this.createdAt,
//   });

//   factory AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);
//   Map<String, dynamic> toJson() => _$AppNotificationToJson(this);

//   AppNotification copyWith({
//     String? id,
//     String? userId,
//     String? type,
//     Map<String, dynamic>? content,
//     bool? isRead,
//     DateTime? createdAt,
//   }) {
//     return AppNotification(
//       id: id ?? this.id,
//       userId: userId ?? this.userId,
//       type: type ?? this.type,
//       content: content ?? this.content,
//       isRead: isRead ?? this.isRead,
//       createdAt: createdAt ?? this.createdAt,
//     );
//   }
// }
