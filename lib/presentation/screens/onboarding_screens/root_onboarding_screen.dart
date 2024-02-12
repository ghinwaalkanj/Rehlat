import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/presentation/screens/onboarding_screens/second_onboarding_screen.dart';
import 'package:trips/presentation/screens/onboarding_screens/third_onboarding_screen.dart';

import '../../../cubit/onboarding/onboarding_cubit.dart';
import '../../../cubit/onboarding/onboarding_states.dart';
import 'first_onboarding_screen.dart';

class OnBoardingRootScreen extends StatelessWidget {
  const OnBoardingRootScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnBoardingCubit, OnBoardingStates>(
      listener: (context, state) {},
      builder:(context, state) =>   PageView.builder(
        onPageChanged: (int index){
          context.read<OnBoardingCubit>().changeIndex(index);
        },
        physics: const BouncingScrollPhysics(),
        controller: context.read<OnBoardingCubit>().pageController,
        itemBuilder:(context,index){
         if(index==0) {
           return const FirstOnBoardingScreen();
         } else if(index==1) {
           return const SecondOnBoardingScreen();
         } else {
           return const ThirdOnBoardingScreen();
         }
        },
        itemCount: 3,
      ),
    );
  }
}
