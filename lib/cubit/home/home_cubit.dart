import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/notifications/push_notifications with local_flutter .dart';
import '../../data/data_resource/remote_resource/repo/trips_repo.dart';
import '../../data/model/city_model.dart';
import '../../data/model/company_model.dart';
import '../../data/model/trip_model.dart';
import '../../domain/models/search_param_model.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomePageStates> {
  HomeCubit({required this.tripsRepo}) : super(HomePageInitialState());
  TripsRepo tripsRepo;
   SearchTripParamModel searchTripParam =SearchTripParamModel(passenger: '1');
  TextEditingController sourceSearchController=TextEditingController();
  TextEditingController passengerController=TextEditingController(text: "1");
  TextEditingController destSearchController=TextEditingController();
  DateTime? returnDate;
  List<TripModel> tripsList=[];
  List<CityModel> citiesList=[];
  List<CompanyModel> companiesList=[];
  String? source;
  bool isHomePage=true;
  bool isLoading=true;
  bool isError=true;
  String? dest;
  DateTime? date;
  DateTime? selectedDate;
  String passengers='1';
  CityModel? destCity;
  CityModel? srcCity;
  Duration? extraTimer;
  Duration? timer;
  List<DateTime> weekList=[];
  int passengerNumPermission=6;


    searchTrip() async {
      if(searchTripParam.sourceCity!=null && searchTripParam.destinationCity!=null&&searchTripParam.date!=null &&searchTripParam.passenger != null){
        if((int.parse(searchTripParam.passenger!)<passengerNumPermission)&&searchTripParam.passenger!='0'){
      emit(LoadingSearchTripState());
      (await tripsRepo.searchTrip(searchTripParamModel:searchTripParam,)).fold((l) => emit(ErrorSearchTripState(error: l)),
              (r) {
                tripsList=r;
                if(tripsList.isNotEmpty) extraTimer=Duration( minutes: tripsList[0].extraTimer??1);
                if(tripsList.isNotEmpty) timer=Duration( minutes: tripsList[0].timer??1);
                srcCity=citiesList.firstWhere((element) => element.id==searchTripParam.sourceCity);
                destCity=citiesList.firstWhere((element) => element.id==searchTripParam.destinationCity);
                emit(SuccessSearchTripState());
            });
          }
        else {
          emit(ValidatePassengerState());
        }}
      else{
        emit(ValidateState());
      }
    }

    addGoDate(DateTime dateTime){
      searchTripParam.date=dateTime.toString().substring(0,10);
     emit(ChangeGoDateState());
    }

    addReturnDate(DateTime dateTime){
      if(dateTime.isAfter(date??DateTime.now())) {
        returnDate=dateTime;
        emit(ChangeGoDateState());
      } else {
        emit(ValidateReturnDateState());
      }
    }

    reverseSource(){
      source=  searchTripParam.destinationCity.toString();
      dest=searchTripParam.sourceCity.toString();
      searchTripParam.destinationCity=int.parse(dest!);
      searchTripParam.sourceCity=int.parse(source!);
      emit(ReverseState());
  }

    selectDate(DateTime dateTime){
      selectedDate= dateTime;
      date=dateTime;
      searchTripParam.date=dateTime.toString().substring(0,10);
      emit(SelectedDateState());
  }

  getCities() async {
    getCompanies();
    emit(LoadingGetCitiesState());
    (await tripsRepo.getCities()).fold((l) => emit(ErrorGetCitiesState(error: l)),
            (r) async {
          citiesList=r.citiesList;
          passengerNumPermission=r.limitPassenger;
          emit(SuccessGetCitiesState());
          await PushNotificationService().setupInteractedMessage();
        });
  }

  addWeek(DateTime dateTime){
    weekList=[];
    for(int i=0;i<= 7;i++){
      weekList.add(dateTime.add(Duration(days: i)));
    }
  }

  returnDateTime(){
      reverseSource();
      date=returnDate;
      selectedDate=returnDate;
      addWeek(date!);
      addGoDate(date!);
      returnDate=null;
      emit(ReturnDateTimeState());
  }

  getCompanies() async {
      isLoading=true;
      isError=false;
    emit(LoadingGetCompaniesState());
    (await tripsRepo.getCompanies()).fold((l) {
      isLoading=false;
      isError=true;
      emit(ErrorGetCompaniesState(error: l));},
    (r) {
      companiesList=r;
      isLoading=false;
      isError=false;
    emit(SuccessGetCompaniesState());
    });
  }
}