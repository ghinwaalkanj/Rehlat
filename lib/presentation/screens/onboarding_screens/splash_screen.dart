import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/core/utils/image_helper.dart';
import 'package:trips/data/data_resource/local_resource/data_store.dart';
import 'package:trips/presentation/screens/onboarding_screens/root_onboarding_screen.dart';
import 'package:trips/presentation/style/app_images.dart';

import '../../../cubit/root/root_cubit.dart';
import '../root_screens/root_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 1, milliseconds: 3), () async {
      if (DataStore.instance.isFirstTime ) {
      AppRouter.navigateTo(context: context, destination: OnBoardingRootScreen());
      }
      else{
        AppRouter.navigateTo(context: context, destination: RootScreen());
        context.read<RootPageCubit>().checkEvaluation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Image.asset(AppImages.splashImage,fit: BoxFit.cover,
        width: double.infinity,
   ));
   }
}
