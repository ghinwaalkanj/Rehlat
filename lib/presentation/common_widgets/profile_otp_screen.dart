import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/core/utils/image_helper.dart';
import 'package:trips/cubit/root/root_cubit.dart';
import 'package:trips/presentation/common_widgets/dialog/error_dialog.dart';
import 'package:trips/presentation/common_widgets/dialog/loading_dialog.dart';
import 'package:trips/presentation/common_widgets/verify_code_widget.dart';
import 'package:trips/presentation/screens/profile_screens/screens/edit_profile_screen.dart';
import 'package:trips/presentation/screens/root_screens/root_screen.dart';

import '../../../data/data_resource/local_resource/data_store.dart';
import '../../cubit/profile/profile_cubit.dart';
import '../../cubit/profile/profile_states.dart';
import '../style/app_colors.dart';
import '../style/app_font_size.dart';
import '../style/app_images.dart';
import '../style/app_text_style.dart';
import '../style/app_text_style_2.dart';
import 'custom_button.dart';

class ProfileOTPCodeScreen extends StatelessWidget {
 const ProfileOTPCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SmsAutoFill().listenForCode();
    return BlocConsumer<ProfileCubit,ProfileStates>(
      bloc:  context.read<ProfileCubit>()..code=null,
      listener: (context, state) async {
        if(state is ErrorUpdateProfileState&&context.read<ProfileCubit>().isPhoneChanged==true){
          LoadingDialog().closeDialog(context);
          ErrorDialog.openDialog(context, state.error);}
        if(state is SuccessUpdateProfileState&&context.read<ProfileCubit>().isPhoneChanged==true){
          LoadingDialog().closeDialog(context);
          ErrorDialog.openDialog(context,'code_new_number'.translate(),verifySuccess: true);
        }
        if(state is BlockProfileState){ErrorDialog.openDialog(context, state.error);}
         if(state is SuccessUpdateProfileState && context.read<ProfileCubit>().isPhoneChanged==true){
          LoadingDialog().closeDialog(context);
          context.read<ProfileCubit>().code=null;
        }
        if(state is ErrorUpdateProfileState && context.read<ProfileCubit>().isPhoneChanged==true){
          LoadingDialog().closeDialog(context);
          ErrorDialog.openDialog(context,state.error);
        }
        if(state is ProfileValidateState){ErrorDialog.openDialog(context, state.error);}
        if(state is LoadingProfileVerifyOtpState)LoadingDialog().openDialog(context);
        if(state is ErrorProfileVerifyOtpState){
          LoadingDialog().closeDialog(context);
          ErrorDialog.openDialog(context,state.error);
          await SmsAutoFill().listenForCode();
        }
        if(state is SuccessProfileVerifyOtpState){
          LoadingDialog().closeDialog(context);
          context.read<RootPageCubit>().changePageIndex(0);
          AppRouter.navigateRemoveTo(context: context, destination: const RootScreen());
          ErrorDialog.openDialog(context,'update_profile_success'.translate(),verifySuccess: true);
        }
        },
      builder: (context, state) =>  Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const VerifyCodeWidget(),
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
                        Text(context.read<ProfileCubit>().isPhoneChanged==true?context.read<ProfileCubit>().phoneController.text:context.read<ProfileCubit>().user?.phone??'',style: AppTextStyle.lightBlackW400_13Underline,),
                      ],
                    ),
                  const SizedBox(height: 24,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 18),
                    child: PinFieldAutoFill(
                        decoration:CirclePinDecoration(
                            bgColorBuilder: FixedColorBuilder(AppColors.lightXBlue.withOpacity(0.15)),
                            strokeColorBuilder:  FixedColorBuilder((state is ErrorProfileVerifyOtpState)?AppColors.red2:AppColors.darkGreen)),
                        currentCode: context.read<ProfileCubit>().code,
                        codeLength: 6,
                        onCodeSubmitted: (p0) {
                          context.read<ProfileCubit>().code= p0;
                          context.read<ProfileCubit>().isPhoneChanged?context.read<ProfileCubit>().verifyOtpWithPhone():context.read<ProfileCubit>().updateProfile();
                        },
                        onCodeChanged: (String? code) {
                       context.read<ProfileCubit>().code = code!;
                          if(code.characters.length==6){
                            context.read<ProfileCubit>().isPhoneChanged?context.read<ProfileCubit>().verifyOtpWithPhone():context.read<ProfileCubit>().updateProfile();}
                        }),
                  ),
                  const SizedBox(height: 32,),
                  if(state is ErrorProfileVerifyOtpState) Text('code_error'.translate(),style: AppTextStyle.redBold_14,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(state is ErrorProfileVerifyOtpState) Text('code_error2'.translate(),style: AppTextStyle.redBold_14,),
                      if(state is ErrorProfileVerifyOtpState) InkWell(
                          onTap: () =>AppRouter.navigateRemoveTo(context: context, destination: const EditProfileScreen()),
                          child: Text('change_phone'.translate(),style: AppTextStyle.redBold_14.copyWith(decoration: TextDecoration.underline,color: Colors.black),)),
                    ],
                  ),
                  if(state is ErrorProfileVerifyOtpState) Padding(
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
                    onPressed: () => context.read<ProfileCubit>().isPhoneChanged?context.read<ProfileCubit>().verifyOtpWithPhone():context.read<ProfileCubit>().updateProfile(),
                  ),
                  const SizedBox(height: 14,),
                  if(context.read<ProfileCubit>().isPhoneChanged==false)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      Text('receive_code'.translate(),style: AppTextStyle.lightGreyW400_16,),
                      InkWell(
                          onTap: () => context.read<ProfileCubit>().requestUpdateProfile(isVerifyScreen: true) ,
                          child: Text('resend_code'.translate(),style: AppTextStyle.lightBlackW400_16Underline,)),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}