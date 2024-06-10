import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/presentation/common_widgets/base_verify_code_screen.dart';
import 'package:trips/presentation/common_widgets/dialog/error_dialog.dart';
import 'package:trips/presentation/common_widgets/dialog/loading_dialog.dart';
import 'package:trips/presentation/screens/root_screens/root_screen.dart';

import '../../../../../cubit/cash_cubit/cash_cubit.dart';
import '../../../../../cubit/cash_cubit/cash_states.dart';

class SyriatelOTPCodeScreen extends StatelessWidget {
  const SyriatelOTPCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CashCubit,CashStates>(
      bloc:  context.read<CashCubit>()..syriatelCode='',
      listener: (context, state)  {
        if(state is LoadingConfirmCodeSyriatelState){
          LoadingDialog().openDialog(context);}
        if(state is ValidateCodeState){
          ErrorDialog.openDialog(context, 'code_valid'.translate());
        }
        if(state is SuccessConfirmCodeSyriatelState){
          ErrorDialog.openDialog(context, 'pay_success'.translate());
          AppRouter.navigateRemoveTo(context: context, destination:  const RootScreen());
        }
        if(state is ErrorConfirmCodeSyriatelState){
          LoadingDialog().closeDialog(context);
          ErrorDialog.openDialog(context, state.error);
        }
      },
      builder: (context, state) => BaseOTPCodeScreen(
        onTap: () {context.read<CashCubit>().confirmCodeSyriatel();},
        onResend: () {context.read<CashCubit>().sendCodeSyriatel();},
        phoneNumber:context.read<CashCubit>().syriatelPhoneController.text,
        isErrorState: false,
        code: context.read<CashCubit>().syriatelCode??'',
        getCode:(code){context.read<CashCubit>().syriatelCode=code;} ,
      ),
    );
  }
}