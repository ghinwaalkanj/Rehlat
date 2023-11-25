import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/presentation/screens/root_screens/root_screen.dart';

import '../../../../core/utils/image_helper.dart';
import '../../../../cubit/result_search_card/result_search_cubit.dart';
import '../../../../cubit/seats/seats_cubit.dart';
import '../../../common_widgets/dialog/action_alert_dialog.dart';
import '../../../style/app_images.dart';

cancelReservationDialog({required BuildContext context,}) {
  return ActionAlertDialog.show(
              context,
              imageUrl:const ImageWidget(url:  AppImages.errorDialogImage,width: 88,height: 88,fit: BoxFit.fill,).buildAssetSvgImage(),
              dialogTitle: 'cancel'.translate(),
              message: 'cancel_reservation_msg'.translate(),
              confirmText: "got_it".translate(),
              onConfirm: () {
                context.read<SeatsCubit>().seconds=null;
                context.read<SeatsCubit>().x='';
                context.read<SeatsCubit>().timer?.cancel();
                context.read<ResultSearchCubit>().selectedTripModel?.repeatTime=0;
                 context.read<ResultSearchCubit>().selectedTripModel?.repeatTime=0;
                 context.read<ResultSearchCubit>().selectedTripModel?.repeatTime=0;
                context.read<SeatsCubit>().unSelectSeats(context.read<SeatsCubit>().seatsIds);
                AppRouter.navigateRemoveTo(context: context, destination: const RootScreen());
              },);
  }