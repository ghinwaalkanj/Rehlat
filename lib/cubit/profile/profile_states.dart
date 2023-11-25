abstract class ProfileStates{}
class ProfileInitialState extends ProfileStates{}

class LoadingGetProfileState extends ProfileStates{}
class SuccessGetProfileState extends ProfileStates{}
class ErrorGetProfileState extends ProfileStates{
  final String? error;
  ErrorGetProfileState({required this.error});
}

class UpdateLanguageState extends ProfileStates{}
class ValidateProfileState extends ProfileStates{}
class LoadingUpdateProfileState extends ProfileStates{}
class SuccessUpdateProfileState extends ProfileStates{}
class ErrorUpdateProfileState extends ProfileStates{
  final String? error;
  ErrorUpdateProfileState({required this.error});
}

class ValidatePhoneState extends ProfileStates{}
class LoadingRequestUpdateProfileState extends ProfileStates{}
class SuccessRequestUpdateProfileState extends ProfileStates{
  final bool isVerifyScreen;

  SuccessRequestUpdateProfileState({required this.isVerifyScreen});
}
class ErrorRequestUpdateProfileState extends ProfileStates{
  final String? error;
  ErrorRequestUpdateProfileState({required this.error});
}

class ProfileValidateState extends ProfileStates{
  final String? error;

  ProfileValidateState(this.error);
}
class LoadingProfileVerifyOtpState extends ProfileStates{}
class SuccessProfileVerifyOtpState extends ProfileStates{}
class ErrorProfileVerifyOtpState extends ProfileStates{
  final String? error;
  ErrorProfileVerifyOtpState({required this.error});
}
class BlockProfileState extends ProfileStates{
  final String? error;
  BlockProfileState({required this.error});
}