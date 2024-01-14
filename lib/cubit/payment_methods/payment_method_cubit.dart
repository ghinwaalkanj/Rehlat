import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/cubit/payment_methods/payment_method_states.dart';
import 'package:trips/data/data_resource/remote_resource/repo/payment_repo.dart';

import '../../data/model/payment_model.dart';

class PaymentMethodCubit extends Cubit<PaymentMethodStates> {
  PaymentRepo paymentRepo;
  List<PaymentMethodsModel> paymentMethodsList=[];
  PaymentMethodCubit({required this.paymentRepo}) : super(PaymentMethodInitialState());

 getPaymentMethods() async {
  emit(LoadingGetPaymentMethodsState());
  (await paymentRepo.getPaymentMethods()).fold((l) => emit(ErrorGetPaymentMethodsState(error: l)),
  (r) {
   paymentMethodsList=r;
  emit(SuccessGetPaymentMethodsState());
  });
 }

}