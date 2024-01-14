import 'package:trips/data/model/booking_trip_model.dart';

class SupportModel{
  BookingTripModel? bookingTripModel;
  String? phoneNumber;
   String? claimText;

  SupportModel({ this.bookingTripModel, this.phoneNumber, this.claimText});

  Map<String, dynamic> toJson() {
    return {
      "reservation_date": bookingTripModel?.startDate.toString().substring(0,10),
      "reservation_number": bookingTripModel?.reservationNumber,
      "phone":phoneNumber,
      "message":claimText
    };
  }
}