import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/data/data_resource/local_resource/data_store.dart';
import 'package:trips/presentation/common_widgets/base_app_bar.dart';
import 'package:trips/presentation/style/app_colors.dart';
import '../../../../cubit/home/home_cubit.dart';
import '../../../../cubit/passenger_cubit/passenger_cubit.dart';
import '../../../../cubit/passenger_cubit/passenger_states.dart';
import '../../../common_widgets/dialog/error_dialog.dart';
import '../../../style/app_font_size.dart';
import '../../../style/app_text_style_2.dart';
import '../../payment/screens/payment_details_screen.dart';
import '../widgets/cancel_reservation_dialog.dart';
import '../widgets/child_base_app_bar.dart';
import '../widgets/passenger_info_card.dart';
import '../widgets/time_widget.dart';

class PassengersInfoScreens extends StatelessWidget {
  const PassengersInfoScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PassengerCubit,PassengerStates>(
      listener: (context, state) {
        if(state is ErrorValidatePassengersState) ErrorDialog.openDialog(context, 'passenger_validate'.translate());
        if(state is ErrorSamePassengerValidState) ErrorDialog.openDialog(context, state.error);
        if(state is SuccessValidatePassengersState) AppRouter.navigateTo(context: context, destination: const PaymentDetailsScreen());
        },
      builder: (context, state) => Scaffold(
        resizeToAvoidBottomInset: true,
        body:
        BaseAppBar(
          titleScreen: '',
          tripInfo:Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 2,),
                  InkWell(
                      onTap:()=>Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_outlined,color: Colors.white)),
                  const SizedBox(width: 16,),
                  Text('passenger_information'.translate(),style:  AppTextStyle2.getSemiBoldStyle(
                    fontSize: AppFontSize.size_16,
                    color: Colors.white,
                    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
                 const Spacer(),
                  InkWell(
                      onTap: () => cancelReservationDialog(context:context ),
                      child: Text('cancel'.translate(),style: AppTextStyle2.getSemiBoldStyle(
                        fontSize: AppFontSize.size_14,
                        color: Colors.white,
                        fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),)),
                  const SizedBox(width: 16,),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text('${'welcome'.translate()} ${DataStore.instance.name}',style: AppTextStyle2.getSemiBoldStyle(
                  fontSize: AppFontSize.size_14,
                  color: Colors.white,
                  fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
              ),
            ],
          ) ,
          childAppBar: const ChildBaseAppBar(),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
             Column(
               children: [
                 const TimeRowWidget(),
                 Expanded(
                   child: Padding(
                    padding: const EdgeInsets.only(left: 13.0,right:13,top: 8,bottom: 30),
                    child: ListView.separated(
                         padding: EdgeInsets.zero,
                        itemBuilder: (context, index) => PassengerInfoCard(
                            passengerModel:context.read<PassengerCubit>().passengerList[index] ,
                             index: index,),
                         separatorBuilder: (context, index) => const SizedBox(height: 24,),
                        itemCount:  context.read<PassengerCubit>().isSamePrimaryPassenger?1:int.parse(context.read<HomeCubit>().searchTripParam.passenger??'0')),
                    ),
                 ),
               ],
             ),
              InkWell(
                onTap: () {
                  context.read<PassengerCubit>().isSamePrimaryPassenger? {
                  context.read<PassengerCubit>().changeSamePrimary(context.read<PassengerCubit>().isSamePrimaryPassenger,context.read<PassengerCubit>().passengerList[0],int.parse(context.read<HomeCubit>().passengers??'0')),
                    if( context.read<PassengerCubit>().isNavigate) AppRouter.navigateTo(context: context, destination: const PaymentDetailsScreen())
                  }: {
                     context.read<PassengerCubit>().validatePassenger(context.read<HomeCubit>().passengers??'0'),
                  } ;},
                 child: Container(
                  height: 60,
                  width: double.infinity,
                  color: AppColors.darkGreen,
                  child: Center(
                    child: Text('continue_booking'.translate(),
                    style: AppTextStyle2.getSemiBoldStyle(
                    fontSize: AppFontSize.size_14,
                    color: Colors.white,
                    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              )
          ]),
        ),
      ),
    );
  }
}