
import 'package:flutter/material.dart';
import 'package:trips/core/localization/app_localization.dart';

import '../../../core/utils/image_helper.dart';
import '../../../data/data_resource/local_resource/data_store.dart';
import '../../style/app_colors.dart';
import '../../style/app_font_size.dart';
import '../../style/app_images.dart';
import '../../style/app_text_style_2.dart';
import '../custom_button.dart';
import 'custom_dialog.dart';
import 'dialog_transition_builder.dart';

class ErrorDialog {
  static void openDialog(BuildContext context, String? message, {bool? verifySuccess}) {
    dialogTransitionBuilder(
        context,
        _ErrorDialogBody(
          message: message,
          verifySuccess:verifySuccess ,
        ));
  }
}

class _ErrorDialogBody extends StatelessWidget {
  const _ErrorDialogBody({Key? key, this.message,this.verifySuccess=false}) : super(key: key);
  final String? message;
  final bool? verifySuccess;
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50,),
         if(verifySuccess==true) const ImageWidget(url: AppImages.successDialogImage,width: 88,height: 88,fit: BoxFit.fill,).buildAssetSvgImage(),
          Padding(
            padding:  EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical:verifySuccess==true?20: 60,
            ),
            child: Center(
              child: Text(
                  (message == null || message!.isEmpty)
                      ? "try_again".translate()
                      : message!,
                   style: AppTextStyle2.getSemiBoldStyle(
                      fontSize: AppFontSize.size_14,
                      color: Colors.black,
                      fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
              textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              textStyle: AppTextStyle2.getSemiBoldStyle(
                fontSize: AppFontSize.size_14,
                color: Colors.white,
                fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
              text: "close".translate(),
              color: AppColors.darkGreen,
              onPressed:  () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
