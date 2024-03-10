import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/cubit/passenger_cubit/passenger_states.dart';

import '../../core/utils/global.dart';
import '../../data/data_resource/remote_resource/repo/trips_repo.dart';
import '../../domain/models/passenger_model.dart';
import '../../domain/models/seat_model.dart';
import '../../presentation/common_widgets/dialog/error_dialog.dart';

class PassengerCubit extends Cubit<PassengerStates> {
  List<PassengerModel> passengerList=[];
  bool isSamePrimaryPassenger=false;
  bool isNavigate=false;
  bool? temp;
  int? reservationId;
  TripsRepo tripsRepo;

  PassengerCubit({required this.tripsRepo}) : super(PassengerInitialState());

  changeSamePrimary(bool value,PassengerModel passengerModel,int passengerNum){
    passengerModel.ageError=null;
    passengerModel.nameError=null;
    passengerModel.lastNameError=null;
    isNavigate=false;
    createPassengerList(passengerNum.toString());
    passengerList[0]=passengerModel;
    if(value){
      if(passengerModel.name!=null &&passengerModel.lastName!=null && passengerModel.age!=null&&passengerModel.name!=''&&passengerModel.lastName!=''&&(passengerModel.age!<99 )) {
        if (passengerModel.name!.length<2||passengerModel.lastName!.length<2) {
          if(passengerModel.name!.length<2)passengerModel.nameError='name_passenger_valid'.translate();
          if(passengerModel.lastName!.length<2)passengerModel.lastNameError='name_passenger_valid'.translate();
          emit(ErrorPassengerValidState());
        }
        else{
          isSamePrimaryPassenger = value;
         for (int i = 0; i < passengerNum; i++) {
           passengerList[i]= passengerModel ;
           emit(ChangeSamePrimaryState());
           isNavigate=true;}
      }}
      else{
        if (passengerModel.age!=null&&passengerModel.age.toString()!=''&&passengerModel.age!>99 ) {
          passengerModel.ageError='age_bigger_than'.translate();
          emit(ErrorSamePassengerValidState(error: 'age_bigger_than'.translate()));
        }
        else{
        if(passengerModel.name==null||passengerModel.name=='' ) passengerModel.nameError='name_passenger_valid'.translate();
        if(passengerModel.lastName==null||passengerModel.lastName=='' ) passengerModel.lastNameError='name_passenger_valid'.translate();
        if(passengerModel.age==null||passengerModel.age.toString()=='') passengerModel.ageError='age_passenger_valid'.translate();
        ErrorDialog.openDialog(navigatorKey.currentContext!, 'same_primary_validate'.translate());
        emit(ErrorPassengerValidState());
      }}}
    else{
      isSamePrimaryPassenger = value;
      passengerList=[];
      createPassengerList(passengerNum.toString());
      passengerList[0]=passengerModel;
      emit(Change2SamePrimaryState());
    }
  }

  validatePassenger(String passengers){
    bool isNull=true;
    List<bool> isNullList=[];
    for (var element in passengerList) {
      if(element.name==null||element.name==''||(element.name!=null&&element.name!.length<2)) {
        element.isNameNull=true;
      } else {
        element.isNameNull=false;
      }
      if(element.lastName==null||element.lastName==''||(element.lastName!=null&&element.lastName!.length<2)) {
        element.isLastNameNull=true;
      } else {
        element.isLastNameNull=false;
      }
      if(element.age==null) {
        element.isAgeNull=true;
      }
      else if(element.age!>99){
        element.isAgeNull=true;
      }
      else {
        element.isAgeNull=false;
      }
      bool x =element.isNameNull!=true&&element.isAgeNull!=true;
      if(x==true && element.isLastNameNull!=true) {
        isNullList.add(false);
      } else  {
        isNullList.add(true);
      }
    }
    isNull= isNullList.every((element) {
      return element==false;});
    if(isNull==true){
      addPassenger();
      emit(SuccessValidatePassengersState());
    }
    else {
      addPassenger();
      emit(ErrorValidatePassengersState());
    }
  }

  createPassengerList(String passengerCount) {
    passengerList=[];
    if (passengerList.isEmpty) {
      for (int i = 0; i < int.parse(passengerCount); i++) {
        passengerList.add(PassengerModel());
      }
    }
  }

  addPassenger({PassengerModel? passengerModel, }){
    for (var element in passengerList) {
      element.lastNameError=null;
      element.nameError=null;
      element.ageError=null;
      if(element.name!=null &&element.lastName!=null && element.age!=null&&element.name!=''&&element.lastName!=''&&element.age!<99 ){
        if (element.age!=null&&element.age.toString()!=''&&element.age!>99 ) {
          element.ageError='age_bigger_than'.translate();
          emit(ErrorPassengerValidState());
        }
        if (element.name!.length<2||element.lastName!.length<2) {
          if(element.name!.length<2)element.nameError='name_passenger_valid'.translate();
          if(element.lastName!.length<2)element.lastNameError='name_passenger_valid'.translate();
          emit(ErrorPassengerValidState());
        }
      }
      else{
        if(element.name==null||element.name=='' ) element.nameError='name_passenger_valid'.translate();
        if(element.lastNameError==null||element.lastName=='' ) element.lastNameError='name_passenger_valid'.translate();
        if(element.age==null||element.age.toString()=='') {
          element.ageError='age_passenger_valid'.translate();
        }
        if (element.age!=null&&element.age.toString()!=''&&element.age!>99 ) {
          element.ageError='age_bigger_than'.translate();
        }
        emit(ErrorPassengerValidState());
      }

      emit(ErrorPassengerValidState());
    }
  }

  Future<void> reserveSeats({required bool isTemp,required List<SeatModel> seatsIds}) async {
    temp=isTemp;
    List<int> seatApiList=[];
    for (var element in seatsIds) {
      seatApiList.add(element.id!);
    }
    for (var element in passengerList) {
      element.name;element.age;element.lastNameError;element.gender;
    }
    emit(LoadingReserveSeatsState());
    (await tripsRepo.reserveSeats(ids:seatApiList, passengerList: passengerList,isTemp: isTemp)).fold((l) => emit(ErrorReserveSeatsState(error: l)),
            (r) {
      print('tripsRepo.reserveSeats');
      print(r);
          reservationId=r;
          emit(SuccessReserveSeatsState());
        });
  }
}

