import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/utils/global.dart';
import 'package:trips/data/model/trip_model.dart';
import '../../data/data_resource/remote_resource/repo/trips_repo.dart';
import '../../domain/models/seat_model.dart';
import '../seats/seats_cubit.dart';
import 'reserve_trip_states.dart';

class ReserveTripCubit extends Cubit<ReserveTripStates> {
  TripsRepo tripsRepo;
  bool acceptTerms=false;
  ReserveTripCubit({required this.tripsRepo}) : super(ReserveTripInitialState());



  acceptTermsFun(bool value){
    acceptTerms=value;
    emit(AcceptTermsState());
  }









}