import 'package:flutter/material.dart';
import 'package:trips/data/data_resource/local_resource/data_store.dart';

import '../../../core/utils/app_router.dart';
import '../../style/app_images.dart';
import '../root_screens/root_screen.dart';
import 'base_onboarding.dart';

class ThirdOnBoardingScreen extends StatelessWidget {
  const ThirdOnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseOnBoardingScreen(
        urlImage: AppImages.onBoarding3Image,
        title: 'orem ipsum is  spam placeholder',
        subTitle: 'Lorem ipsum is a placeholder texta typeface without relying on meaningful content ',
        navigateToFun:() {
          DataStore.instance.setIsFirstTime(false);
          AppRouter.navigateReplacementTo(context: context, destination: const RootScreen());});
  }
}
