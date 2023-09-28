import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/core/utils/global.dart';
import '../../core/utils/app_regexp.dart';
import '../../data/data_resource/local_resource/data_store.dart';
import '../../data/data_resource/remote_resource/repo/profile_repo.dart';
import '../../data/data_resource/remote_resource/repo/trips_repo.dart';
import '../../domain/models/profile_card_model.dart';
import '../../domain/models/profile_param.dart';
import '../../presentation/screens/booking/booking_screen/root_booking_screen.dart';
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
  ProfileParamModel profileParamModel=ProfileParamModel();

  ProfileCubit({required this.profileRepo,required this.tripsRepo}) : super(ProfileInitialState());

  List<ProfileCardModel> settingsList=[
  ProfileCardModel(title:'personal_information',screenDestination:()=>AppRouter.navigateTo(context: navigatorKey.currentContext!, destination: UserProfileInfoScreen()) ),
  ProfileCardModel(title:'my_booking',screenDestination:()=>AppRouter.navigateTo(context: navigatorKey.currentContext!, destination:BookingScreen (notExistArrow: false,)) ),
  ProfileCardModel(title:'cards',screenDestination:() {} ),
  ProfileCardModel(title:'about_us',screenDestination:() {} ),
  ProfileCardModel(title:'privacy_policy',screenDestination:() {} ),
  ProfileCardModel(title:'language', screenDestination:()=> showDialog(
  context: navigatorKey.currentContext!,
    builder: (context) => LanguageDialog(),
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

  requestUpdateProfile({required bool isVerifyScreen}) async {
    bool isPhone=AppRegexp.phoneRegexp.hasMatch(phoneController.text??'');
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

  updateProfile(context) async {
    errorText=null;
    if(nameController.text.isNotEmpty  && nameController.text.isNotEmpty ){
     profileParamModel.name= nameController.text;
     profileParamModel.age= ageController.text;
     profileParamModel.phone= phoneController.text;
     profileParamModel.code= code;
    emit(LoadingUpdateProfileState());
    (await profileRepo.updateProfile(profileParamModel: profileParamModel)).fold((l) => emit(ErrorUpdateProfileState(error: l)),
            (r) {
          emit(SuccessUpdateProfileState());
          DataStore.instance.setName(nameController.text);
          DataStore.instance.setPhone(phoneController.text);
          DataStore.instance.setAge(ageController.text);
         });
      }else{
      errorText='profile_validate'.translate();
      emit(ValidateProfileState());
    }
  }

  checkPhone(context){
    print('phoneController.text');
    print(phoneController.text);
    print(user?.phone);
    print(user?.phone==phoneController.text);
    (user?.phone==phoneController.text)?verifyOtpWithoutPhone(context):verifyOtpWithPhone(context);
  }

  Future<void> verifyOtpWithPhone(context) async {
    if(code.toString().length==6 ){
      emit(LoadingProfileVerifyOtpState());
      (await profileRepo.verifyOtpProfile(code: code!,phone: phoneController.text)).fold((l) => emit(ErrorProfileVerifyOtpState(error: l)),
              (r) {
           // userModel=r.user;
          //  DataStore.instance.setToken(r.token);
            print(  DataStore.instance.token);
            emit(SuccessProfileVerifyOtpState());
            updateProfile(context);
          });
    }else{
      String? error;
      if(code.toString().length<6)error='code_valid'.translate();
      emit(ProfileValidateState(error));
    }
  }

  Future<void> verifyOtpWithoutPhone(context) async {
    if(code.toString().length==6 ){
      emit(LoadingProfileVerifyOtpState());
      (await tripsRepo.phoneVerify(phoneController.text,code!)).fold((l) => emit(ErrorProfileVerifyOtpState(error: l)),
              (r) {
           // userModel=r.user;
            DataStore.instance.setToken(r.token);
            print(  DataStore.instance.token);
            emit(SuccessProfileVerifyOtpState());
            updateProfile(context);

          });
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