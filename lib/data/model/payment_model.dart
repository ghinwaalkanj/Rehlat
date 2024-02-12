import 'package:trips/data/model/bank_model.dart';

class PaymentMethodsModel {
  List<BankModel>? banks;
  String? name;
  int? disable;
  String? logo;

  PaymentMethodsModel({
  this.name,
  this.disable,
  this.logo,
    this.banks
  });

  factory PaymentMethodsModel.fromJson(Map<String, dynamic> json) => PaymentMethodsModel(
      name: json["name"],
      disable: json["disable"],
      logo: json["logo"],
      banks:json["banks"] == null ? [] : List<BankModel>.from(json["banks"]!.map((x) => BankModel.fromJson(x))),
  );

}