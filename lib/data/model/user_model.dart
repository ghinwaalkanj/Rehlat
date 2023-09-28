class UserModel {
  int? id;
  String?  name;
  String? phone;
  int? mobileVerified;
  String?  email;
  int? age;
  String?  gender;
  dynamic naunalNumber;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    this.id,
    this.name,
    this.phone,
    this.mobileVerified,
    this.email,
    this.age,
    this.gender,
    this.naunalNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    mobileVerified: json["mobile_verified"],
    email: json["email"],
    age: json["age"],
    gender: json["gender"],
    naunalNumber: json["naunal_number"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "mobile_verified": mobileVerified,
    "email": email,
    "age": age,
    "gender": gender,
    "naunal_number": naunalNumber,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
