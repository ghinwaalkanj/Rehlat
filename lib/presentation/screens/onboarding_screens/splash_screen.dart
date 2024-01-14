import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/core/utils/global.dart';
import 'package:trips/cubit/root/root_cubit.dart';
import 'package:trips/data/data_resource/local_resource/data_store.dart';
import 'package:trips/presentation/screens/onboarding_screens/root_onboarding_screen.dart';
import 'package:trips/presentation/screens/root_screens/root_screen.dart';
import 'package:trips/presentation/style/app_colors.dart';
import 'package:trips/presentation/style/app_images.dart';
import 'package:trips/presentation/style/app_text_style_2.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  getVersion() async {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      getVersion();
    Timer(const Duration(seconds: 1, milliseconds: 3), () async {
      if (DataStore.instance.isFirstTime ) {
      AppRouter.navigateTo(context: context, destination: const OnBoardingRootScreen());
      }
      else{
        AppRouter.navigateTo(context: context, destination: const RootScreen());
        context.read<RootPageCubit>().checkEvaluation();
        context.read<RootPageCubit>().sendLang();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:
      Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image.asset(AppImages.splashImage,fit: BoxFit.cover,
            width: double.infinity,),
          Padding(
            padding: const EdgeInsets.only(bottom: 33.0),
            child: Text('${'version'.translate()} ${packageInfo?.version ?? ''}',
                style: AppTextStyle2.getRegularStyle(
                color: AppColors.white,
                fontSize: 16,
                fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
          ),
        ],
      ));
   }
}


