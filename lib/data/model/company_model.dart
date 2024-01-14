
class CompanyModel {
  int? id;
  String? logo;
  String? name;

  CompanyModel({
    this.id,
    this.logo,
    this.name,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
    id: json["id"],
    logo: json["logo"],
    name: json["name"],
  );

}