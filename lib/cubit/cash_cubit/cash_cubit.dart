import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/data_resource/remote_resource/repo/payment_repo.dart';
import 'cash_states.dart';

class CashCubit extends Cubit<CashStates> {
  PaymentRepo paymentRepo;
  TextEditingController mtnPhoneController=TextEditingController();
  TextEditingController syriatelPhoneController=TextEditingController();

  CashCubit({required this.paymentRepo}) : super(CashInitialState());

}