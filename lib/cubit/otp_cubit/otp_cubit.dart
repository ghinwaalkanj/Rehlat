import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/data/data_resource/local_resource/data_store.dart';

import '../../core/utils/app_regexp.dart';
import '../../core/utils/app_router.dart';
import '../../core/utils/global.dart';
import '../../data/data_resource/remote_resource/repo/trips_repo.dart';
import '../../data/model/trip_model.dart';
import '../../data/model/user_model.dart';
import '../../domain/models/profile_param.dart';
import '../../presentation/common_widgets/dialog/loading_dialog.dart';
import '../../presentation/screens/booking_trip/screens/hop_hop_seats_info_screen.dart';
import '../../presentation/screens/booking_trip/screens/normal2_seats_info_screen.dart';
import '../../presentation/screens/booking_trip/screens/vip_seats_info_screen.dart';
import '../../presentation/screens/verify_screen/success_verify_dialog.dart';
import '../home/home_cubit.dart';
import '../reverse_trip/reserve_trip_cubit.dart';
import '../seats/seats_cubit.dart';
import 'otp_states.dart';


class OtpCubit extends Cubit<OtpStates> {
  TextEditingController nameController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TripsRepo tripsRepo;
  TripModel? tripModel;
  String? phoneNumber;
  String? fullName;
  String? code;
  String? countryCode;
  UserModel?  userModel;
  OtpCubit({required this.tripsRepo}) : super(OtpInitialState());


  Future<void> sendOtp({required bool isVerifyScreen}) async {
    String? error;
    bool isPhone=AppRegexp.phoneRegexp.hasMatch(phoneNumber??'');
    if(phoneNumber != null  && isPhone){
    emit(LoadingSendOtpState());
    (await tripsRepo.sendOtp(phoneNumber!,fullName)).fold((l) => emit(ErrorSendOtpState(error: l)),
    (r) {
    emit(SuccessSendOtpState(isVerifyScreen: isVerifyScreen));
    if(DataStore.instance.name==null)DataStore.instance.setName(fullName??'');
    if(DataStore.instance.phone==null)DataStore.instance.setPhone(phoneNumber??'');
    });
      } else{
         if ((DataStore.instance.token==null&&fullName==null) || phoneNumber==null) {
           print((DataStore.instance.token==null&&fullName==null) || phoneNumber==null);
           error='fill_phone'.translate();
         } else if (!isPhone) {
            error='phone_valid'.translate();
          }
          emit(ValidateSendOtpState(error: error));
      }
}

  Future<void> verifyOtp(context) async {
    if(code.toString().length==6 ){
    emit(LoadingVerifyOtpState());
    (await tripsRepo.phoneVerify(phoneNumber!,code!)).fold((l) => emit(ErrorVerifyOtpState(error: l)),
    (r) {
      userModel=r.user;
      DataStore.instance.setToken(r.token);
      print(  DataStore.instance.token);
     emit(SuccessVerifyOtpState());
    });
  }else{
      String? error;
     if(code.toString().length<6)error='code_valid'.translate();
  emit(ValidateVerifyOtpState(error:error));
  }
}

}