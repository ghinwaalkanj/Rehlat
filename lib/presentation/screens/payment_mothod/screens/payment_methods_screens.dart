import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/cubit/payment_methods/payment_method_cubit.dart';
import 'package:trips/cubit/payment_methods/payment_method_states.dart';
import 'package:trips/presentation/common_widgets/custom_error_screen.dart';
import 'package:trips/presentation/screens/payment_mothod/widgets/payment_card.dart';

import '../../../style/app_text_style.dart';
import '../../root_screens/root_screen.dart';
import '../../support_screens/widgets/logo.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentMethodCubit,PaymentMethodStates>(
      bloc: context.read<PaymentMethodCubit>()..getPaymentMethods(),
      builder: (context, state) => Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              const LogoWidget(),
              const SizedBox(height: 20,),
              (state is LoadingGetPaymentMethodsState)
                  ? const CircularProgressIndicator()
                  : (state is ErrorGetPaymentMethodsState)
                  ?  CustomErrorScreen(onTap:() => context.read<PaymentMethodCubit>().getPaymentMethods())
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('payment_method'.translate(),style: AppTextStyle.lightBlackW400_16,),
                      const SizedBox(height: 20,),
                      ListView.separated(
                           padding: EdgeInsets.zero,
                           shrinkWrap:true,
                          itemBuilder: (context, index) => PaymentMethodCard(paymentMethodsModel:context.read<PaymentMethodCubit>().paymentMethodsList[index] ),
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
    );
  }
}