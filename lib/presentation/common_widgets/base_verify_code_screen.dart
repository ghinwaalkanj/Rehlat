import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/core/utils/image_helper.dart';
import 'package:trips/presentation/screens/verify_screen/send_otp_screen.dart';
import '../../../data/data_resource/local_resource/data_store.dart';
import '../../cubit/profile/profile_cubit.dart';
import '../style/app_colors.dart';
import '../style/app_font_size.dart';
import '../style/app_images.dart';
import '../style/app_text_style.dart';
import '../style/app_text_style_2.dart';
import 'custom_button.dart';

class BaseOTPCodeScreen extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onResend;
  final bool isErrorState;
  final String phoneNumber;
  final String code;
   Function(String value) getCode;
   BaseOTPCodeScreen({Key? key,required this.getCode,required this.onTap,required this.isErrorState,required this.onResend, required this.phoneNumber, required this.code,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40,),
                Image.asset(AppImages.darkLogoImage,fit: BoxFit.fill),
                Text('verify_phone'.translate(),style:   AppTextStyle2.getBoldStyle(
                  fontSize: AppFontSize.size_26,
                  color:  Colors.black,
                  fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('enter_code'.translate(),style: AppTextStyle.lightBlackW400_13.copyWith(
                        fontFamily: DataStore.instance.lang=='ar'?'Tajawal-Regular':null
                    ),),
                    Text(phoneNumber,style: AppTextStyle.lightBlackW400_13Underline,),
                  ],
                ),
                const SizedBox(height: 24,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PinFieldAutoFill(
                      decoration:CirclePinDecoration(
                          bgColorBuilder: FixedColorBuilder(AppColors.lightXBlue.withOpacity(0.15)),
                          strokeColorBuilder:  FixedColorBuilder((isErrorState)?AppColors.red2:AppColors.darkGreen)),
                      currentCode: code,
                      codeLength: 6,
                      onCodeSubmitted: (p0) {
                        getCode(p0);
                        onTap();
                      },
                      onCodeChanged: (String? code) {
                        getCode(code!);
                        if(code.characters.length==6)onTap();
                      }),
                ),
                const SizedBox(height: 32,),
                if(isErrorState) Text('code_error'.translate(),style: AppTextStyle.redBold_14,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(isErrorState) Text('code_error2'.translate(),style: AppTextStyle.redBold_14,),
                    if(isErrorState) InkWell(
                        onTap: () =>AppRouter.navigateRemoveTo(context: context, destination: const SendPhoneScreen()),
                        child: Text('change_phone'.translate(),style: AppTextStyle.redBold_14.copyWith(decoration: TextDecoration.underline,color: Colors.black),)),
                  ],
                ),
                if(isErrorState) Padding(
                  padding: const EdgeInsets.symmetric(vertical: 36.0),
                  child: const ImageWidget(url: AppImages.errorCodeIcon).buildAssetSvgImage(),
                ),
                CustomButton(
                  h: 55,
                  w: 300,
                  radius: 32,
                  color: AppColors.darkGreen,
                  text: 'confirm'.translate(),
                  textStyle: AppTextStyle2.getSemiBoldStyle(
                    fontSize: AppFontSize.size_14,
                    color: Colors.white,
                    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                    onPressed: onTap,
                ),
                const SizedBox(height: 14,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    Text('receive_code'.translate(),style: AppTextStyle.lightGreyW400_16,),
                    InkWell(
                        onTap: onResend,
                        child: Text('resend_code'.translate(),style: AppTextStyle.lightBlackW400_16Underline,)),
                  ],
                ),
              ],
            ),
          ),
        ),
    );
  }
}