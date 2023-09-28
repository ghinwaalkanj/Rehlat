import 'package:flutter/material.dart';
import 'package:trips/core/localization/app_localization.dart';
import '../../../../core/utils/image_helper.dart';
import '../../../../data/data_resource/local_resource/data_store.dart';
import '../../../common_widgets/custom_button.dart';
import '../../../common_widgets/dialog/custom_dialog.dart';
import '../../../common_widgets/dialog/dialog_transition_builder.dart';
import '../../../style/app_colors.dart';
import '../../../style/app_font_size.dart';
import '../../../style/app_images.dart';
import '../../../style/app_text_style_2.dart';
class EditProfileSuccess {
  static void openDialog(BuildContext context, String? message, VoidCallback onTap,{bool? verifySuccess}) {
    dialogTransitionBuilder(
        context,
        _EditProfileSuccessBody(
          message: message,
          onTap:onTap,
          verifySuccess:verifySuccess ,
        ));
  }
}

class _EditProfileSuccessBody extends StatelessWidget {
  const _EditProfileSuccessBody({Key? key,this.onTap, this.message,this.verifySuccess=false}) : super(key: key);
  final String? message;
  final VoidCallback? onTap;
  final bool? verifySuccess;
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50,),
          if(verifySuccess==true)  const ImageWidget(url: AppImages.successDialogImage,width: 88,height: 88,fit: BoxFit.fill,).buildAssetSvgImage(),
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
              textStyle:  AppTextStyle2.getSemiBoldStyle(
                  fontSize: AppFontSize.size_14,
                  color: AppColors.xBlack,
                  fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
              text: "continue_to_confirm".translate(),
              color: AppColors.darkGreen,
              onPressed: onTap!,
            ),
          ),
        ],
      ),
    );
  }
}
