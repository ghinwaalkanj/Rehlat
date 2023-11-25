

class BusModel {
  int? id;
  String? name;
  int? numberSeat;
  String? details;

  BusModel({
    this.id,
    this.name,
    this.numberSeat,
    this.details,
  });

  factory BusModel.fromJson(Map<String, dynamic> json) => BusModel(
    id: json["id"],
    name: json["name"],
    numberSeat: json["number_seat"],
    details: json["details"],
  );

}
