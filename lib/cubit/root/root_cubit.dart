import 'package:flutter_bloc/flutter_bloc.dart';

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
      emit(LoadingRateTripState());
      (await rateRepo.rateTrip(tripId: tripModel!.id!, rate: rate+1)).fold((l) {
        emit(ErrorRateTripState(error: l));},
              (r) {
            emit(SuccessRateTripState());
            tripModel=null;
          });
    }
  }