import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/presentation/screens/payment_mothod/screens/payment_methods_screens.dart';

import '../../../../core/utils/app_router.dart';
import '../../../../cubit/home/home_cubit.dart';
import '../../../../cubit/passenger_cubit/passenger_cubit.dart';
import '../../../../cubit/passenger_cubit/passenger_states.dart';
import '../../../../cubit/result_search_card/result_search_cubit.dart';
import '../../../../cubit/seats/seats_cubit.dart';
import '../../../../data/data_resource/local_resource/data_store.dart';
import '../../../common_widgets/base_app_bar.dart';
import '../../../common_widgets/dialog/error_dialog.dart';
import '../../../common_widgets/dialog/loading_dialog.dart';
import '../../../style/app_colors.dart';
import '../../../style/app_font_size.dart';
import '../../../style/app_text_style.dart';
import '../../../style/app_text_style_2.dart';
import '../../booking_trip/widgets/child_base_app_bar.dart';
import '../../booking_trip/widgets/success_reservation_dialog.dart';
import '../../booking_trip/widgets/time_widget.dart';
import '../../booking_trip/widgets/title_passenger_screen.dart';
import '../../root_screens/root_screen.dart';
import '../widgets/payment_details_card.dart';

class PaymentDetailsScreen extends StatelessWidget {
  const PaymentDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<PassengerCubit,PassengerStates>(
      listener: (context, state) {
        if(state is LoadingReserveSeatsState)LoadingDialog().openDialog(context);
        if(state is ErrorReserveSeatsState){
          LoadingDialog().closeDialog(context);
          ErrorDialog.openDialog(context, '${state.error} , \n${'try_again'.translate()}');}
        if(state is SuccessReserveSeatsState && context.read<PassengerCubit>().temp==true ){
          LoadingDialog().closeDialog(context);
          successReservationDialog(context: context,onConfirm: () {
            context.read<SeatsCubit>().timer?.cancel();
            context.read<SeatsCubit>().x='';
            context.read<ResultSearchCubit>().selectedTripModel?.repeatTime=0;
            if(context.read<HomeCubit>().returnDate!=null)  context.read<HomeCubit>().returnDateTime();
            AppRouter.navigateRemoveTo(context: context, destination: const RootScreen());
            context.read<PassengerCubit>().passengerList=[];
            context.read<PassengerCubit>().isSamePrimaryPassenger=false;
          });
      }
        if(state is SuccessReserveSeatsState && context.read<PassengerCubit>().temp==false ){
          LoadingDialog().closeDialog(context);
        AppRouter.navigateTo(context: context, destination:  PaymentMethodScreen(reservationId: context.read<PassengerCubit>().reservationId??0,fromPaymentDetails: true,));}
        },
      child: Scaffold(
          body: BaseAppBar(
              titleScreen: 'payment_option'.translate(),
              tripInfo: const PassengerTitleWidget(titleScreen: 'payment_option',),
              childAppBar: const ChildBaseAppBar(),
              child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                  Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(33))
                  ),
                        child:
                    SingleChildScrollView(
                      reverse: true,
                      child: Column(
                        children: [
                         const TimeRowWidget(),
                        Container(
                        color: AppColors.lightXXXGrey,
                        child: const SizedBox(
                       //     height: 620,
                            child: PaymentDetailsCard()),
                      ),
                      ]),
                    )
                    ),
                Row(
                  children: [
                    if(context.read<ResultSearchCubit>().selectedTripModel?.canReserveTemp != false)
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        context.read<PassengerCubit>().isSamePrimaryPassenger=false;
                       // if(context.read<ReserveTripCubit>().acceptTerms==true) {
                          context.read<PassengerCubit>().reserveSeats(isTemp:true,seatsIds:context.read<SeatsCubit>().seatsIds);
                        // } else {
                        //   ErrorDialog.openDialog(context, 'accept_terms'.translate());
                        // }
                        },
                          child: Container(
                              height: 80,
                              color: AppColors.white,
                              child: Center(child: Text('pay_later'.translate(),style: AppTextStyle.lightYellowW600_14,))),
                        )),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          context.read<PassengerCubit>().isSamePrimaryPassenger=false;
                     //     if(context.read<ReserveTripCubit>().acceptTerms==true) {
                            context.read<PassengerCubit>().reserveSeats(isTemp:false,seatsIds:context.read<SeatsCubit>().seatsIds);
                          // } else {
                          //   ErrorDialog.openDialog(context,'accept_terms'.translate());
                          // }
                        },
                        child: Container(
                          height: 80,
                          color: AppColors.darkGreen,
                          child: Center(child: Text('online_pay'.translate(),style:  AppTextStyle2.getSemiBoldStyle(
                            fontSize: AppFontSize.size_14,
                            color: Colors.white,
                            fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),)),
                        ),
                      ),
                    )
                  ],
                )
             ] )
      ),
    ));
  }
}