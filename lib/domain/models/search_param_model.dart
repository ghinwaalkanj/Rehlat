
class SearchTripParamModel{
  int? sourceCity;
  int? destinationCity;
  String? passenger;
 String? date;

SearchTripParamModel(
    {
     this.sourceCity,
     this.destinationCity,
     this.date,
      this.passenger
  });

Map<String, dynamic> toJson() {
  return {
    "source_id": sourceCity!,
    "destination_id": destinationCity!,
    "date": date,
    "passenger_num":passenger
  };
}
}