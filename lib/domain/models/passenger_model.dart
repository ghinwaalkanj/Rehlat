class PassengerModel{

  int? age;
  String? lastName;
  String? name;
  String? gender;
  String? ageError;
  String? lastNameError;
  String? nameError;
  bool? isNameNull;
  bool? isAgeNull;
  bool? isLastNameNull;

 PassengerModel({
    this.age,
    this.name,
    this.gender,
    this.lastName,
   this.ageError,
   this.nameError,
   this.isNameNull,
   this.lastNameError,
   this.isLastNameNull,
   this.isAgeNull
  });

 Map<String, dynamic> toJson(i) {
   return {
     "passengers[$i][age]": age,
     "passengers[$i][name]": name,
     "passengers[$i][gender]": gender,
     "passengers[$i][last_name]": lastName,
   };
 }

}