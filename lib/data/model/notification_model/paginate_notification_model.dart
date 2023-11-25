
import 'link_model.dart';
import 'notification_model.dart';

class PaginateNotificationsModel {
  int? currentPage;
  List<NotificationModel>? data;
  String? firstPageUrl;
  dynamic from;
  int? lastPage;
  String? lastPageUrl;
  List<LinkModel>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  dynamic to;
  int? total;

  PaginateNotificationsModel({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory PaginateNotificationsModel.fromJson(Map<String, dynamic> json) => PaginateNotificationsModel(
    currentPage: json["current_page"],
    data: json["data"] == null ? [] : List<NotificationModel>.from(json["data"]!.map((x) =>NotificationModel.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: json["links"] == null ? [] : List<LinkModel>.from(json["links"]!.map((x) => LinkModel.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

}


