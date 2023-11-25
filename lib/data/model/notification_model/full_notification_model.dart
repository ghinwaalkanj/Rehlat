import 'paginate_notification_model.dart';

class FullNotificationModel {
  PaginateNotificationsModel? data;
  bool? status;
  String? message;
  int? code;
  dynamic paginate;

  FullNotificationModel({
    this.data,
    this.status,
    this.message,
    this.code,
    this.paginate,
  });

  factory FullNotificationModel.fromJson(Map<String, dynamic> json) => FullNotificationModel(
    data: json["data"] == null ? null : PaginateNotificationsModel.fromJson(json["data"]['notifications']),
    status: json["status"],
    message: json["message"],
    code: json["code"],
    paginate: json["paginate"],
  );

}
