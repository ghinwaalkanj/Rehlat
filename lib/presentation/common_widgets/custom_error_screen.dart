import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../data/data_resource/local_resource/data_store.dart';
import '../style/app_font_size.dart';
import '../style/app_images.dart';
import '../style/app_text_style.dart';
import '../style/app_text_style_2.dart';
import 'custom_button.dart';

class CustomErrorScreen extends StatelessWidget {
  final Function()? onTap;
  const CustomErrorScreen({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Lottie.asset(AppImages.noInternetIcon,),
            const SizedBox(height: 20),
            CustomButton(
              onPressed: (){
                onTap!();
              },
              color: Colors.grey.shade300,
              text: 'Retry',
              textStyle:   AppTextStyle2.getBoldStyle(
              fontSize: AppFontSize.size_14,
              color:  Colors.black,
              fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
              w: 200.w,
            )
          ],
        ),
      );
  }
}
