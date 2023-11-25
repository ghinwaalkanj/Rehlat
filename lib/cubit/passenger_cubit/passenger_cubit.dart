import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/cubit/passenger_cubit/passenger_states.dart';

import '../../core/utils/app_regexp.dart';
import '../../core/utils/global.dart';
import '../../data/data_resource/remote_resource/repo/trips_repo.dart';
import '../../domain/models/passenger_model.dart';
import '../../domain/models/seat_model.dart';
import '../../presentation/common_widgets/dialog/error_dialog.dart';

class PassengerCubit extends Cubit<PassengerStates> {
  List<PassengerModel> passengerList=[];
  bool isSamePrimaryPassenger=false;
  bool isNavigate=false;
  TripsRepo tripsRepo;

  PassengerCubit({required this.tripsRepo}) : super(PassengerInitialState());

  changeSamePrimary(bool value,PassengerModel passengerModel,int passengerNum){
    passengerModel.ageError=null;
    passengerModel.nameError=null;
    passengerModel.phoneError=null;
    isNavigate=false;
    createPassengerList(passengerNum.toString());
    passengerList[0]=passengerModel;
    if(value){
      if(passengerModel.name!=null && passengerModel.age!=null&&passengerModel.name!=''&&(passengerModel.age!<99 )) {
        if((passengerModel.number?.isNotEmpty??false)&&AppRegexp.phoneRegexp.hasMatch('${passengerModel.number}')==false){
          passengerModel.phoneError='phone_valid'.translate();
          emit(ErrorSamePassengerValidState(error: 'phone_valid'.translate()));
          isNavigate=false;
        }
       else{
          isSamePrimaryPassenger = value;
         for (int i = 0; i < passengerNum; i++) {
           passengerList[i]= passengerModel ;
           emit(ChangeSamePrimaryState());
           isNavigate=true;
        }
      }}
      else{
        if (passengerModel.age!=null&&passengerModel.age.toString()!=''&&passengerModel.age!>99 ) {
          passengerModel.ageError='age_bigger_than'.translate();
          emit(ErrorSamePassengerValidState(error: 'age_bigger_than'.translate()));
        }
        else{
        if(passengerModel.name==null||passengerModel.name=='' ) passengerModel.nameError='name_passenger_valid'.translate();
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
      if(element.name==null) {
        element.isNameNull=true;
      } else {
        element.isNameNull=false;
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
        if(element.number?.isEmpty??true){element.isNumberTrue=true;}
        else if((element.number?.isNotEmpty??false) && (AppRegexp.phoneRegexp.hasMatch(element.number.toString())==true)){
        element.isNumberTrue=true;
        }
        else if((element.number?.isNotEmpty??false)&& (AppRegexp.phoneRegexp.hasMatch(element.number.toString())!=true)){element.isNumberTrue=false;}
        bool x =element.isNameNull!=true&&element.isAgeNull!=true;
      if(x==true && element.isNumberTrue==true) {
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
      element.phoneError=null;
      element.nameError=null;
      element.ageError=null;
      if(element.name!=null && element.age!=null&&element.name!=''&&element.age!<99 ){
        if (element.age!=null&&element.age.toString()!=''&&element.age!>99 ) {
          element.ageError='age_bigger_than'.translate();
          emit(ErrorPassengerValidState());
        }
        if(element.number!=null&&element.number!='0'){
          if(AppRegexp.phoneRegexp.hasMatch('${element.number}')==false){
            element.phoneError='phone_valid'.translate();
            emit(ErrorPassengerValidState());
          }
        }
      }
      else{
        if(element.name==null||element.name=='' ) element.nameError='name_passenger_valid'.translate();
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
    List<int> seatApiList=[];
    for (var element in seatsIds) {
      seatApiList.add(element.id!);
    }
    for (var element in passengerList) {
      element.name;element.age;element.number;element.gender;
    }
    emit(LoadingReserveSeatsState());
    (await tripsRepo.reserveSeats(ids:seatApiList, passengerList: passengerList,isTemp: isTemp)).fold((l) => emit(ErrorReserveSeatsState(error: l)),
            (r) {
          emit(SuccessReserveSeatsState());
        });
  }
}

