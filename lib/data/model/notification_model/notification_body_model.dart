class NotificationBodyModel {
  String? title;
  String? message;

  NotificationBodyModel({
    this.title,
    this.message,
  });

  factory NotificationBodyModel.fromJson(Map<String, dynamic> json) => NotificationBodyModel(
    title: json["title"],
    message: json["message"],
  );
}