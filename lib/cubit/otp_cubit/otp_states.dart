abstract class OtpStates{}
class OtpInitialState extends OtpStates{}
class OtpInit2State extends OtpStates{}

class ValidateSendOtpState extends OtpStates{
  final String? error;

  ValidateSendOtpState({required this.error});
}
class LoadingSendOtpState extends OtpStates{}
class SuccessSendOtpState extends OtpStates{
  final bool? isVerifyScreen;

  SuccessSendOtpState({required this.isVerifyScreen});
}
class ErrorSendOtpState extends OtpStates{
  final String? error;
  ErrorSendOtpState({required this.error});
}

class ValidateVerifyOtpState extends OtpStates{
  final String? error;
  ValidateVerifyOtpState({required this.error});}

class BlockState extends OtpStates{
  final String? error;
  BlockState({required this.error});}

class LoadingVerifyOtpState extends OtpStates{}
class UpdateToSignUpState extends OtpStates{}

class SuccessVerifyOtpState extends OtpStates{}
class ErrorVerifyOtpState extends OtpStates{
  final String? error;
  ErrorVerifyOtpState({required this.error});
}
class AfterErrorFromTripDetailsState extends OtpStates{}