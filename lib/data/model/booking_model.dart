import 'booking_trip_model.dart';

class BookingModel {
  List<BookingTripModel>? confirmed;
  List<BookingTripModel>? temp;
  List<BookingTripModel>? history;

  BookingModel({
    this.confirmed,
    this.temp,
    this.history,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
    confirmed: json["confirmed"] == null ? [] : List<BookingTripModel>.from(json["confirmed"]!.map((x) => BookingTripModel.fromJson(x))),
    temp: json["temp"] == null ? [] : List<BookingTripModel>.from(json["temp"]!.map((x) => BookingTripModel.fromJson(x))),
    history: json["history"] == null ? [] : List<BookingTripModel>.from(json["history"]!.map((x) => BookingTripModel.fromJson(x))),
  );

}