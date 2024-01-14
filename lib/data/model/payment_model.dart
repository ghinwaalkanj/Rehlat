
class PaymentMethodsModel {
  String? name;
  int? disable;
  String? logo;

  PaymentMethodsModel({
  this.name,
  this.disable,
  this.logo,
  });

  factory PaymentMethodsModel.fromJson(Map<String, dynamic> json) => PaymentMethodsModel(
      name: json["name"],
      disable: json["disable"],
      logo: json["logo"],
  );

}