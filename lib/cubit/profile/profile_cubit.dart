import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/core/utils/global.dart';
import 'package:trips/cubit/root/root_cubit.dart';
import 'package:trips/presentation/screens/profile_screens/screens/terms_conditions.dart';
import 'package:trips/presentation/screens/support_screens/screens/claim_screen.dart';

import '../../core/utils/app_regexp.dart';
import '../../core/utils/utils_functions.dart';
import '../../data/data_resource/local_resource/data_store.dart';
import '../../data/data_resource/remote_resource/repo/profile_repo.dart';
import '../../data/data_resource/remote_resource/repo/trips_repo.dart';
import '../../domain/models/profile_card_model.dart';
import '../../domain/models/profile_param.dart';
import '../../presentation/screens/profile_screens/screens/privacy_policy.dart';
import '../../presentation/screens/profile_screens/screens/user_profile_info.dart';
import '../../presentation/screens/profile_screens/widgets/language_dialog.dart';
import 'profile_states.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileRepo profileRepo;
  TextEditingController nameController =TextEditingController();
  TextEditingController ageController =TextEditingController();
  TextEditingController phoneController =TextEditingController();
  String? gender;
  String? errorText;
  ProfileParamModel? user;
  TripsRepo tripsRepo;
  String? code;
  String? blockedDuration;
  Headers? verifyHeaders;
  bool isPhoneChanged=false;
  ProfileParamModel profileParamModel=ProfileParamModel();

  ProfileCubit({required this.profileRepo,required this.tripsRepo}) : super(ProfileInitialState());

  List<ProfileCardModel> settingsList=[
  ProfileCardModel(title:'personal_information',screenDestination:()=>AppRouter.navigateTo(context: navigatorKey.currentContext!, destination: const UserProfileInfoScreen()) ),
  ProfileCardModel(title:'my_booking',screenDestination:()=> navigatorKey.currentContext!.read<RootPageCubit>().changePageIndex(1) ),
  ProfileCardModel(title:'terms_text',screenDestination:() =>AppRouter.navigateTo(context: navigatorKey.currentContext!, destination: const TermsScreen()) ),
  ProfileCardModel(title:'privacy_policy',screenDestination:()=>AppRouter.navigateTo(context: navigatorKey.currentContext!, destination: const PrivacyPolicyScreen()) ),
  ProfileCardModel(title:'technical_support',screenDestination:()=>AppRouter.navigateTo(context: navigatorKey.currentContext!, destination:const ClaimScreen())),
  ProfileCardModel(title:'language', screenDestination:()=> showDialog(
  context: navigatorKey.currentContext!,
    builder: (context) => const LanguageDialog(),
  ),),
];


  getProfile() async {
    emit(LoadingGetProfileState());
    (await profileRepo.getProfile()).fold((l) => emit(ErrorGetProfileState(error: l)),
            (r) {
              user=r;
          emit(SuccessGetProfileState());
              DataStore.instance.setName(r.name??'');
              DataStore.instance.setPhone(r.phone??'');
              DataStore.instance.setAge(r.age);
        });
  }

  defineUser(){
     nameController.text =user?.name??'';
     ageController.text =user?.age??'';
     phoneController.text=user?.phone??'';
  }

  requestUpdateProfile({required bool isVerifyScreen,}) async {
    bool isPhone=AppRegexp.phoneRegexp.hasMatch(phoneController.text);
    if(isPhone){
    emit(LoadingRequestUpdateProfileState());
    (await profileRepo.requestUpdateProfile()).fold((l) => emit(ErrorRequestUpdateProfileState(error: l)),
            (r) {
          emit(SuccessRequestUpdateProfileState(isVerifyScreen: isVerifyScreen));
        });}
    else{
      emit(ValidatePhoneState());
    }
  }

  updateProfile() async {
    errorText=null;
    isPhoneChanged=false;
    if(nameController.text.isNotEmpty  && nameController.text.isNotEmpty ){
     profileParamModel.name= nameController.text;
     profileParamModel.age= ageController.text;
     profileParamModel.phone= phoneController.text;
     profileParamModel.code= code;
    emit(LoadingUpdateProfileState());
    (await profileRepo.updateProfile(profileParamModel: profileParamModel)).fold((l) => emit(ErrorUpdateProfileState(error: l)),
            (r) {
              isPhoneChanged=user?.phone!=phoneController.text?true:false;
          emit(SuccessUpdateProfileState());
          DataStore.instance.setName(nameController.text);
          if(!isPhoneChanged)DataStore.instance.setPhone(phoneController.text);
          DataStore.instance.setAge(ageController.text);
         });
      }else{
      errorText='profile_validate'.translate();
      emit(ValidateProfileState());
    }
  }

  Future<void> verifyOtpWithPhone() async {
    if(code.toString().length==6 ){
      emit(LoadingProfileVerifyOtpState());
      (await profileRepo.verifyOtpProfile(code: code!,phone: phoneController.text,getHeaders: (p0) =>verifyHeaders=p0,)).fold((l) => emit(ErrorProfileVerifyOtpState(error: l)),
              (r) {
            emit(SuccessProfileVerifyOtpState());
            if(isPhoneChanged)DataStore.instance.setPhone(phoneController.text);
          });
      if(verifyHeaders?['retry-after']?.first!=null){
        blockedDuration=verifyHeaders!['retry-after']!.first;
        String time=FunctionUtils().formattedTime(timeInSecond: int.parse(blockedDuration!));
        emit(BlockProfileState(error:'${'block_msg'.translate()} \n $time ${'minute'.translate()}'));
      }
    }else{
      String? error;
      if(code.toString().length<6)error='code_valid'.translate();
      emit(ProfileValidateState(error));
    }
  }

  Future<void> verifyOtpWithoutPhone(context) async {
    if(code.toString().length==6 ){
      emit(LoadingProfileVerifyOtpState());
      (await tripsRepo.phoneVerify(phoneController.text,code!,getHeaders: (p0) =>verifyHeaders=p0,)).fold((l) => emit(ErrorProfileVerifyOtpState(error: l)),
              (r) {
            DataStore.instance.setToken(r.token);
            emit(SuccessProfileVerifyOtpState());
          });
      if(verifyHeaders?['retry-after']?.first!=null){
        blockedDuration=verifyHeaders!['retry-after']!.first;
        String time=FunctionUtils().formattedTime(timeInSecond: int.parse(blockedDuration!));
        emit(BlockProfileState(error:'${'block_msg'.translate()} \n $time ${'minute'.translate()}'));
      }
    }else{
      String? error;
      if(code.toString().length<6)error='code_valid'.translate();
      emit(ProfileValidateState(error));
    }
  }

  getChangeUpdate(){
    emit(UpdateLanguageState());
  }

}