class CityModel {
  int? id;
  String? nameAr;
  String? nameEn;
  DateTime? createdAt;
  DateTime? updatedAt;

  CityModel({
    this.id,
    this.nameAr,
    this.nameEn,
    this.createdAt,
    this.updatedAt,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
    id: json["id"],
    nameAr:json["name_ar"],
    nameEn: json["name_en"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );


}
