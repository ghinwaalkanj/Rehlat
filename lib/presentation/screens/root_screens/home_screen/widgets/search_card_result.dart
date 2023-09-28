import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/core/utils/image_helper.dart';
import 'package:trips/cubit/home/home_cubit.dart';
import 'package:trips/data/model/trip_model.dart';
import 'package:trips/presentation/screens/root_screens/home_screen/widgets/waiting_feature_card_dialog.dart';
import 'package:trips/presentation/style/app_images.dart';
import 'package:trips/presentation/style/app_text_style.dart';
import '../../../../../cubit/main/main_cubit.dart';
import '../../../../../cubit/passenger_cubit/passenger_cubit.dart';
import '../../../../../cubit/result_search_card/result_search_cubit.dart';
import '../../../../../cubit/seats/seats_cubit.dart';
import '../../../../../data/data_resource/local_resource/data_store.dart';
import '../../../../style/app_colors.dart';
import '../../../../style/app_font_size.dart';
import '../../../../style/app_text_style_2.dart';
import '../../../verify_screen/send_otp_screen.dart';

class SearchResultCard extends StatelessWidget {
  final int index;
  final TripModel tripModel;
  const SearchResultCard({Key? key, required this.index,required this.tripModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        context.read<ResultSearchCubit>().selectedTripModel=tripModel;
        if(DataStore.instance.token!=null) context.read<ResultSearchCubit>().getTripDetails();
        if(DataStore.instance.token==null) AppRouter.navigateTo(context: context, destination: const SendPhoneScreen());
        context.read<ResultSearchCubit>().selectedTripModel=tripModel;
        context.read<SeatsCubit>().seconds=Duration(minutes: tripModel.timer!);
        context.read<ResultSearchCubit>().navigateToSeats();
        context.read<PassengerCubit>().createPassengerList(context.read<HomeCubit>().passengers);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(border: (index==0)?const Border.symmetric(vertical:BorderSide.none,):Border.all(color: AppColors.lightX3Grey)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0,vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 4,),
                      InkWell(
                          onTap: () =>   waitingCardDialog(context: context),
                          child: Text('waiting_feature'.translate(),style: AppTextStyle.lightXGreenW400_12,)),
                    ],
                  ),
                  if(tripModel.rate != null)
                    RatingBar.builder(
                      ignoreGestures: true,
                      itemSize: 15,
                      initialRating: tripModel.rate,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                ],
              ),
              const SizedBox(height: 9,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if(DataStore.instance.lang=='ar')Text('${'company'.translate()} ',style: AppTextStyle2.getSemiBoldStyle(
                    fontSize: AppFontSize.size_16,
                    color: Colors.black,
                    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),softWrap: true),
                  Text(tripModel.company?.name??'',style: AppTextStyle2.getSemiBoldStyle(
                  fontSize: AppFontSize.size_16,
                  color: Colors.black,
                  fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),softWrap: true),
                  if(DataStore.instance.lang=='en')Text('${'company'.translate()} ',style: AppTextStyle2.getSemiBoldStyle(
                      fontSize: AppFontSize.size_16,
                      color: Colors.black,
                      fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),softWrap: true),
                  const SizedBox(width: 8,),
                  if(tripModel.busType=='vip') const ImageWidget(url: AppImages.vipIcon).buildAssetSvgImage(),
                 const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.access_time_rounded,color: AppColors.darkXGreen),
                      const SizedBox(width: 3,),
                      Text(DateFormat('jm',DataStore.instance.lang).format(tripModel.startDate??DateTime.now()).toString(),
                        style:   AppTextStyle2.getMediumStyle(
                          fontSize: AppFontSize.size_16,
                          color:  Colors.black,
                          fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                    ],
                  ),
                ],
              ),
              const SizedBox(height:8,),

              const SizedBox(height: 16,),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                     alignment: WrapAlignment.spaceBetween,
                      children: [
                         Text('${tripModel.ticketPrice} ${context.read<MainCubit>().currency}',style:   AppTextStyle2.getRegularStyle(
                          fontSize: AppFontSize.size_18,
                          color:  Colors.black,
                          fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),softWrap: true,maxLines: 2,),
                        Text('price_per_ticket'.translate(),style:   AppTextStyle2.getRegularStyle(
                        fontSize: AppFontSize.size_18,
                        color:  Colors.black,
                        fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',).copyWith(fontSize: 14)),
                        SizedBox(width: 22.w,),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ImageWidget(url:AppImages.yellowSeat2Icon).buildAssetSvgImage(),
                            SizedBox(width: 6.w,),
                            Text('${tripModel.seatsLeaft} ${'seats_left'.translate()}',style: AppTextStyle.whiteW400_14.copyWith(color: AppColors.darkYellow)),
                          ],
                        )
                  ],
                ),
              ),
            if(context.read<HomeCubit>().tripsList.length==1)const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
