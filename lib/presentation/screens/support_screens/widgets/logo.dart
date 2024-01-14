import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../style/app_images.dart';

class LogoWidget extends StatelessWidget {
  final double? padding;
  const LogoWidget({Key? key,this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded,
              size: 30,
            )),
         SizedBox(width:padding?? 0.15.sw,),
        Center(child: Image.asset(AppImages.darkLogoImage,height: 200,width: 200, fit: BoxFit.cover)),
      ],
    );
  }
}
