import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import '../../../../cubit/booking/booking_cubit.dart';
import '../../../../cubit/booking/booking_states.dart';
import '../../../../data/data_resource/local_resource/data_store.dart';
import '../../../../data/model/booking_trip_model.dart';
import '../../../common_widgets/base_verify_code_screen.dart';
import '../../../common_widgets/dialog/error_dialog.dart';
import '../../../common_widgets/dialog/loading_dialog.dart';

class BookingOTPCodeScreen extends StatelessWidget {
 final BookingTripModel  bookingTripModel ;
  const BookingOTPCodeScreen({Key? key,required this.bookingTripModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit,BookingStates>(
          bloc:  context.read<BookingCubit>()..code='',
          listener: (context, state) {
            if(state is SuccessRequestConfirmReservationState) ErrorDialog.openDialog(context,'profile_send_otp'.translate(),verifySuccess: true);
            if(state is ErrorConfirmReservationState) LoadingDialog().closeDialog(context);
          },
          builder: (context, state) => BaseOTPCodeScreen(
        onTap: () {context.read<BookingCubit>().confirmReservation(bookingTripModel,context.read<BookingCubit>().code);},
        onResend: () {context.read<BookingCubit>().verifyCodeBooking(bookingTripModel: bookingTripModel,isBookingScreen: false);},
        phoneNumber:DataStore.instance.phone??'' ,
        isErrorState: false,
            code: context.read<BookingCubit>().code,
        getCode:(code){context.read<BookingCubit>().code=code;} ,
      ),
    );
  }
}