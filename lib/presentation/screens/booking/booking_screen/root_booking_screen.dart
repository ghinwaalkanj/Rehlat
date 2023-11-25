import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/cubit/booking/booking_states.dart';
import 'package:trips/presentation/common_widgets/base_app_bar.dart';
import 'package:trips/presentation/common_widgets/custom_error_screen.dart';
import 'package:trips/presentation/screens/booking/booking_screen/temp_booking.dart';

import '../../../../core/utils/app_router.dart';
import '../../../../cubit/booking/booking_cubit.dart';
import '../../../../data/data_resource/local_resource/data_store.dart';
import '../../../common_widgets/dialog/error_dialog.dart';
import '../../../common_widgets/dialog/loading_dialog.dart';
import '../../../style/app_colors.dart';
import '../../../style/app_font_size.dart';
import '../../../style/app_text_style_2.dart';
import '../../notification/screens/notification_screen.dart';
import 'code_otp_booking.dart';
import 'confirmed_booking.dart';
import 'history_booking.dart';

class BookingScreen extends StatelessWidget {
  final bool notExistArrow;
  const BookingScreen({Key? key, this.notExistArrow=true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return    BlocConsumer<BookingCubit,BookingStates>(
      bloc: context.read<BookingCubit>()..getBookingList(),
      listener: (context, state) {
        if(state is LoadingConfirmReservationState)LoadingDialog().openDialog(context);
        if(state is LoadingRequestConfirmReservationState)LoadingDialog().openDialog(context);
        if(state is SuccessRequestConfirmReservationState){
          LoadingDialog().closeDialog(context);
          if(state.isBookingScreen ==true)AppRouter.navigateTo(context: context, destination: BookingOTPCodeScreen(bookingTripModel: state.bookingTripModel,));}
        if(state is ErrorRequestConfirmReservationState){
          LoadingDialog().closeDialog(context);
         }
        if(state is SuccessConfirmReservationState){
          LoadingDialog().closeDialog(context);
          Navigator.pop(context);
          ErrorDialog.openDialog(context,'success_confirm_temp'.translate(),verifySuccess: true );
        }
        if(state is ErrorConfirmReservationState){
          LoadingDialog().closeDialog(context);
          ErrorDialog.openDialog(context,state.error );}
    },
    builder: (context, state) => BaseAppBar(
      titleScreen:'bookings'.translate() ,
      rightIcon: (DataStore.instance.token?.isNotEmpty??false)?
      InkWell(
        onTap: () => AppRouter.navigateTo(context:context, destination: const NotificationScreen()) ,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0,),
          child: Icon(Icons.notifications_none_rounded,color: Colors.white,size: 30),
        ),
      ):null,
      notExistArrow: notExistArrow,
      child: Column(
      children: [
        DefaultTabController(
          length: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 22),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: AppColors.lightGreyX,
                  borderRadius: BorderRadius.all(Radius.circular(91))
              ),
              child: TabBar(
                labelPadding: EdgeInsets.zero,
                   padding: EdgeInsets.zero,
                  isScrollable:DataStore.instance.lang=='en'?true:false,
                  indicatorColor:Colors.transparent ,
                  onTap: (value)=> context.read<BookingCubit>().changeBookingPage(value) ,
                  tabs: [
                    Container(
                      decoration:   BoxDecoration(
                          color: (context.read<BookingCubit>().index==0)?AppColors.darkYellow:Colors.transparent,
                          borderRadius: const BorderRadius.all(Radius.circular(57))
                      ),
                      child: Tab(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 23.0),
                            child: Text('confirmed'.translate(),style: (context.read<BookingCubit>().index==0)?  AppTextStyle2.getSemiBoldStyle(
                              fontSize: AppFontSize.size_14,
                              color: Colors.white,
                              fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',): AppTextStyle2.getSemiBoldStyle(
                              fontSize: AppFontSize.size_14,
                              color:  Colors.black,
                              fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                          )),
                    ),
                    Container(
                      decoration:   BoxDecoration(
                          color: (context.read<BookingCubit>().index==1)?AppColors.darkYellow:Colors.transparent,
                          borderRadius: const BorderRadius.all(Radius.circular(57))
                      ),
                      child: Tab(
                          child: Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 23.0),
                            child: Text('temporary'.translate(),style: (context.read<BookingCubit>().index==1)?  AppTextStyle2.getSemiBoldStyle(
                            fontSize: AppFontSize.size_14,
                            color: Colors.white,
                            fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',): AppTextStyle2.getSemiBoldStyle(
                            fontSize: AppFontSize.size_14,
                            color:  Colors.black,
                            fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                          )),
                    ),
                    Container(
                      decoration:   BoxDecoration(
                          color: (context.read<BookingCubit>().index==2)?AppColors.darkYellow:Colors.transparent,
                          borderRadius: const BorderRadius.all(Radius.circular(57))
                      ),
                      child: Tab(
                          child: Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 33.0),
                            child: Text('history'.translate(),style: (context.read<BookingCubit>().index==2)?  AppTextStyle2.getSemiBoldStyle(
                            fontSize: AppFontSize.size_14,
                            color: Colors.white,
                            fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',): AppTextStyle2.getSemiBoldStyle(
                            fontSize: AppFontSize.size_14,
                            color:  Colors.black,
                            fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                          )),
                    ),
                  ]),
            ),
          ),
        ),
           if(context.read<BookingCubit>().isError)CustomErrorScreen(onTap: () => context.read<BookingCubit>()..getBookingList(),),
            if(!context.read<BookingCubit>().isError)...[
            if(context.read<BookingCubit>().index==0) ConfirmedBookingScreen(contextx: context),
              if(context.read<BookingCubit>().index==1)const TempBookingScreen(),
            if(context.read<BookingCubit>().index==2)const HistoryBookingScreen(),
             ]
      ],
    ),
    ),
    );
  }
}
