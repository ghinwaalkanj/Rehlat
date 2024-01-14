import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/cubit/home/home_cubit.dart';
import 'package:trips/presentation/screens/root_screens/root_screen.dart';

import '../../core/utils/app_router.dart';
import '../../cubit/result_search_card/result_search_cubit.dart';
import '../../cubit/seats/seats_cubit.dart';
import '../style/app_images.dart';
import 'dialog/action_alert_dialog.dart';

timeOverDialog({required BuildContext context,required bool isPressedOption,required bool isHideDialog,}) {
  return ActionAlertDialog.show(
      context,
      imageUrl: Image.asset(context.read<ResultSearchCubit>().selectedTripModel?.repeatTime==0?AppImages.timeOverIcon:AppImages.clockIcon,width: 88,height: 88, ),
      dialogTitle: context.read<ResultSearchCubit>().selectedTripModel?.repeatTime==0?'time_over'.translate():'extended_time_over'.translate(),
      message:context.read<ResultSearchCubit>().selectedTripModel?.repeatTime==0?
      '${'time_over_msg'.translate()} ${context.read<HomeCubit>().extraTimer!.inMinutes} ${'time_over_msg2'.translate()}'
          :'extended_time_over_msg'.translate(),
      hideDialog:()=>Future.delayed(const Duration(seconds:30,),
      () => isHideDialog= context.read<SeatsCubit>().isHideDialog,
      ).then((value) {
          ((isPressedOption)||(isHideDialog==true))?debugPrint('$isHideDialog'):{
          context.read<SeatsCubit>().cancelTimer(),
          SchedulerBinding.instance.addPostFrameCallback((_) {
            context.read<ResultSearchCubit>().selectedTripModel?.repeatTime=0;
            context.read<SeatsCubit>().unSelectSeats(context.read<SeatsCubit>().seatsIds);
            AppRouter.navigateRemoveTo(context: context, destination: const RootScreen());
          }),};
      }),
      onWillPopScope:()=>context.read<ResultSearchCubit>().selectedTripModel?.repeatTime!=1
          ? {
           isPressedOption=true,
            context.read<SeatsCubit>().seconds= context.read<HomeCubit>().extraTimer,
            context.read<SeatsCubit>().x='',
            context.read<SeatsCubit>().startTime(true),
            context.read<ResultSearchCubit>().selectedTripModel?.repeatTime=1,
            Navigator.pop(context),}
          : {
            isPressedOption=true,
            context.read<SeatsCubit>().seconds=null,
            context.read<SeatsCubit>().x='',
            context.read<ResultSearchCubit>().selectedTripModel?.repeatTime=0,
            context.read<SeatsCubit>().unSelectSeats(context.read<SeatsCubit>().seatsIds),
            AppRouter.navigateRemoveTo(context: context, destination: const RootScreen()),},
            cancelText:  context.read<ResultSearchCubit>().selectedTripModel?.repeatTime!=1?'cancel'.translate():'ok'.translate(),
            confirmText:context.read<ResultSearchCubit>().selectedTripModel?.repeatTime!=1?'ok'.translate():null,
          onCancel: () {
            isPressedOption=true;
            context.read<SeatsCubit>().seconds=null;
            context.read<SeatsCubit>().x='';
            context.read<ResultSearchCubit>().selectedTripModel?.repeatTime=0;
            context.read<SeatsCubit>().unSelectSeats(context.read<SeatsCubit>().seatsIds);
            AppRouter.navigateRemoveTo(context: context, destination: const RootScreen());},
          onConfirm: () {
         isPressedOption=true;
        if(context.read<ResultSearchCubit>().selectedTripModel?.repeatTime!=1){
          context.read<SeatsCubit>().seconds= context.read<HomeCubit>().extraTimer;
        context.read<SeatsCubit>().x='';
        context.read<SeatsCubit>().startTime(true);
        context.read<ResultSearchCubit>().selectedTripModel?.repeatTime=1;
        Navigator.pop(context);
        }
        else{
          context.read<SeatsCubit>().seconds=null;
          context.read<SeatsCubit>().x='';
          context.read<ResultSearchCubit>().selectedTripModel?.repeatTime=0;
          context.read<SeatsCubit>().unSelectSeats(context.read<SeatsCubit>().seatsIds);
          AppRouter.navigateRemoveTo(context: context, destination: const RootScreen());
        }
      }
  );
}

