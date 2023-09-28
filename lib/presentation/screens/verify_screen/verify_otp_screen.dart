import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/core/utils/global.dart';
import 'package:trips/core/utils/image_helper.dart';
import 'package:trips/cubit/home/home_cubit.dart';
import 'package:trips/presentation/common_widgets/dialog/error_dialog.dart';
import 'package:trips/presentation/common_widgets/dialog/loading_dialog.dart';
import 'package:trips/presentation/screens/booking_trip/screens/hop_hop_seats_info_screen.dart';
import 'package:trips/presentation/screens/verify_screen/send_otp_screen.dart';
import 'package:trips/presentation/screens/verify_screen/success_verify_dialog.dart';

import '../../../cubit/otp_cubit/otp_cubit.dart';
import '../../../cubit/otp_cubit/otp_states.dart';
import '../../../cubit/result_search_card/result_search_cubit.dart';
import '../../../cubit/reverse_trip/reserve_trip_cubit.dart';
import '../../../cubit/seats/seats_cubit.dart';
import '../../../data/data_resource/local_resource/data_store.dart';
import '../../../domain/models/profile_param.dart';
import '../../../domain/models/seat_model.dart';
import '../../common_widgets/custom_button.dart';
import '../../style/app_colors.dart';
import '../../style/app_font_size.dart';
import '../../style/app_images.dart';
import '../../style/app_text_style.dart';
import '../../style/app_text_style_2.dart';
import '../booking_trip/screens/normal2_seats_info_screen.dart';
import '../booking_trip/screens/vip_seats_info_screen.dart';


class VerifyOTPScreen extends StatelessWidget {

   VerifyOTPScreen({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpCubit,OtpStates>(
      bloc:  context.read<OtpCubit>()..code=null,
      listener: (context, state) {
        if(state is ValidateVerifyOtpState){ErrorDialog.openDialog(context, state.error);}
        if(state is LoadingVerifyOtpState)LoadingDialog().openDialog(context);
        if(state is ErrorVerifyOtpState){
           LoadingDialog().closeDialog(context);}
        if(state is SuccessVerifyOtpState){
           context.read<SeatsCubit>().seconds=context.read<HomeCubit>().timer;
           if(DataStore.instance.token!=null)context.read<ResultSearchCubit>().getTripDetails();
           context.read<ResultSearchCubit>().selectedTripModel=context.read<OtpCubit>().tripModel;
           successVerifyDialog(context: context,isVerifyOtp:true,onConfirm: (){
             SchedulerBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentContext!.read<SeatsCubit>().seatsIds=[];
            if(context.read<ResultSearchCubit>().selectedTripModel?.busType=='vip') {
              AppRouter.navigateRemoveTo(context: context, destination: VipSeatsInfoScreen());
            }
            if(context.read<ResultSearchCubit>().selectedTripModel?.busType=='normal') {
              AppRouter.navigateRemoveTo(context: context, destination: NormalSeatsInfoScreen());
            }
            if(context.read<ResultSearchCubit>().selectedTripModel?.busType=='small') {
              AppRouter.navigateRemoveTo(context: context, destination: SmallSeatsInfoScreen());
            }
          });
          });
         }
      },
      builder: (context, state) =>   Scaffold(
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
                   fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('enter_code'.translate(),style: AppTextStyle.lightBlackW400_13.copyWith(
                          fontFamily: DataStore.instance.lang=='ar'?'Tajawal-Regular':'Poppins-Regular'
                      ),),
                      Text('${context.read<OtpCubit>().phoneNumber ?? ''}',style: AppTextStyle.lightBlackW400_13Underline,),
                    ],
                  ),
                const SizedBox(height: 24,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PinFieldAutoFill(
                      decoration:CirclePinDecoration(
                          bgColorBuilder: FixedColorBuilder(AppColors.lightXBlue.withOpacity(0.15)),
                          strokeColorBuilder:  FixedColorBuilder((state is ErrorVerifyOtpState)?AppColors.red2:AppColors.darkGreen)),
                      currentCode: context.read<OtpCubit>().code,
                      codeLength: 6,
                      onCodeSubmitted: (p0) {
                        context.read<OtpCubit>().code = p0;
                        context.read<OtpCubit>().verifyOtp(context);
                        },
                      onCodeChanged: (String? code) {
                         context.read<OtpCubit>().code = code!;
                      if(code.characters.length==6)context.read<OtpCubit>().verifyOtp(context);
                      }),
                ),
                 const SizedBox(height: 32,),
                if(state is ErrorVerifyOtpState) Text('code_error'.translate(),style: AppTextStyle.redBold_14,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(state is ErrorVerifyOtpState) Text('code_error2'.translate(),style: AppTextStyle.redBold_14,),
                    if(state is ErrorVerifyOtpState) InkWell(
                        onTap: () =>AppRouter.navigateRemoveTo(context: context, destination: SendPhoneScreen()),
                        child: Text('change_phone'.translate(),style: AppTextStyle.redBold_14.copyWith(decoration: TextDecoration.underline,color: Colors.black),)),
                  ],
                ),
                if(state is ErrorVerifyOtpState) Padding(
                  padding: const EdgeInsets.symmetric(vertical: 36.0),
                  child: ImageWidget(url: AppImages.errorCodeIcon).buildAssetSvgImage(),
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
                  onPressed: () {
                    context.read<OtpCubit>().verifyOtp(context);
                  },),
                const SizedBox(height: 14,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    Text('receive_code'.translate(),style: AppTextStyle.lightGreyW400_16,),
                    InkWell(
                        onTap: () =>context.read<OtpCubit>().sendOtp(isVerifyScreen: true) ,
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