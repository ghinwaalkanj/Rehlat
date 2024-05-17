import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/cubit/cash_cubit/cash_cubit.dart';
import 'package:trips/cubit/cash_cubit/cash_states.dart';
import 'package:trips/presentation/common_widgets/dialog/error_dialog.dart';
import 'package:trips/presentation/common_widgets/dialog/loading_dialog.dart';
import 'package:trips/presentation/screens/payment_mothod/screens/base_cash_screen.dart';

class SyriatelCashScreen extends StatelessWidget {
  const SyriatelCashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<CashCubit,CashStates>(
      bloc: context.read<CashCubit>()..clearValues() ,
      listener: (context, state) {
        if(state is LoadingSendCodeSyriatelState) LoadingDialog().openDialog(context);
        if(state is ErrorSendCodeSyriatelState){
          LoadingDialog().closeDialog(context);
          ErrorDialog.openDialog(context, state.error);}
        if(state is SuccessSendCodeSyriatelState){
          LoadingDialog().closeDialog(context);
          //  AppRouter.navigateTo(context: context, destination: VerifyOTPScreen(isFromSettings: isFromSettings,));
        }
      },
      child: BaseCashScreen(
        titleScreen: 'pay_syriatel'.translate(),
        phoneController: context.read<CashCubit>().syriatelPhoneController,
        onChanged: (value) {},
        onConfirm: () {
        },),
    );
  }
}
