import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/global.dart';
import 'package:trips/cubit/seats/seats_cubit.dart';
import 'package:trips/data/data_resource/local_resource/data_store.dart';
import 'package:trips/presentation/screens/root_screens/home_screen/screen/home_screen.dart';

import '../../../core/utils/app_router.dart';
import '../../../core/utils/enums.dart';
import '../../../cubit/home/home_cubit.dart';
import '../../../cubit/result_search_card/result_search_cubit.dart';
import '../../../cubit/root/root_cubit.dart';
import '../../../cubit/root/root_states.dart';
import '../../common_widgets/dialog/action_alert_dialog.dart';
import '../../common_widgets/dialog/error_dialog.dart';
import '../../common_widgets/dialog/loading_dialog.dart';
import '../../style/app_colors.dart';
import '../../style/app_font_size.dart';
import '../../style/app_text_style.dart';
import '../../style/app_text_style_2.dart';
import '../booking/booking_screen/root_booking_screen.dart';
import '../evaluation_dialogs/evaluation_dialog2.dart';
import '../evaluation_dialogs/thanks_dialog.dart';
import '../profile_screens/screens/profile_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen>  with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
@override
  void dispose() {
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    context.read<SeatsCubit>().x='';
    context.read<SeatsCubit>().cancelTimer();
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        DataStore.instance.setResumeTime(DateTime.now());
        navigatorKey.currentContext!.read<SeatsCubit>().stateCycleApp=StateType.active;
        if(navigatorKey.currentContext!.read<SeatsCubit>().x!='') {
          navigatorKey.currentContext!.read<SeatsCubit>().timerAfterResume(repeatTime: navigatorKey.currentContext!.read<ResultSearchCubit>().selectedTripModel?.repeatTime??0,
          extraTime: navigatorKey.currentContext!.read<HomeCubit>().extraTimer,
          time: navigatorKey.currentContext!.read<HomeCubit>().timer
        );}
        break;
      case AppLifecycleState.inactive:
        navigatorKey.currentContext!.read<SeatsCubit>().stateCycleApp=StateType.inActive;
        break;
      case AppLifecycleState.paused:
         navigatorKey.currentContext!.read<SeatsCubit>().stateCycleApp=StateType.inActive;
        Future.delayed(navigatorKey.currentContext!.read<SeatsCubit>().seconds??const Duration()).then((value) {
          if(navigatorKey.currentContext!.read<SeatsCubit>().x=='00:00'&& navigatorKey.currentContext!.read<SeatsCubit>().stateCycleApp==StateType.inActive) {
          navigatorKey.currentContext!.read<SeatsCubit>().x ='';
          navigatorKey.currentContext!.read<SeatsCubit>().cancelTimer();
          navigatorKey.currentContext!.read<SeatsCubit>().isHideDialog=true;
          navigatorKey.currentContext!.read<SeatsCubit>().unSelectSeats(navigatorKey.currentContext!.read<SeatsCubit>().seatsIds);
          AppRouter.navigateRemoveTo(context: navigatorKey.currentContext!,destination: const RootScreen());
          }});
        break;
      case AppLifecycleState.detached:
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RootPageCubit, RootPageStates>(
      listener: (context, state) {
        if(context.read<RootPageCubit>().tripModel!=null) evalAnimatedDialog(context: context,);
        if(state is LoadingRateTripState)  LoadingDialog().openDialog(context);
        if(state is ErrorRateTripState){
          LoadingDialog().closeDialog(context);
          ErrorDialog.openDialog(context, 'error_evaluation'.translate());
          evalAnimatedDialog(context: context);}
        if(state is SuccessRateTripState){
          LoadingDialog().closeDialog(context);
          thanksDialog(context: context);
        }
        },
      builder:(context, state) => WillPopScope(
        onWillPop: ()async {
           if(context.read<RootPageCubit>().index==0){
            ActionAlertDialog.show(
              context,
              buttonStyle:  AppTextStyle2.getMediumStyle(
                    fontSize: AppFontSize.size_16,
                    color:  Colors.black,
                    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',) ,
              titleStyle:   AppTextStyle2.getMediumStyle(
                  fontSize: AppFontSize.size_16,
                  color:  Colors.black,
                  fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
              onConfirm: () => SystemNavigator.pop(),
              onCancel: () => Navigator.pop(context),
                dialogTitle: 'msg_exit'.translate(),
              cancelText:'cancel'.translate() ,
              confirmText: 'confirm'.translate(),
             confirmFillColor: AppColors.darkGreen
            );
          }
          else{
            context.read<RootPageCubit>().changePageIndex(0);
          }
          return false;
        },
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            selectedLabelStyle: AppTextStyle.primaryW600_14,
            currentIndex:context.read<RootPageCubit>().index ,
            selectedItemColor:AppColors.primary,
            unselectedItemColor:AppColors.gray,
              onTap: (value) =>context.read<RootPageCubit>().changePageIndex(value),
              items: [
                BottomNavigationBarItem(
                    label: 'home'.translate(),
                    icon: const Icon(Icons.home_rounded)),
                BottomNavigationBarItem(
                    label: 'bookings'.translate(),
                    icon: const Icon(Icons.calendar_today_outlined)),
                BottomNavigationBarItem(
                    label: 'profile'.translate(),
                    icon: const Icon(Icons.account_circle_outlined)),
              ]),
          body: (context.read<RootPageCubit>().index==0)
                ? const HomeScreen()
                : (context.read<RootPageCubit>().index==1)
                ? const BookingScreen()
                : const ProfileScreen(),
        ),
      ),
    );
  }
}
