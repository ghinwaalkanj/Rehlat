class SeatModel {
  int? id;
  String? status;
  int? number;
  bool? isSelected;
  bool? selectedByMe;

  SeatModel({
    this.id,
    this.status,
    this.number,
    this.isSelected,
    this.selectedByMe,
  });

  factory SeatModel.fromJson(Map<String, dynamic> json) => SeatModel(
    id: json["id"],
    status:json["status"],
    number: json["number"],
    isSelected: json["is_selected"],
    selectedByMe: json["selected_by_me"],
  );
}
