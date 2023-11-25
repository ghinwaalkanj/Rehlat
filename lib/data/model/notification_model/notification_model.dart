import 'notification_body_model.dart';

class NotificationModel {
  int? id;
  int? userId;
  int? tripId;
  NotificationBodyModel? notification;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;

  NotificationModel({
    this.id,
    this.userId,
    this.tripId,
    this.notification,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    id: json["id"],
    userId: json["user_id"],
    tripId: json["data"]["trip_id"],
    notification: json["notification"] == null ? null : NotificationBodyModel.fromJson(json["notification"]),
    type: json["type"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );
}

