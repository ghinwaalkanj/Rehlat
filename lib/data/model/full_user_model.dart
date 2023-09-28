import 'package:trips/data/model/user_model.dart';

class FullUserModel {
  UserModel? user;
  String token;

  FullUserModel({
    this.user,
    required this.token,
  });

  factory FullUserModel.fromJson(Map<String, dynamic> json) => FullUserModel(
    user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "token": token,
  };
}