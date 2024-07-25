import 'package:flutter/material.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/presentation/common_widgets/custom_button.dart';
import 'package:trips/presentation/screens/profile_screens/screens/privacy_policy.dart';
import 'package:trips/presentation/style/app_colors.dart';
import 'package:trips/presentation/style/app_font_size.dart';
import 'package:trips/presentation/style/app_text_style_2.dart';

import '../../../../data/data_resource/local_resource/data_store.dart';

acceptTermsDialog({required BuildContext context,
  required  Function(bool) onConfirm,
  required  Function(bool) onCancel,
}) {
  return showDialog<bool>(
    context: context,
    useSafeArea: true,
    builder: (context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Stack(
               alignment: Alignment.bottomCenter,
               children: [
               const PrivacyPolicyScreen(),
                 Container(
                   color: Colors.white,
                   child: Padding(
                     padding: const EdgeInsets.symmetric(vertical: 20),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         CustomButton(
                             w: 100,
                             color: AppColors.primary,
                             text: 'accept'.translate(),
                             textStyle: AppTextStyle2.getSemiBoldStyle(
                               fontSize: AppFontSize.size_14,
                               color: Colors.white,
                               fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                               onPressed: () {
                               onConfirm(true);
                               //context.read<ReserveTripCubit>().acceptTermsFun(true);
                               Navigator.pop(context);},),
                         const SizedBox(width: 16,),
                         CustomButton(
                             w: 100,
                             color: AppColors.white,
                             text: 'reject'.translate(),
                             textStyle: AppTextStyle2.getSemiBoldStyle(
                               fontSize: AppFontSize.size_14,
                               color:AppColors.primary,
                               fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                             onPressed: () {
                               onConfirm(false);
                               Navigator.pop(context);},),
                       ],
                     ),
                   ),
                 )
                ],
        ),
      ),
    );
    },
  );
}