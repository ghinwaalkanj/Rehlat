import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/presentation/common_widgets/base_verify_code_screen.dart';
import 'package:trips/presentation/common_widgets/dialog/error_dialog.dart';
import 'package:trips/presentation/common_widgets/dialog/loading_dialog.dart';

import '../../../../../cubit/cash_cubit/cash_cubit.dart';
import '../../../../../cubit/cash_cubit/cash_states.dart';

class MtnOTPCodeScreen extends StatelessWidget {
  const MtnOTPCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CashCubit,CashStates>(
      bloc:  context.read<CashCubit>()..mtnCode='',
      listener: (context, state)  {
        if(state is LoadingConfirmCodeMtnState){
          LoadingDialog().openDialog(context);}
        if(state is ValidateCodeState){
          ErrorDialog.openDialog(context, 'code_valid'.translate());
        }
        if(state is SuccessConfirmCodeMtnState){
          ErrorDialog.openDialog(context,'profile_send_otp'.translate(),verifySuccess: true);
        }
        if(state is ErrorConfirmCodeMtnState){
          LoadingDialog().closeDialog(context);
          ErrorDialog.openDialog(context, state.error);
        }
      },
      builder: (context, state) => BaseOTPCodeScreen(
        onTap: () {context.read<CashCubit>().confirmCodeMtn();},
        onResend: () {context.read<CashCubit>().sendCodeMtn();},
        phoneNumber:context.read<CashCubit>().mtnPhoneController.text,
        isErrorState: false,
        code: context.read<CashCubit>().mtnCode??'',
        getCode:(code){context.read<CashCubit>().mtnCode=code;} ,
      ),
    );
  }
}