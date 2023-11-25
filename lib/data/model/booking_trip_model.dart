import 'package:trips/domain/models/seat_model.dart';

import 'company_model.dart';

class BookingTripModel{
  int? id;
  int? tripId;
  CompanyModel? company;
  CompanyModel? sourceCity;
  CompanyModel? destinationCity;
  DateTime? startDate;
  int? numberOfSeats;
  int? ticketPrice;
  int? seatsLeaft;
  String? busType;
  String? reservationNumber;
  double? rate;
  List<SeatModel>? mySeats;

  BookingTripModel({
  this.id,
  this.tripId,
  this.company,
  this.sourceCity,
  this.destinationCity,
  this.startDate,
  this.numberOfSeats,
  this.ticketPrice,
  this.seatsLeaft,
  this.busType,
  this.rate,
  this.mySeats,
    this.reservationNumber
  });

  factory BookingTripModel.fromJson(Map<String, dynamic> json) => BookingTripModel(
  id: json["id"],
  tripId: json["trip_id"],
  company: json["company"] == null ? null : CompanyModel.fromJson(json["company"]),
  sourceCity: json["source_city"] == null ? null : CompanyModel.fromJson(json["source_city"]),
  destinationCity: json["destination_city"] == null ? null : CompanyModel.fromJson(json["destination_city"]),
  startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
  numberOfSeats: json["number_of_seats"],
  ticketPrice: json["ticket_price"],
  seatsLeaft: json["seats_leaft"],
  busType: json["bus_type"],
  reservationNumber: json["reservation_number"],
  rate: json["rate"]?.toDouble(),
  mySeats: json["my_seats"] == null ? [] : List<SeatModel>.from(json["my_seats"]!.map((x) => SeatModel.fromJson(x))),
  );
  }
