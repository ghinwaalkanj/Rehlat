import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';

import '../../../cubit/onboarding/onboarding_cubit.dart';
import '../../style/app_images.dart';
import 'base_onboarding.dart';

class FirstOnBoardingScreen extends StatelessWidget {
  const FirstOnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseOnBoardingScreen(
        urlImage: AppImages.onBoarding1Image,
        title: '',
        subTitle: 'boarding1'.translate(),
        navigateToFun:() {
          context.read<OnBoardingCubit>().pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn);});
  }
}
