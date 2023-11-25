class LinkModel {
  String? url;
  String? label;
  bool? active;

  LinkModel({
    this.url,
    this.label,
    this.active,
  });

  factory LinkModel.fromJson(Map<String, dynamic> json) => LinkModel(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );
}