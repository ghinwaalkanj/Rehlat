import '../../domain/models/seat_model.dart';
import 'company_model.dart';

class TripModel {
  int? id;
  CompanyModel? company;
  CompanyModel? sourceCity;
  CompanyModel? destinationCity;
  DateTime? startDate;
  int? numberOfSeats;
  int? ticketPrice;
  int? seatsLeaft;
  String? busType;
  dynamic rate;
  List<SeatModel>? seats;
  int repeatTime;
  int? timer;
  int? extraTimer;

  TripModel({
    this.id,
    this.company,
    this.sourceCity,
    this.destinationCity,
    this.startDate,
    this.numberOfSeats,
    this.ticketPrice,
    this.seatsLeaft,
    this.seats,
    this.busType,
    this.rate,
    this.repeatTime=0,
    this.timer,
    this.extraTimer
  });

  factory TripModel.fromJson(Map<String, dynamic> json) => TripModel(
    id: json["id"],
    company: json["company"] == null ? null : CompanyModel.fromJson(json["company"]),
    sourceCity: json["source_city"] == null ? null : CompanyModel.fromJson(json["source_city"]),
    destinationCity: json["destination_city"] == null ? null : CompanyModel.fromJson(json["destination_city"]),
    startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
    numberOfSeats: json["number_of_seats"],
    ticketPrice: json["ticket_price"],
    seatsLeaft: json["seats_leaft"],
    busType: json["bus_type"],
    rate: json["rate"].toDouble(),
    timer:json["timer"],
    extraTimer:json["extra_time"],
    seats: json["seats"] == null ? [] : List<SeatModel>.from(json["seats"]!.map((x) => SeatModel.fromJson(x))),
  );
}

