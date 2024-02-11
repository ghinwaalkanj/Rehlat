import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/core/utils/global.dart';
import 'package:trips/cubit/support/support_cubit.dart';
import 'package:trips/data/data_resource/local_resource/data_store.dart';
import 'package:trips/presentation/screens/root_screens/root_screen.dart';
import 'package:trips/presentation/screens/verify_screen/send_otp_screen.dart';

import '../../../../cubit/booking/booking_cubit.dart';
import '../../../../cubit/profile/profile_cubit.dart';
import '../../../../cubit/profile/profile_states.dart';
import '../../../common_widgets/base_app_bar.dart';
import '../../../common_widgets/dialog/action_alert_dialog.dart';
import '../../../style/app_colors.dart';
import '../../../style/app_font_size.dart';
import '../../../style/app_text_style_2.dart';
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
          decoration: const BoxDecoration(
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
                    const Icon(Icons.account_circle_outlined,color: AppColors.darkGreen),
                    const SizedBox(width: 21,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(DataStore.instance.name??'',style:AppTextStyle2.getBoldStyle(
                          fontSize: AppFontSize.size_14,
                          color:  Colors.black,
                          fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                        const SizedBox(height: 4,),
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
            (DataStore.instance.token !=null)?
                InkWell(
                  onTap: () {
                    ActionAlertDialog.show(context,
                      dialogTitle: "exit_app".translate(),
                      onConfirm:()  {
                        //DataStore.instance.setToken(null);
                        DataStore.instance.setName('');
                        DataStore.instance.setPhone('');
                        DataStore.instance.deleteCertificates();
                        context.read<BookingCubit>().clearList();
                        context.read<SupportCubit>().clearList();
                        context.read<SupportCubit>().initSupportScreen();
                        AppRouter.navigateRemoveTo(context: context, destination: const RootScreen());
                        SystemNavigator.pop();
                      },
                      onCancel:() {
                      Navigator.of(context).pop();},
                      confirmText: "confirm".translate(),
                      cancelText:"cancel".translate(),
                      confirmFillColor: AppColors.darkGreen,
                    );
                    },
                  child: ProfileCard(
                      isLogout: true,
                      widgetCard:
                              Row(
                                  children: [
                                    const Icon(Icons.logout_rounded,color: Colors.black),
                                    const SizedBox(width: 14,),
                                    Text('logout'.translate(),style:   AppTextStyle2.getBoldStyle(
                                    fontSize: AppFontSize.size_14,
                                    color:  Colors.black,
                                    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                                  ],
                          ))):
                      InkWell(
                        onTap:(){
                          AppRouter.navigateTo(context: context, destination: const SendPhoneScreen(isFromSettings: true,));
                          },
                        child: ProfileCard(
                            isLogout: true,
                            widgetCard: Row(
                                children: [
                                  const Icon(Icons.login_rounded,color: Colors.black),
                                  const SizedBox(width: 14,),
                                  Text('log_in1'.translate(),
                                style:AppTextStyle2.getBoldStyle(
                                fontSize: AppFontSize.size_14,
                                color:  Colors.black,
                                fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                              ],
                            ),
                        ),
                      ),
                const SizedBox(height: 10,),
                Container(
                  clipBehavior: Clip.antiAlias,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                   child: Padding(
                          padding: const EdgeInsets.symmetric(vertical:20.0),
                          child: Text('${'version'.translate()} ${packageInfo?.version ?? ''}',
                            textAlign: TextAlign.center,
                            style:AppTextStyle2.getBoldStyle(
                              fontSize: AppFontSize.size_14,
                              color:  Colors.black,
                              fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                ),
                 ),
              ],
            ),
           ),
        ),
      )),
    );
  }
}