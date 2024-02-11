import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/core/utils/global.dart';
import 'package:trips/core/utils/image_helper.dart';
import 'package:trips/cubit/home/home_cubit.dart';
import 'package:trips/cubit/root/root_cubit.dart';
import 'package:trips/presentation/common_widgets/dialog/error_dialog.dart';
import 'package:trips/presentation/common_widgets/dialog/loading_dialog.dart';
import 'package:trips/presentation/screens/booking_trip/screens/mini_seats_info_screen.dart';
import 'package:trips/presentation/screens/booking_trip/screens/normal_44.dart';
import 'package:trips/presentation/screens/booking_trip/screens/vip_29.dart';
import 'package:trips/presentation/screens/verify_screen/send_otp_screen.dart';
import 'package:trips/presentation/screens/verify_screen/success_verify_dialog.dart';

import '../../../core/notifications/push_notifications with local_flutter .dart';
import '../../../cubit/otp_cubit/otp_cubit.dart';
import '../../../cubit/otp_cubit/otp_states.dart';
import '../../../cubit/result_search_card/result_search_cubit.dart';
import '../../../cubit/seats/seats_cubit.dart';
import '../../../data/data_resource/local_resource/data_store.dart';
import '../../common_widgets/custom_button.dart';
import '../../common_widgets/verify_code_widget.dart';
import '../../style/app_colors.dart';
import '../../style/app_font_size.dart';
import '../../style/app_images.dart';
import '../../style/app_text_style.dart';
import '../../style/app_text_style_2.dart';
import '../booking_trip/screens/normal2_seats_info_screen.dart';
import '../booking_trip/screens/unknown_bus_info_screen.dart';
import '../booking_trip/screens/vip_seats_info_screen.dart';
import '../root_screens/root_screen.dart';


class VerifyOTPScreen extends StatefulWidget {
  final bool? isFromSettings;
   const VerifyOTPScreen({Key? key,this.isFromSettings=false}) : super(key: key);

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {

    String? appSignature;
    String? otpCode;

    // @override
    // void codeUpdated() {
    //   setState(() {
    //     otpCode ='000000';
    //   });
    // }
    //
    // getSignture() async {
    //   await SmsAutoFill().listenForCode();
    //    SmsAutoFill().code.listen((event) {
    //      print('event222');
    //      print(event);
    //    });
    //   await SmsAutoFill().getAppSignature.then((signature) {
    //     setState(() {
    //       appSignature = signature;
    //     });
    //   });
    // }
    // @override
    // void initState() {
    //   super.initState();
    //   getSignture();
    // }
    //
    // @override
    // void dispose() {
    //   super.dispose();
    // }
    @override
    Widget build(BuildContext context) {
    return BlocConsumer<OtpCubit,OtpStates>(
      bloc:  context.read<OtpCubit>()..clearCode(),
      listener: (context, state) async {
        if(state is ValidateVerifyOtpState){ErrorDialog.openDialog(context, state.error);}
        if(state is OtpInit2State){ await SmsAutoFill().listenForCode();}
        if(state is BlockState){ ErrorDialog.openDialog(context, state.error);}
        if(state is LoadingVerifyOtpState) LoadingDialog().openDialog(context);
        if(state is ErrorVerifyOtpState){
          LoadingDialog().closeDialog(context);
          await SmsAutoFill().listenForCode();
        }
        if(state is SuccessVerifyOtpState && widget.isFromSettings ==false){
           context.read<SeatsCubit>().seconds=context.read<HomeCubit>().timer;
           if(DataStore.instance.token!=null)context.read<ResultSearchCubit>().getTripDetails();
           context.read<ResultSearchCubit>().selectedTripModel=context.read<OtpCubit>().tripModel;
           successVerifyDialog(context: context,isVerifyOtp:true,onConfirm: (){
             SchedulerBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentContext!.read<SeatsCubit>().seatsIds=[];
            if(context.read<ResultSearchCubit>().selectedTripModel?.busModel?.numberSeat==33) {
              AppRouter.navigateRemoveTo(context: context, destination: const VipSeatsInfoScreen());
            }
            else if(context.read<ResultSearchCubit>().selectedTripModel?.busModel?.numberSeat==45) {
              AppRouter.navigateRemoveTo(context: context, destination: const NormalSeatsInfoScreen());
            }
            else if(context.read<ResultSearchCubit>().selectedTripModel?.busModel?.numberSeat==27) {
              AppRouter.navigateRemoveTo(context: context, destination: const SmallSeatsInfoScreen());
            }
            else if(context.read<ResultSearchCubit>().selectedTripModel?.busModel?.numberSeat==29) {
              AppRouter.navigateRemoveTo(context: context, destination: const VipSeats29InfoScreen());
            }
            else if(context.read<ResultSearchCubit>().selectedTripModel?.busModel?.numberSeat==44) {
              AppRouter.navigateRemoveTo(context: context, destination: const NormalSeatsInfo44Screen());
            }
            else{
              AppRouter.navigateRemoveTo(context: context, destination: const UnknownBusScreen());
            }
          });
          });
           context.read<RootPageCubit>().sendLang();
            if(DataStore.instance.token!=null)await PushNotificationService().setupInteractedMessage();
         }
        if(state is SuccessVerifyOtpState && widget.isFromSettings ==true){
        AppRouter.navigateRemoveTo(context: context, destination: RootScreen());
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
                 const VerifyCodeWidget(),
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
                      Text(context.read<OtpCubit>().phoneNumber ?? '',style: AppTextStyle.lightBlackW400_13Underline,),
                    ],
                  ),
                const SizedBox(height: 24,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 18),
                  child: PinFieldAutoFill(
                      enabled: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
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
                        onTap: () =>AppRouter.navigateRemoveTo(context: context, destination: const SendPhoneScreen()),
                        child: Text('change_phone'.translate(),style: AppTextStyle.redBold_14.copyWith(decoration: TextDecoration.underline,color: Colors.black),)),
                  ],
                ),
                if(state is ErrorVerifyOtpState) Padding(
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