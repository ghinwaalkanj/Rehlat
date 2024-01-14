import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/data/data_resource/local_resource/data_store.dart';

import '../../core/utils/app_regexp.dart';
import '../../core/utils/utils_functions.dart';
import '../../data/data_resource/remote_resource/repo/trips_repo.dart';
import '../../data/model/trip_model.dart';
import '../../data/model/user_model.dart';
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
  String? blockedDuration;
  Headers? verifyHeaders;
  bool isLogin=true;
  OtpCubit({required this.tripsRepo}) : super(OtpInitialState());

  clearCode(){
    code=null;
    emit(OtpInit2State());
  }

  Future<void> sendOtp({required bool isVerifyScreen}) async {
    String? error;
    bool isPhone=AppRegexp.phoneRegexp.hasMatch(phoneNumber??'');
    if(phoneNumber != null  && isPhone){
    emit(LoadingSendOtpState());
    (await tripsRepo.sendOtp(phoneNumber!,fullName,getHeaders: (p0) =>verifyHeaders=p0,isRegister: isLogin)).fold((l) {
      if(verifyHeaders?['retry-after']?.first!=null){
        blockedDuration=verifyHeaders!['retry-after']!.first;
        String time=FunctionUtils().formattedTime(timeInSecond: int.parse(blockedDuration!));
        emit(ErrorSendOtpState(error:'${'block_msg'.translate()} \n $time ${'minute'.translate()}'));
      }
      else{
      emit(ErrorSendOtpState(error: '$l\n${'try_again'.translate()}'));}
    },
    (r) {
    emit(SuccessSendOtpState(isVerifyScreen: isVerifyScreen));
    DataStore.instance.setName(fullName??'');
    DataStore.instance.setPhone(phoneNumber??'');
    });
      } else{
         if ((DataStore.instance.token==null&&fullName==null) || phoneNumber==null) {
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
    (await tripsRepo.phoneVerify(phoneNumber!,code!,getHeaders: (p0) =>verifyHeaders=p0,
      )).fold((l) {
      emit(ErrorVerifyOtpState(error: l));
    },
    (r) {
      userModel=r.user;
      DataStore.instance.setToken(r.token);
     emit(SuccessVerifyOtpState());
    });
     if(verifyHeaders?['retry-after']?.first!=null){
     blockedDuration=verifyHeaders!['retry-after']!.first;
     String time=FunctionUtils().formattedTime(timeInSecond: int.parse(blockedDuration!));
     emit(BlockState(error:'${'block_msg'.translate()} \n $time ${'minute'.translate()}'));
     }
     }
    else{
      String? error;
     if(code.toString().length<6)error='code_valid'.translate();
     emit(ValidateVerifyOtpState(error:error));
  }}

  updateToSignUp({required bool updateLogin}){
    isLogin=updateLogin;
    emit(UpdateToSignUpState());
  }
}