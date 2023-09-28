import 'package:flutter/material.dart';
import 'package:trips/presentation/style/app_images.dart';
import 'package:trips/presentation/style/app_text_style.dart';
import '../../../../../data/data_resource/local_resource/data_store.dart';
import '../../../../common_widgets/custom_button.dart';
import '../../../../style/app_colors.dart';
import '../../../../style/app_font_size.dart';
import '../../../../style/app_text_style_2.dart';

class NoTripScreen extends StatelessWidget {
  final String title;
  final String subTitle;
  final String buttonTitle;
  final VoidCallback  onPressed;

  const NoTripScreen({Key? key, required this.title, required this.subTitle, required this.buttonTitle,required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.noTripImage),
            const SizedBox(height: 47,),
            Text(title,style: AppTextStyle.lightBlackW700_21),
            const SizedBox(height: 12,),
            Text(subTitle,style: AppTextStyle.lightBlackW400_16,),
            const SizedBox(height: 24,),
            CustomButton(
              h: 55,
              w: 166,
              radius: 32,
              color: AppColors.darkYellow,
              text: buttonTitle,
               textStyle: AppTextStyle2.getSemiBoldStyle(
                    fontSize: AppFontSize.size_14,
                    color: Colors.white,
                    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
              onPressed:onPressed),
          ],
        ),
      ),
    );
  }
}
