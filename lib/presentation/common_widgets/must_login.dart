import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/data/data_resource/local_resource/data_store.dart';
import 'package:trips/presentation/common_widgets/custom_button.dart';
import 'package:trips/presentation/screens/verify_screen/send_otp_screen.dart';
import 'package:trips/presentation/style/app_colors.dart';
import 'package:trips/presentation/style/app_font_size.dart';
import 'package:trips/presentation/style/app_images.dart';
import 'package:trips/presentation/style/app_text_style_2.dart';

class MustLoginScreen extends StatelessWidget {
  const MustLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppImages.warningImage,height: 100,width: 120),
          const SizedBox(height: 40,),
          Text('first_login'.translate(), style: AppTextStyle2.getSemiBoldStyle(
            fontSize: AppFontSize.size_14,
            color: Colors.black,
            fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
          const SizedBox(height: 40,),
            CustomButton(
                w: 0.5.sw,
                h: 50,
                color: AppColors.darkGreen,
                text: 'go_login'.translate(),
                textStyle: AppTextStyle2.getSemiBoldStyle(color: AppColors.white, fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',
                fontSize: 16
                ),
                onPressed: () {
                  AppRouter.navigateTo(context: context, destination: const SendPhoneScreen(isFromSettings: true,));
                },)
        ],
      ),
    );
  }
}
