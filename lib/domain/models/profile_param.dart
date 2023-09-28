
class ProfileParamModel{
  String? name;
  String? age;
  int? id;
  String? phone;
  String? gender;
  String? code;

  ProfileParamModel(
      {
        this.name,
        this.age,
        this.gender,
        this.id,
        this.phone,
        this.code
      });

  factory ProfileParamModel.fromJson(Map<String, dynamic> json) => ProfileParamModel(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    age:(json["age"]!=null)? json["age"].toString():'',
    gender: json["gender"],
  );

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "age": age,
      "gender": gender,
      "phone":phone,
      "code":code
    };
  }
}