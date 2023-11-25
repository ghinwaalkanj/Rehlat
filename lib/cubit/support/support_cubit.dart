import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/cubit/support/support_states.dart';

import '../../data/data_resource/remote_resource/repo/profile_repo.dart';
import '../../domain/models/support_model.dart';

class SupportCubit extends Cubit<SupportStates> {
  SupportModel supportModel=SupportModel();
  ProfileRepo profileRepo;
  TextEditingController reservationNumber=TextEditingController();
  TextEditingController phoneNumber=TextEditingController();
  TextEditingController claimText=TextEditingController();
  String? error;
  SupportCubit({required this.profileRepo}) : super(SupportInitialState());

  updateDate(DateTime date){
    supportModel.date=date.toString().substring(0,10);
    emit(UpdateDateState());
  }

  sendClaim() async {
    error=null;
    if(supportModel.date!=null&&reservationNumber.text.isNotEmpty&&phoneNumber.text.isNotEmpty&&claimText.text.isNotEmpty){
      emit(SendClaimLoadingState());
      supportModel.phoneNumber=phoneNumber.text;
      supportModel.claimText=claimText.text;
      supportModel.reservationID=reservationNumber.text;
      (await profileRepo.sendClaim(supportModel: supportModel)).fold((l) =>emit(SendClaimErrorState(error:l)),
    (r) {
      emit(SendClaimSuccessState());
    });
    }
    else{
      error='profile_validate'.translate();
      emit(UpdateDateState());

    }
  }
}