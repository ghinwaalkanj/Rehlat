import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/presentation/common_widgets/dialog/error_dialog.dart';
import 'package:trips/presentation/common_widgets/dialog/loading_dialog.dart';
import 'package:trips/presentation/screens/verify_screen/verify_otp_screen.dart';
import '../../../cubit/otp_cubit/otp_cubit.dart';
import '../../../cubit/otp_cubit/otp_states.dart';
import '../../../data/data_resource/local_resource/data_store.dart';
import '../../common_widgets/auth_text_form_field.dart';
import '../../common_widgets/custom_button.dart';
import '../../style/app_colors.dart';
import '../../style/app_font_size.dart';
import '../../style/app_images.dart';
import '../../style/app_text_style_2.dart';

class SendPhoneScreen extends StatelessWidget {
  const SendPhoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpCubit,OtpStates>(
      listener: (context, state) {
        if(state is ValidateSendOtpState)ErrorDialog.openDialog(context, state.error);
        if(state is LoadingSendOtpState)LoadingDialog().openDialog(context);
        if(state is ErrorSendOtpState){
          LoadingDialog().closeDialog(context);
          ErrorDialog.openDialog(context, '${state.error},${'try_again'.translate()}');}
        if(state is SuccessSendOtpState){
          LoadingDialog().closeDialog(context);
         if (state.isVerifyScreen==false)AppRouter.navigateTo(context: context, destination: VerifyOTPScreen());
         if (state.isVerifyScreen==true)ErrorDialog.openDialog(context,'success_resend_otp'.translate(),verifySuccess: true );
        }
      },
      builder: (context, state) =>  Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40,),
                Image.asset(AppImages.darkLogoImage,fit: BoxFit.fill),
                Text('verify_phone'.translate(),style: AppTextStyle2.getSemiBoldStyle(
                    color: Colors.black,
                    fontSize: AppFontSize.size_26,
                    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
                const SizedBox(height: 10,),
                Text('enter_phone'.translate(),style: AppTextStyle2.getRegularStyle(
                  color: AppColors.lightBlack,
                  fontSize: AppFontSize.size_13,
                  fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
                const SizedBox(height: 24,),
                if(DataStore.instance.token==null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: AuthTextFormField(
                      controller:context.read<OtpCubit>().nameController ,
                      labelText: 'full_name'.translate(),
                      labelStyle: AppTextStyle2.getBoldStyle(
                        fontSize: AppFontSize.size_14,
                        color: AppColors.lightXGreen,
                        fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                      borderRadius: 16,
                      fillColor: Colors.transparent,
                      borderColor: AppColors.lightXGreen,
                    onChanged: (value) =>context.read<OtpCubit>().fullName = value,
                  ),
                ),
                const SizedBox(height: 24,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: AuthTextFormField(
                    controller:context.read<OtpCubit>().phoneController ,
                    keyboardType: TextInputType.phone,
                    // prefixIcon: DataStore.instance.lang=='en'? CountryCodePicker(
                    //   onChanged: (value) =>context.read<OtpCubit>().code=value.code,
                    //   padding: EdgeInsets.symmetric(horizontal: 12),
                    //   showDropDownButton: true,
                    //   enabled: false,
                    //   initialSelection: 'SY',
                    //   favorite: ['+963','SY'],
                    //    showCountryOnly: false,
                    //    showOnlyCountryWhenClosed: false,
                    //    alignLeft: false,
                    // ):null,
                    // suffixIcon:DataStore.instance.lang=='ar'? Directionality(
                    //   textDirection: TextDirection.ltr,
                    //   child: CountryCodePicker(
                    //     onChanged: (value) =>context.read<OtpCubit>().code=value.code,
                    //     padding: EdgeInsets.symmetric(horizontal: 12),
                    //     showDropDownButton: true,
                    //     enabled: false,
                    //     initialSelection: 'SY',
                    //     textStyle: TextStyle(locale: Locale('en') ),
                    //     favorite: ['SY','+963',],
                    //     showCountryOnly: false,
                    //     showOnlyCountryWhenClosed: false,
                    //     alignLeft: false,
                    //   ),
                    // ):null,
                    borderRadius: 16,
                    fillColor: Colors.transparent,
                    borderColor: AppColors.lightXGreen,
                    hintText: '09xxxxxxxx',
                    onChanged: (value) =>context.read<OtpCubit>().phoneNumber = value,
                  ),
                ),
                const SizedBox(height: 32,),
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
                  //AppTextStyle.whiteW600_14,
                  onPressed: () {
                    context.read<OtpCubit>().sendOtp(isVerifyScreen: false);
                  },),
              ],
            ),
          ),
        ),
      ),
    );
  }
}