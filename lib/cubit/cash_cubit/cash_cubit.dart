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
  int? reservationId;

  CashCubit({required this.paymentRepo}) : super(CashInitialState());

  sendCodeMtn() async {
    if(mtnPhoneController.text.isNotEmpty&&mtnPhoneController.text.startsWith('9') ){
    emit(LoadingSendCodeMtnState());
    (await paymentRepo.sendCodeMtn(reservationId: reservationId!, phone: '963${mtnPhoneController.text}')).fold((l) => emit(ErrorSendCodeMtnState(error: l)),
            (r) {
              mtnOperationNumber=r.toString();
          emit(SuccessSendCodeMtnState());
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

clearValues(){
    mtnPhoneController.clear();
    syriatelPhoneController.clear();
    mtnCode=null;
    syriatelCode=null;
}
}