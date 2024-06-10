import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/data_resource/remote_resource/repo/payment_repo.dart';
import 'cash_states.dart';

class CashCubit extends Cubit<CashStates> {
  PaymentRepo paymentRepo;
  TextEditingController mtnPhoneController=TextEditingController();
  TextEditingController syriatelPhoneController=TextEditingController();
  String? mtnCode;
  String? syriatelCode;
  String? mtnOperationNumber;
  String? transId;
  int? reservationId;

  CashCubit({required this.paymentRepo}) : super(CashInitialState());

  sendCodeMtn({required bool isVerifyScreen}) async {
    if(mtnPhoneController.text.isNotEmpty&&mtnPhoneController.text.startsWith('9')&&mtnPhoneController.text.length==9 ){
    emit(LoadingSendCodeMtnState());
    (await paymentRepo.sendCodeMtn(reservationId: reservationId!, phone: '963${mtnPhoneController.text}')).fold((l) => emit(ErrorSendCodeMtnState(error: l)),
            (r) {
              mtnOperationNumber=r.toString();
          emit(SuccessSendCodeMtnState(isVerifyScreen: isVerifyScreen));
        });
  }
    else{
      emit(ValidatePhoneState());
    }
  }

  confirmCodeMtn() async {
    if(mtnCode?.length==6){
    emit(LoadingConfirmCodeMtnState());
    (await paymentRepo.confirmCodeMtn(operationNumber: mtnOperationNumber!, code:mtnCode!)).fold((l) => emit(ErrorConfirmCodeMtnState(error: l)),
            (r) {
          emit(SuccessConfirmCodeMtnState());
        });
  }
    else{
      emit(ValidateCodeState());
    }
  }

  sendCodeSyriatel() async {
    if(syriatelPhoneController.text.isNotEmpty&&syriatelPhoneController.text.startsWith('9')&&syriatelPhoneController.text.length==9 ){
      emit(LoadingSendCodeSyriatelState());
      (await paymentRepo.sendCodeSyriatel(reservationId: reservationId!, phone: '963${syriatelPhoneController.text}')).fold((l) => emit(ErrorSendCodeSyriatelState(error: l)),
              (r) {
                transId=r.toString();
            emit(SuccessSendCodeSyriatelState());
          });
    }
    else{
      emit(ValidatePhoneState());
    }
  }

  confirmCodeSyriatel() async {
    if(syriatelCode?.length==6){
      emit(LoadingConfirmCodeSyriatelState());
      (await paymentRepo.confirmCodeSyriatel(transId: transId!, code:syriatelCode!,phoneNumber: syriatelPhoneController.text)).fold((l) => emit(ErrorConfirmCodeSyriatelState(error: l)),
              (r) {
            emit(SuccessConfirmCodeSyriatelState());
          });
    }
    else{
      emit(ValidateCodeState());
    }
  }

  resendCodeSyriatel() async {
      emit(LoadingResendCodeSyriatelState());
      (await paymentRepo.sendCodeMtn(reservationId: reservationId!, phone: '963${mtnPhoneController.text}')).fold((l) => emit(ErrorResendCodeSyriatelState(error: l)),
              (r) {
            mtnOperationNumber=r.toString();
            emit(SuccessResendCodeSyriatelState());
          });
  }

clearValues(){
    mtnPhoneController.clear();
    syriatelPhoneController.clear();
    mtnCode=null;
    syriatelCode=null;
}
}