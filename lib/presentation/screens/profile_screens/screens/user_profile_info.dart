import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_router.dart';
import '../../../../core/utils/image_helper.dart';
import '../../../../cubit/profile/profile_cubit.dart';
import '../../../../cubit/profile/profile_states.dart';
import '../../../../data/data_resource/local_resource/data_store.dart';
import '../../../common_widgets/base_app_bar.dart';
import '../../../common_widgets/custom_error_screen.dart';
import '../../../style/app_colors.dart';
import '../../../style/app_font_size.dart';
import '../../../style/app_images.dart';
import '../../../style/app_text_style_2.dart';
import 'edit_profile_screen.dart';

class UserProfileInfoScreen extends StatelessWidget {
  const UserProfileInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit,ProfileStates>(
      bloc:DataStore.instance.token== null?null:(context.read<ProfileCubit>()..getProfile()),
      builder:(context, state) => BaseAppBar(
        titleScreen: 'profile'.translate(),
          child: (state is ErrorGetProfileState )
              ? CustomErrorScreen(onTap:() => context.read<ProfileCubit>().getProfile(), )
              : DataStore.instance.token== null
        ?  SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImages.warningImage,height: 100,width: 120),
              const SizedBox(height: 40,),
              Text('first_login'.translate(), style: AppTextStyle2.getSemiBoldStyle(
            fontSize: AppFontSize.size_14,
            color: Colors.black,
            fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
            ],
          ),
        )
        :  (state is LoadingGetProfileState)
            ? const SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.darkXGreen,),
                ],
          ),
        )
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                children: [
                  const SizedBox(height:52,),
                  InkWell(
                    onTap: () => AppRouter.navigateTo(context: context, destination: const EditProfileScreen()),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        radius:32 ,
                        backgroundColor: AppColors.darkGreen,
                        child: Text('edit'.translate(),style:AppTextStyle2.getRegularStyle(
                          fontSize:  AppFontSize.size_18,
                          color: Colors.white,
                          fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
                      ),
                    ),
                  ),
                  const SizedBox(height:44,),
                  const ImageWidget(url: AppImages.profileImage,).buildAssetSvgImage(),
                  const SizedBox(height:13 ,),
                  Text(context.read<ProfileCubit>().user?.name??'edit_name_profile'.translate(),style:   AppTextStyle2.getBoldStyle(
                    fontSize: AppFontSize.size_14,
                    color:  Colors.black,
                    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
                  const SizedBox(height:13 ,),

                  const SizedBox(height:13 ,),
                  Text(context.read<ProfileCubit>().user?.phone.toString()??'',style:   AppTextStyle2.getRegularStyle(
                    fontSize: AppFontSize.size_18,
                    color:  Colors.black,
                    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                  const SizedBox(height:45,),
                ],
              ),
            ),
            if(context.read<ProfileCubit>().user?.gender!=null ||context.read<ProfileCubit>().user?.age!=''  )
              Container(
                color: AppColors.lightXXXXGrey,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      if(context.read<ProfileCubit>().user?.gender!=null)
                        Expanded(
                          child: Column(
                            children: [
                              Text('gender'.translate(),style:   AppTextStyle2.getBoldStyle(
                              fontSize: AppFontSize.size_18,
                              color:  Colors.black,
                            fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
                              const SizedBox(height: 10,),
                              Text(context.read<ProfileCubit>().user?.gender??'',style:   AppTextStyle2.getRegularStyle(
                              fontSize: AppFontSize.size_18,
                              color:  Colors.black,
                              fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),)
                            ],
                          ),
                        ),
                      if(context.read<ProfileCubit>().user?.age!=null)
                        Expanded(
                          child: Column(
                            children: [
                              Text('age'.translate(),style:   AppTextStyle2.getBoldStyle(
                                fontSize: AppFontSize.size_18,
                                color:  Colors.black,
                                fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
                              const SizedBox(height: 10,),
                              Text(context.read<ProfileCubit>().user?.age.toString()??'',style:   AppTextStyle2.getRegularStyle(
                                fontSize: AppFontSize.size_18,
                                color:  Colors.black,
                                fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),)
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              )
          ],
    )));
  }
}
