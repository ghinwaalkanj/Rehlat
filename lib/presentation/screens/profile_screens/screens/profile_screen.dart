import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/cubit/root/root_cubit.dart';
import 'package:trips/data/data_resource/local_resource/data_store.dart';
import '../../../../cubit/booking/booking_cubit.dart';
import '../../../../cubit/main/main_cubit.dart';
import '../../../../cubit/main/main_states.dart';
import '../../../../cubit/profile/profile_cubit.dart';
import '../../../../cubit/profile/profile_states.dart';
import '../../../common_widgets/base_app_bar.dart';
import '../../../style/app_colors.dart';
import '../../../style/app_font_size.dart';
import '../../../style/app_text_style.dart';
import '../../../style/app_text_style_2.dart';
import '../../onboarding_screens/splash_screen.dart';
import '../widgets/profile_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit,ProfileStates>(
      builder: (context, state) =>   BaseAppBar(
      titleScreen: 'profile'.translate(),
          notExistArrow:true,
      child:  Padding(
        padding: const EdgeInsets.only(top: 6,),
        child:Container(
          decoration: BoxDecoration(
            color: AppColors.lightXXXGrey,
            borderRadius: BorderRadius.vertical(top: Radius.circular(44)),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(DataStore.instance.name!='')
                 ProfileCard(
                   isLogout: true,
                    widgetCard: Row(
                  children: [
                    Icon(Icons.account_circle_outlined,color: AppColors.darkGreen),
                    SizedBox(width: 21,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(DataStore.instance.name??'',style:AppTextStyle2.getBoldStyle(
                          fontSize: AppFontSize.size_14,
                          color:  Colors.black,
                          fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                        SizedBox(height: 4,),
                      //   Text('UserName@Gmail.com',style:   AppTextStyle2.getBoldStyle(
                      // fontSize: AppFontSize.size_14,
                      // color:  Colors.black,
                      // fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),)
                      ],
                    ),
                  ],
                )
                ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 12),
                  shrinkWrap: true,
                    itemBuilder: (context, index) =>ProfileCard(profileCardModel:  context.read<ProfileCubit>().settingsList[index]) ,
                    separatorBuilder: (context, index) => const SizedBox(height:10,),
                    itemCount: context.read<ProfileCubit>().settingsList.length ),
                const SizedBox(height: 12,),

                InkWell(
                  onTap: (DataStore.instance.token!=null)?() {
                    DataStore.instance.setToken(null);
                    DataStore.instance.setName('');
                    DataStore.instance.setPhone('');
                    DataStore.instance.deleteCertificates();
                    AppRouter.navigateRemoveTo(context: context, destination: SplashScreen());
                    context.read<RootPageCubit>().changePageIndex(0);
                    context.read<BookingCubit>().clearList();
                  }:(){},
                  child: ProfileCard(
                      isLogout: true,
                      widgetCard:
                      (DataStore.instance.token!=null)?
                  Row(
                    children: [
                      const Icon(Icons.logout_rounded,color: Colors.black),
                      const SizedBox(width: 14,),
                      Text('logout'.translate(),style:   AppTextStyle2.getBoldStyle(
                      fontSize: AppFontSize.size_14,
                      color:  Colors.black,
                      fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                    ],
                  ):Text(''),
                  ),
                ),
                SizedBox(height: 10,),
              ],
            ),
        ),
        ),
      )),
    );
  }
}
