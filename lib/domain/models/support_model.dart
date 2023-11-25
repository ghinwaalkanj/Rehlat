class SupportModel{
  String? date;
  String? reservationID;
  String? phoneNumber;
   String? claimText;

  SupportModel({ this.date, this.reservationID, this.phoneNumber, this.claimText});

  Map<String, dynamic> toJson() {
    return {
      "reservation_date": date,
      "reservation_number": reservationID,
      "phone":phoneNumber,
      "message":claimText
    };
  }

}