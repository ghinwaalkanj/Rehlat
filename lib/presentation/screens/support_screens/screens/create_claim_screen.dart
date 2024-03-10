import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/presentation/common_widgets/gender_drop_down.dart';
import 'package:trips/presentation/screens/support_screens/widgets/logo.dart';

import '../../../../cubit/support/support_cubit.dart';
import '../../../../cubit/support/support_states.dart';
import '../../../../data/data_resource/local_resource/data_store.dart';
import '../../../common_widgets/auth_text_form_field.dart';
import '../../../common_widgets/custom_button.dart';
import '../../../common_widgets/dialog/error_dialog.dart';
import '../../../common_widgets/dialog/loading_dialog.dart';
import '../../../style/app_colors.dart';
import '../../../style/app_font_size.dart';
import '../../../style/app_text_style.dart';
import '../../../style/app_text_style_2.dart';

class CreateClaimScreen extends StatelessWidget {
  const CreateClaimScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SupportCubit,SupportStates>(
      bloc: context.read<SupportCubit>()..initSupportScreen(),
      listener: (context, state) {
        if(state is SendClaimErrorState){
          LoadingDialog().closeDialog(context);
          ErrorDialog.openDialog(context,'try_again'.translate());
        }
        if(state is SendClaimSuccessState) {
          LoadingDialog().closeDialog(context);
          Navigator.pop(context);
          ErrorDialog.openDialog(
              context, 'send_claim_successfully'.translate(),
              verifySuccess: true);
        }
          if(state is SendClaimLoadingState)LoadingDialog().openDialog(context);
      },
      builder: (context, state) =>
           Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const LogoWidget(padding: 40),
                        Text('support_title'.translate(), textAlign: TextAlign.center,
                            style: AppTextStyle2.getBoldStyle(
                          fontSize: AppFontSize.size_16,
                          color:  Colors.black,
                          fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
                        const SizedBox(height: 15,),
                         context.read<SupportCubit>().bookingIDList.isEmpty
                            ?  Padding(
                                  padding: const EdgeInsets.only(top: 50.0),
                                  child: Text('must_reserve_claim'.translate(), style: AppTextStyle2.getBoldStyle(
                                    fontSize: AppFontSize.size_16,
                                    color:  Colors.black,
                                    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
                                )
                                  :  Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // todo
                              // CustomButton(
                              //   h: 50,
                              //   rowChild: const Icon(Icons.calendar_today_outlined,
                              //       color: AppColors.darkGreen),
                              //   borderSideColor: AppColors.xBlack,
                              //   color: Colors.transparent,
                              //   text:context.read<SupportCubit>().supportModel.date??'reservation_date'.translate(),
                              //   textStyle:  AppTextStyle.darkGreyNormal_16,
                              //   onPressed: () {
                              //     DateTimeWidget.selectDate(context, (dateTime) {
                              //       context.read<SupportCubit>().updateDate(dateTime);
                              //     },lastDate: DateTime.now());
                              //   },),
                              // if(context.read<SupportCubit>().supportModel.date==null&&context.read<SupportCubit>().error!=null)
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 33.0,right:33,top: 12),
                              //   child: Text(context.read<SupportCubit>().error!,style: AppTextStyle.redBold_14,),
                              // ),
                              const SizedBox(height: 15,),
                              DropDownAppWidget(
                                isBooking: true,
                                dropDownList:context.read<SupportCubit>().bookingIDList,
                                chooseTitle: 'reservation_number'.translate(),
                                textStyle: context.read<SupportCubit>().supportModel.bookingTripModel!=null? AppTextStyle2.getMediumStyle(
                                  fontSize: AppFontSize.size_16,
                                  color:  Colors.black,
                                  fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',):null,
                                getSelectionId:(id) {
                                  context.read<SupportCubit>().bookingIDList.forEach((element) {
                                    if(element.id.toString()==id) context.read<SupportCubit>().supportModel.bookingTripModel=element;
                                    context.read<SupportCubit>().selectedReservation=id;
                                  });
                                },
                                selectionItem:context.read<SupportCubit>().selectedReservation,
                              ),
                              if(context.read<SupportCubit>().supportModel.bookingTripModel==null&&context.read<SupportCubit>().error!=null)
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(top: 15,start: 30),
                                  child: Text(context.read<SupportCubit>().error!,style:AppTextStyle.redBold_14,),
                                ),
                              const SizedBox(height: 15,),
                              AuthTextFormField(
                                  errorText: context.read<SupportCubit>().errorPhone,
                                  controller:  context.read<SupportCubit>().phoneNumber,
                                  textStyle:   AppTextStyle2.getMediumStyle(
                                    fontSize: AppFontSize.size_16,
                                    color:  Colors.black,
                                    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                                  labelText: 'number'.translate(),
                                  labelStyle: AppTextStyle.darkGreyNormal_16,
                                  borderColor:AppColors.xBlack,
                                  keyboardType: TextInputType.number,
                                  enableColor: AppColors.darkGreen),
                              const SizedBox(height: 15,),
                              AuthTextFormField(
                                  errorText: context.read<SupportCubit>().claimText.text.isEmpty? context.read<SupportCubit>().error:null,
                                  controller:  context.read<SupportCubit>().claimText,
                                  minLines: 4,
                                  textStyle:   AppTextStyle2.getMediumStyle(
                                    fontSize: AppFontSize.size_16,
                                    color:  Colors.black,
                                    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                                  labelText: 'claim_content'.translate(),
                                  labelStyle: AppTextStyle.darkGreyNormal_16,
                                  borderColor:AppColors.xBlack,
                                  enableColor: AppColors.darkGreen,
                                maxLength: 150,
                              ),
                              const SizedBox(height:30,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 33.0),
                                child: CustomButton(
                                  h: 50,
                                  radius: 32,
                                  color: AppColors.darkGreen,
                                  text: 'send'.translate(),
                                  textStyle: AppTextStyle2.getSemiBoldStyle(
                                    fontSize: AppFontSize.size_14,
                                    color: Colors.white,
                                    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                                  onPressed: () {
                                    context.read<SupportCubit>().sendClaim();
                                  },),
                              ),
                              const SizedBox(height:30,),
                            ]
                        )
                        // CustomButton(
                        //   h: 50,
                        //   rowChild: const Icon(Icons.calendar_today_outlined,
                        //       color: AppColors.darkGreen),
                        //   borderSideColor: AppColors.xBlack,
                        //   color: Colors.transparent,
                        //   text:context.read<SupportCubit>().supportModel.date??'reservation_date'.translate(),
                        //   textStyle:  AppTextStyle.darkGreyNormal_16,
                        //   onPressed: () {
                        //     DateTimeWidget.selectDate(context, (dateTime) {
                        //       context.read<SupportCubit>().updateDate(dateTime);
                        //     },lastDate: DateTime.now());
                        //   },),
                        // if(context.read<SupportCubit>().supportModel.date==null&&context.read<SupportCubit>().error!=null)
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 33.0,right:33,top: 12),
                        //   child: Text(context.read<SupportCubit>().error!,style: AppTextStyle.redBold_14,),
                        // ),

              ])),
            ),
          )),
    );
  }
}