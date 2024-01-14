import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_regexp.dart';
import 'package:trips/cubit/support/support_states.dart';
import 'package:trips/data/data_resource/remote_resource/repo/trips_repo.dart';
import 'package:trips/data/model/booking_trip_model.dart';

import '../../data/data_resource/remote_resource/repo/profile_repo.dart';
import '../../data/model/claim_model.dart';
import '../../domain/models/support_model.dart';

class SupportCubit extends Cubit<SupportStates> {
  SupportModel supportModel=SupportModel();
  ProfileRepo profileRepo;
  TripsRepo tripsRepo;
  String? selectedReservation;
  List<BookingTripModel> bookingIDList=[];
  List<ClaimModel> claimsList=[];
  TextEditingController phoneNumber=TextEditingController();
  TextEditingController claimText=TextEditingController();
  String? error;
  String? errorPhone;
  SupportCubit({required this.profileRepo,required this.tripsRepo,}) : super(SupportInitialState());

  initSupportScreen(){
    supportModel=SupportModel();
    phoneNumber=TextEditingController();
    claimText=TextEditingController();
    selectedReservation=null;
    errorPhone=null;
    error=null;
  }

  clearList(){
    bookingIDList=[];
    claimsList=[];
  }

  sendClaim() async {
    error=null;
    errorPhone=null;
    phoneNumber.text=phoneNumber.text.replaceAll(' ', '');
    if(supportModel.bookingTripModel!=null&&phoneNumber.text.isNotEmpty&&claimText.text.isNotEmpty){
    if(AppRegexp.phoneRegexp.hasMatch(phoneNumber.text)==true){
      emit(SendClaimLoadingState());
      supportModel.phoneNumber=phoneNumber.text;
      supportModel.claimText=claimText.text;
      (await profileRepo.sendClaim(supportModel: supportModel)).fold((l) =>emit(SendClaimErrorState(error:l)),
    (r) {
        claimsList.add(ClaimModel(
          createdAt: DateTime.now(),
          reservationNumber:supportModel.bookingTripModel!.reservationNumber,
          message: claimText.text,
        ));
      emit(SendClaimSuccessState());
    });
    }else{
      errorPhone='phone_valid'.translate();
      emit(UpdateDateState());
    }}
    else{
      error='profile_validate'.translate();
      if(phoneNumber.text.isEmpty)errorPhone='profile_validate'.translate();
      emit(UpdateDateState());
    }
  }

  getClaims() async {
      clearList();
      emit(GetClaimLoadingState());
      (await profileRepo.getClaims()).fold((l) =>emit(GetClaimErrorState(error:l)),
              (r) {
              claimsList=r;
            emit(GetClaimSuccessState());
            getBookingClaimList();
          });
    }

    getBookingClaimList() async {
      emit(GetClaimLoadingState());
      (await tripsRepo.getBooingList()).fold((l){
      emit(ErrorBookingClaimState(error: l));
        }, (r) {
        List<BookingTripModel>? historyList=r.history??[];
        for (var element in historyList) {
        if(DateTime.now().difference(element.startDate!).inDays<=7){
          bookingIDList.add(element);
        }
      }
      emit(GetClaimSuccessState());
      });
    }
  }