import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/cubit/cash_cubit/cash_cubit.dart';
import 'package:trips/cubit/cash_cubit/cash_states.dart';
import 'package:trips/presentation/common_widgets/dialog/error_dialog.dart';
import 'package:trips/presentation/common_widgets/dialog/loading_dialog.dart';
import 'package:trips/presentation/screens/payment_mothod/screens/base_cash_screen.dart';

class MtnCashScreen extends StatelessWidget {
  const MtnCashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CashCubit,CashStates>(
      listener: (context, state) {
          if(state is LoadingSendCodeMtnState) LoadingDialog().openDialog(context);
          if(state is ErrorSendCodeMtnState){
            LoadingDialog().closeDialog(context);
            ErrorDialog.openDialog(context, state.error);}
          if(state is SuccessSendCodeMtnState){
            LoadingDialog().closeDialog(context);
          //  AppRouter.navigateTo(context: context, destination: VerifyOTPScreen(isFromSettings: isFromSettings,));
        }
      },
      builder:(context, state) =>  BaseCashScreen(
          titleScreen: 'pay_mtn'.translate(),
          phoneController: context.read<CashCubit>().mtnPhoneController,
          onChanged: (value) {},
          onConfirm: () {
          },),
    );
  }
}
