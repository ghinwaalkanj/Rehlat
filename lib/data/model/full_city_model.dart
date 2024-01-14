import 'city_model.dart';

class FullCityModel{
  final List<CityModel> citiesList;
  final int limitPassenger;

  FullCityModel({required this.citiesList, required this.limitPassenger});

  factory FullCityModel.fromJson(Map<String, dynamic> json) => FullCityModel(
    citiesList: json["cities"] == null ? [] : List<CityModel>.from(json["cities"]!.map((x) => CityModel.fromJson(x))),
    limitPassenger: json["limit_passenger"],
  );
}