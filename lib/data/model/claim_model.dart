class ClaimModel {
  int? id;
  DateTime? reservationDate;
  String? reservationNumber;
  String? phone;
  String? message;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? status;
  dynamic answer;
  int? userId;

  ClaimModel({
    this.id,
    this.reservationDate,
    this.reservationNumber,
    this.phone,
    this.message,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.answer,
    this.userId,
  });

  factory ClaimModel.fromJson(Map<String, dynamic> json) => ClaimModel(
    id: json["id"],
    reservationDate: json["reservation_date"] == null ? null : DateTime.parse(json["reservation_date"]),
    reservationNumber: json["reservation_number"],
    phone: json["phone"],
    message: json["message"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    status: json["status"],
    answer: json["answer"],
    userId: json["user_id"],
  );
}
