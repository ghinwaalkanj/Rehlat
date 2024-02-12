class BankModel {
  String? name;
  String? logo;

  BankModel({
    this.name,
    this.logo,
  });


  factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
    name: json["name"],
    logo: json["logo"],
  );

}
