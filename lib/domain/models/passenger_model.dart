class PassengerModel{

  int? age;
  String? number;
  String? name;
  String? gender;
  String? ageError;
  String? phoneError;
  String? nameError;
  bool? isNameNull;
  bool? isAgeNull;
  bool isNumberTrue;

 PassengerModel({
    this.age,
    this.name,
    this.gender,
    this.number,
   this.ageError,
   this.nameError,
   this.isNameNull,
   this.phoneError,
   this.isNumberTrue=true,
   this.isAgeNull
  });

 Map<String, dynamic> toJson(i) {
   return {
     "passengers[$i][age]": age,
     "passengers[$i][name]": name,
     "passengers[$i][gender]": gender,
     "passengers[$i][number]": number,
   };
 }

}