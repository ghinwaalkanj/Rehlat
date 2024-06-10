import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:trips/core/localization/app_localization.dart';

import '../../data/data_resource/local_resource/data_store.dart';
import '../style/app_font_size.dart';
import '../style/app_images.dart';
import '../style/app_text_style_2.dart';
import 'custom_button.dart';

class CustomErrorScreen extends StatelessWidget {
  final Function()? onTap;
  final String? error;
  const CustomErrorScreen({super.key, required this.onTap, this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Lottie.asset(AppImages.noInternetIcon,),
            if(error!=null)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(error!,
              textAlign: TextAlign.center,
              style: AppTextStyle2.getSemiBoldStyle(
                fontSize: AppFontSize.size_14,
                color: Colors.black,
                fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: CustomButton(
                onPressed: (){
                  onTap!();
                },
                color: Colors.grey.shade300,
                text: 'Retry'.translate(),
                textStyle:   AppTextStyle2.getBoldStyle(
                fontSize: AppFontSize.size_14,
                color:  Colors.black,
                fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                w: 200.w,
              ),
            )
          ],
        ),
      );
  }
}
