import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/presentation/common_widgets/dialog/loading_dialog.dart';

import '../../../../core/utils/image_helper.dart';
import '../../../../cubit/profile/profile_cubit.dart';
import '../../../../cubit/profile/profile_states.dart';
import '../../../../cubit/root/root_cubit.dart';
import '../../../../data/data_resource/local_resource/data_store.dart';
import '../../../../data/model/company_model.dart';
import '../../../common_widgets/auth_text_form_field.dart';
import '../../../common_widgets/base_app_bar.dart';
import '../../../common_widgets/custom_button.dart';
import '../../../common_widgets/dialog/error_dialog.dart';
import '../../../common_widgets/gender_drop_down.dart';
import '../../../common_widgets/profile_otp_screen.dart';
import '../../../style/app_colors.dart';
import '../../../style/app_font_size.dart';
import '../../../style/app_images.dart';
import '../../../style/app_text_style.dart';
import '../../../style/app_text_style_2.dart';
import '../../root_screens/root_screen.dart';
import '../widgets/dialog_succes_edit_profile.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit,ProfileStates>(
      bloc: context.read<ProfileCubit>()..defineUser(),
      listener: (context, state) async {
        if(state is ValidatePhoneState)ErrorDialog.openDialog(context,'phone_valid'.translate(),);
        if(state is LoadingRequestUpdateProfileState)LoadingDialog().openDialog(context);
        if(state is LoadingUpdateProfileState)LoadingDialog().openDialog(context);
        if(state is SuccessUpdateProfileState&&context.read<ProfileCubit>().isPhoneChanged==false){
          context.read<RootPageCubit>().changePageIndex(0);
          AppRouter.navigateRemoveTo(context: context, destination: const RootScreen());
          ErrorDialog.openDialog(context,'update_profile_success'.translate(),verifySuccess: true);
        }
        if(state is ErrorUpdateProfileState&&context.read<ProfileCubit>().isPhoneChanged==false){
          LoadingDialog().closeDialog(context);
          ErrorDialog.openDialog(context, state.error);
          await SmsAutoFill().listenForCode();
        }
        if(state is SuccessRequestUpdateProfileState){
          LoadingDialog().closeDialog(context);
          EditProfileSuccess.openDialog(context, 'profile_send_otp'.translate(),verifySuccess: true,
          (state.isVerifyScreen==false)?(){
            Navigator.pop(context);
            AppRouter.navigateTo(context: context, destination:const ProfileOTPCodeScreen());}:(){
            Navigator.pop(context);
          },);
        }
    },
      builder: (context, state) =>  Scaffold(
        resizeToAvoidBottomInset: true,
        body: BaseAppBar(
          titleScreen: 'profile'.translate(),
          child: SizedBox(
            height: 0.87.sh,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    const SizedBox(height: 42,),
                    const ImageWidget(url: AppImages.profileImage,height: 140,width: 140,fit: BoxFit.fill,).buildAssetSvgImage(),
                    const SizedBox(height: 36,),
                    AuthTextFormField(
                      onChanged: (value) =>  context.read<ProfileCubit>().profileParamModel.name= context.read<ProfileCubit>().nameController.text,
                        errorText: (context.read<ProfileCubit>().nameController.text.isNotEmpty&&context.read<ProfileCubit>().errorText!=null)?context.read<ProfileCubit>().errorText:null,
                        controller: context.read<ProfileCubit>().nameController,
                        labelText: 'name'.translate(),labelStyle: AppTextStyle.darkGreyNormal_16,borderColor:AppColors.darkGrey ,enableColor: AppColors.darkGreen),
                    const SizedBox(height: 16,),
                    AuthTextFormField(
                        errorText:  (context.read<ProfileCubit>().ageController.text.isNotEmpty&&context.read<ProfileCubit>().errorText!=null)?context.read<ProfileCubit>().errorText:null,
                        controller: context.read<ProfileCubit>().ageController,
                        labelText: 'age'.translate(),labelStyle: AppTextStyle.darkGreyNormal_16,keyboardType: TextInputType.phone,borderColor:AppColors.darkGrey ,enableColor: AppColors.darkGreen),
                    const SizedBox(height: 16,),
                    AuthTextFormField(
                        onChanged: (value) =>  context.read<ProfileCubit>().profileParamModel.phone= context.read<ProfileCubit>().phoneController.text,
                        controller: context.read<ProfileCubit>().phoneController,
                        labelText: 'number'.translate(),labelStyle: AppTextStyle.darkGreyNormal_16,keyboardType: TextInputType.phone,borderColor:AppColors.darkGrey ,enableColor: AppColors.darkGreen),
                    const SizedBox(height: 16,),
                    DropDownAppWidget(
                      dropDownList: [CompanyModel(name: 'male',id: 0),CompanyModel(name:'female',id: 1)],
                      chooseTitle: context.read<ProfileCubit>().gender??'choose_gender'.translate(),
                      getSelectionId: (id) {
                        context.read<ProfileCubit>().profileParamModel.gender=id=='0'?'male':'female';
                        context.read<ProfileCubit>().gender=id=='0'?'male':'female';
                      },),
                    const SizedBox(height: 36,),
                    (state is LoadingUpdateProfileState)
                         ? const SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: AppColors.darkXGreen,),
                        ],
                      ),
                    )
                         : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: CustomButton(
                              h: 55,
                              radius: 32,
                              color: AppColors.darkGreen,
                              text: 'edit'.translate(),
                              textStyle: AppTextStyle2.getSemiBoldStyle(
                              fontSize: AppFontSize.size_14,
                              color: Colors.white,
                              fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                              onPressed: () {
                                context.read<ProfileCubit>().isPhoneChanged=false;
                                context.read<ProfileCubit>().requestUpdateProfile(isVerifyScreen: false);
                              },),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
