import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/utils/global.dart';

import '../../data/data_resource/remote_resource/repo/rate_repo.dart';
import '../../data/data_resource/remote_resource/repo/trips_repo.dart';
import '../../data/model/trip_model.dart';
import 'root_states.dart';


class RootPageCubit extends Cubit<RootPageStates> {
  RootPageCubit({required this.tripsRepo,required this.rateRepo,}) : super(RootPageInitialState());
  TripsRepo tripsRepo;
  TripModel? tripModel;
  RateRepo rateRepo;
  int index=0;

  void changePageIndex(int pageIndex){
    index=pageIndex;
    emit(ChangeIndexState());
  }
  updateLanguage(){
    emit(ChangeIndexState());
    sendLang();
  }

  checkEvaluation() async {
    tripModel=null;
    emit(LoadingCheckTripState());
   (await rateRepo.checkTrip()).fold((l) => emit(ErrorCheckTripState(error: l)),
            (r) {
              tripModel=r;
          emit(SuccessCheckTripState());
        });
    }

    rateTrip({required int rate ,}) async {
    if(tripModel!=null){
      emit(LoadingRateTripState());
      (await rateRepo.rateTrip(tripId: tripModel!.id!, rate: rate+1)).fold((l) {
        emit(ErrorRateTripState(error: l));},
              (r) {
            emit(SuccessRateTripState());
            tripModel=null;
          });}
    else{
      if(navigatorKey.currentContext!= null) Navigator.pop(navigatorKey.currentContext!);
    }
  }

  sendLang() async {
    emit(SendLangLoadingState());
    (await rateRepo.sendLang()).fold((l) =>emit(SendLangErrorState(error:l)),
            (r) {
          emit(SendLangSuccessState());
        });
      }
  }