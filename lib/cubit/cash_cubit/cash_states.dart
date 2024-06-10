abstract class CashStates{}
class CashInitialState extends CashStates{}
class LoadingSendCodeMtnState extends CashStates{}
class SuccessSendCodeMtnState extends CashStates{
  final bool? isVerifyScreen;

  SuccessSendCodeMtnState({required this.isVerifyScreen});
}
class ErrorSendCodeMtnState extends CashStates{
  final String error;
  ErrorSendCodeMtnState({required this.error});
}
class LoadingConfirmCodeMtnState extends CashStates{}
class SuccessConfirmCodeMtnState extends CashStates{}
class ErrorConfirmCodeMtnState extends CashStates{
  final String error;
  ErrorConfirmCodeMtnState({required this.error});
}
class LoadingSendCodeSyriatelState extends CashStates{}
class SuccessSendCodeSyriatelState extends CashStates{}
class ErrorSendCodeSyriatelState extends CashStates{
  final String error;
  ErrorSendCodeSyriatelState({required this.error});
}
class LoadingConfirmCodeSyriatelState extends CashStates{}
class SuccessConfirmCodeSyriatelState extends CashStates{}
class ErrorConfirmCodeSyriatelState extends CashStates{
  final String error;
  ErrorConfirmCodeSyriatelState({required this.error});
}
class LoadingResendCodeSyriatelState extends CashStates{}
class SuccessResendCodeSyriatelState extends CashStates{}
class ErrorResendCodeSyriatelState extends CashStates{
  final String error;
  ErrorResendCodeSyriatelState({required this.error});
}

class ValidatePhoneState extends CashStates{}
class ValidateCodeState extends CashStates{}