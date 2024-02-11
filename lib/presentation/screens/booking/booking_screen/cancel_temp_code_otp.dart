import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_router.dart';

import '../../../../cubit/booking/booking_cubit.dart';
import '../../../../cubit/booking/booking_states.dart';
import '../../../../data/data_resource/local_resource/data_store.dart';
import '../../../../data/model/booking_trip_model.dart';
import '../../../common_widgets/base_verify_code_screen.dart';
import '../../../common_widgets/dialog/error_dialog.dart';
import '../../../common_widgets/dialog/loading_dialog.dart';
import '../../root_screens/root_screen.dart';

class CancelTempCodeScreen extends StatelessWidget {
  final BookingTripModel  bookingTripModel ;
  const CancelTempCodeScreen({Key? key,required this.bookingTripModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SmsAutoFill().listenForCode();
    return BlocConsumer<BookingCubit,BookingStates>(
      bloc:  context.read<BookingCubit>()..code='',
      listener: (context, state) async {
       if(state is SuccessCancelTempState)
         {
           context.read<BookingCubit>().code='';
           LoadingDialog().closeDialog(context);
           ErrorDialog.openDialog(context,'cancel_temp_success'.translate(),verifySuccess: true);
           AppRouter.navigateTo(context: context, destination: const RootScreen());
      }
       if(state is LoadingCancelTempState) LoadingDialog().openDialog(context);
        if(state is ErrorCancelTempState){
          LoadingDialog().closeDialog(context);
          ErrorDialog.openDialog(context,state.error);
          await SmsAutoFill().listenForCode();
        }
      },
      builder: (context, state) => BaseOTPCodeScreen(
        onTap: () {context.read<BookingCubit>().cancelTempBooking(bookingTripModel: bookingTripModel,);},
        onResend: () {context.read<BookingCubit>().requestCancelTempBooking(bookingTripModel: bookingTripModel,isBookingScreen: false);},
        phoneNumber:DataStore.instance.phone??'' ,
        isErrorState: false,
        code: context.read<BookingCubit>().code,
        getCode:(code){context.read<BookingCubit>().code=code;} ,
      ),
    );
  }
}