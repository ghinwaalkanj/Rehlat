import '../../domain/models/seat_model.dart';
import 'bus_model.dart';
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
  BusModel? busModel;
  dynamic rate;
  List<SeatModel>? seats;
  bool? canReserveTemp;
  int repeatTime;
  int? timer;
  int? extraTimer;

  TripModel({
    this.id,
    this.company,
    this.sourceCity,
    this.destinationCity,
    this.startDate,
    this.canReserveTemp,
    this.numberOfSeats,
    this.ticketPrice,
    this.seatsLeaft,
    this.seats,
    this.busModel,
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
    busModel:BusModel.fromJson(json["bus"]),
    rate: json["rate"].toDouble(),
    timer:json["timer"],
    canReserveTemp:json["can_reserve_temp"],
    extraTimer:json["extra_time"],
    seats: json["seats"] == null ? [] : List<SeatModel>.from(json["seats"]!.map((x) => SeatModel.fromJson(x))),
  );
}

