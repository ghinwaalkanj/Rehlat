import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/cubit/payment_methods/payment_method_cubit.dart';
import 'package:trips/cubit/payment_methods/payment_method_states.dart';
import 'package:trips/presentation/common_widgets/custom_error_screen.dart';
import 'package:trips/presentation/screens/booking_trip/widgets/cancel_reservation_dialog.dart';
import 'package:trips/presentation/screens/payment_mothod/widgets/payment_card.dart';
import 'package:trips/presentation/style/app_colors.dart';

import '../../../style/app_text_style.dart';
import '../../root_screens/root_screen.dart';
import '../../support_screens/widgets/logo.dart';

class PaymentMethodScreen extends StatelessWidget {
  final int reservationId;
  final bool  fromPaymentDetails;
  const PaymentMethodScreen({Key? key, required this.reservationId,  this.fromPaymentDetails=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentMethodCubit,PaymentMethodStates>(
      bloc: context.read<PaymentMethodCubit>()..getPaymentMethods(),
      builder: (context, state) => WillPopScope(
        onWillPop: () async {
          if(fromPaymentDetails) {
            cancelReservationDialog(context: context,message: 'cancel_payment'.translate());
            return false;
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const LogoWidget(),
                  const SizedBox(height: 20,),
                  (state is LoadingGetPaymentMethodsState)
                      ? const CircularProgressIndicator(color: AppColors.darkGreen)
                      : (state is ErrorGetPaymentMethodsState)
                      ?  CustomErrorScreen(onTap:() => context.read<PaymentMethodCubit>().getPaymentMethods())
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('payment_method'.translate(),style: AppTextStyle.lightBlackW400_16,),
                          const SizedBox(height: 20,),
                          ListView.separated(
                               physics: const NeverScrollableScrollPhysics(),
                               padding: EdgeInsets.zero,
                               shrinkWrap:true,
                              itemBuilder: (context, index) => PaymentMethodCard(paymentMethodsModel:context.read<PaymentMethodCubit>().paymentMethodsList[index],reservationId: reservationId  ,index: index, ),
                              separatorBuilder:(context, index) => const SizedBox(height: 12,),
                              itemCount: context.read<PaymentMethodCubit>().paymentMethodsList.length),
                          const SizedBox(height: 30,),
                          InkWell(
                              onTap: () => AppRouter.navigateRemoveTo(context: context, destination: const RootScreen()),
                              child: Center(child: Text('back_to_home'.translate(),style: AppTextStyle.blackW500_14Underline,))),
                        ],
                      )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}