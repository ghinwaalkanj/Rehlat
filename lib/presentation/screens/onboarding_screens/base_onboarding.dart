import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../cubit/onboarding/onboarding_cubit.dart';
import '../../../cubit/onboarding/onboarding_states.dart';
import '../../../data/data_resource/local_resource/data_store.dart';
import '../../style/app_colors.dart';
import '../../style/app_font_size.dart';
import '../../style/app_text_style_2.dart';

class BaseOnBoardingScreen extends StatelessWidget {
  final String urlImage;
  final String title;
  final String subTitle;
  final VoidCallback navigateToFun;

  const BaseOnBoardingScreen(
      {Key? key,
      required this.urlImage,
      required this.title,
      required this.subTitle,
      required this.navigateToFun,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnBoardingCubit, OnBoardingStates>(
      listener: (context, state) {},
      builder:(context, state) => Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    urlImage,
                    width: double.infinity,
                    fit: BoxFit.fill,
                    height: 530.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 33.0),
                    child: Column(
                      children: [
                        Text(
                          title,
                          style:  AppTextStyle2.getBoldStyle(
                            fontSize: AppFontSize.size_32,
                            color:  Colors.black,
                            fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)
                        ),
                        SizedBox(
                          height: 32.h,
                        ),
                        Text(
                          subTitle,
                          style:   AppTextStyle2.getRegularStyle(
                          fontSize: AppFontSize.size_16,
                          color:  Colors.black,
                          fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)
                        ),
                      //  const Spacer(),
                        Padding(
                          padding:  EdgeInsets.only(bottom: 22.0,top: 0.07.sh),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 7,
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) => Container(
                                        height: 7,
                                        width: 20,
                                        decoration:  BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: context.read<OnBoardingCubit>().index==index?AppColors.primary:AppColors.gray,
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(4)))),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                          width: 4,
                                        ),
                                    itemCount: 3),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: navigateToFun,
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.primary,
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: FloatingActionButton(
                                      onPressed: navigateToFun,
                                      backgroundColor: AppColors.primary,
                                      child: const Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
