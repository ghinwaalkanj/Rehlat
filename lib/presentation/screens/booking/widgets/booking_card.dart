import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/core/utils/image_helper.dart';
import 'package:trips/presentation/screens/payment_mothod/screens/payment_methods_screens.dart';
import 'package:trips/presentation/style/app_images.dart';

import '../../../../cubit/booking/booking_cubit.dart';
import '../../../../data/data_resource/local_resource/data_store.dart';
import '../../../../data/model/booking_trip_model.dart';
import '../../../style/app_colors.dart';
import '../../../style/app_font_size.dart';
import '../../../style/app_text_style_2.dart';
import 'booking_card_paint.dart';

class BookingCard extends StatelessWidget {
  final BookingTripModel bookingTripModel;
  final Color color;
  final bool isTemp;
  final bool isHistory;

  const BookingCard({Key? key,this.isHistory=false, required this.color,this.isTemp=false,required this.bookingTripModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      enabled: !isHistory,
     key:  ValueKey(bookingTripModel.id),
     endActionPane:  ActionPane(
       extentRatio:(!isTemp)? 0.3:0.5,
       motion: const ScrollMotion(),
       children: [
         const SizedBox(width:15 ,),
         if(isTemp)InkWell(
           onTap: () {
             AppRouter.navigateTo(context: context, destination:  PaymentMethodScreen(reservationId:bookingTripModel.id??0 ,));
            // context.read<BookingCubit>().verifyCodeBooking(bookingTripModel: bookingTripModel,isBookingScreen: true);
           },
           child: Container(
             decoration: const BoxDecoration(
               borderRadius: BorderRadius.all(Radius.circular(8)),
               color: AppColors.lightXGreen,),
             child: Padding(
               padding: const EdgeInsets.all(19.0),
               child: Image.asset(AppImages.checkIcon,height: 32,width: 32,fit: BoxFit.fill),
             ),
           ),
         ),
         if(isTemp)const SizedBox(width:15 ,),
         if(!isHistory)
         InkWell(
           onTap: () {
             context.read<BookingCubit>().requestCancelTempBooking(bookingTripModel: bookingTripModel,isBookingScreen: true);
           },
           child: Container(
             decoration: const BoxDecoration(
             borderRadius: BorderRadius.all(Radius.circular(8)),
             color: AppColors.darkYellow,),
             child: Padding(
               padding: const EdgeInsets.all(19.0),
               child: Image.asset(AppImages.deleteIcon),
             ),
           ),
         ),
       ],
     ),
     child: Builder(
       builder: (context) {
      return  Stack(
         alignment: Alignment.topLeft,
         children: [
           CustomPaint(
             size: Size(1.sw, (170).toDouble()), //You can Replace [1.sw] with your desired width for Custom Paint and height will be calculated automatically
             painter: RPSCustomPainter(color: color),
           ),
           Padding(
             padding: const EdgeInsets.symmetric(vertical: 22),
             child: Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 SizedBox(
                   width: 120.w,
                   child: Column(
                     children: [
                       SizedBox(height: 12.h,),

                        Text(bookingTripModel.reservationNumber??'',style: AppTextStyle2.getBoldStyle(
                        fontSize: AppFontSize.size_17,
                        color:  Colors.black,
                        fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                       SizedBox(height: 8.h,),
                        Text(DateFormat('E, LLL d ',DataStore.instance.lang).format(bookingTripModel.startDate??DateTime.now()).toString(),
                         textAlign: TextAlign.center,
                         style:   AppTextStyle2.getMediumStyle(
                              fontSize: AppFontSize.size_14,
                              color:  Colors.black,
                              fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',).copyWith(
                           fontFamily: 'Tajawal-Bold',
                           fontWeight: FontWeight.w900
                           //DataStore.instance.lang=='ar'?'Tajawal-Bold':,
                         ),),
                       SizedBox(height: 8.h,),
                       Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 2.0),
                         child: Wrap(
                           children: [
                             Text((bookingTripModel.company?.name??''),style: AppTextStyle2.getBoldStyle(
                               fontSize: AppFontSize.size_10,
                               color: AppColors.darkGreen,
                               fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                               maxLines: 3,
                             ),
                             Text('company'.translate(),style: AppTextStyle2.getBoldStyle(
                               fontSize: AppFontSize.size_10,
                               color: AppColors.darkGreen,
                               fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                               maxLines: 3,
                             ),
                           ],
                         ),
                       ),
                     ],
                   ),
                 ),
                 Padding(
                   padding:  EdgeInsets.symmetric(vertical: 11.h),
                   child: Image.asset(AppImages.separatorImage),
                 ),
                 SizedBox(width: 24.w,),
                 Expanded(
                   child: Padding(
                     padding: const EdgeInsets.only(right:4.0),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         const SizedBox(height: 10,),
                         Row(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                              Expanded(
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 children: [
                                   Text('${bookingTripModel.startDate?.hour??''} : ${bookingTripModel.startDate?.minute??''}',
                                     style:   AppTextStyle2.getMediumStyle(
                                       fontSize: AppFontSize.size_12,
                                       color:  Colors.black,
                                       fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                                   Text(bookingTripModel.sourceCity?.name??'',
                                     style:   AppTextStyle2.getRegularStyle(
                                       fontSize: AppFontSize.size_12,
                                       color:  Colors.black,
                                       fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
                                 ],
                               ),
                             ),
                             Expanded(
                               child: Padding(
                                 padding:  EdgeInsets.symmetric(horizontal: 6.h),
                                 child: const ImageWidget(url: AppImages.betweenImage,color: Colors.black,).buildAssetSvgImage(),
                               ),
                             ),
                              Expanded(
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 children: [
                                   // Text('${bookingTripModel.startDate?.hour??''} : ${bookingTripModel.startDate?.minute??''}',
                                   //   style: AppTextStyle.blackW500_12,),
                                   Text(bookingTripModel.destinationCity?.name??'',
                                     style:AppTextStyle2.getRegularStyle(
                                       fontSize: AppFontSize.size_12,
                                       color:  Colors.black,
                                       fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)
                                   ),
                                 ],
                               ),
                             ),
                           ],
                         ),

                         Padding(
                           padding:  EdgeInsets.only(top: 18.h,bottom: 11.h),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               const ImageWidget(url: AppImages.greenSeatImage).buildAssetSvgImage(),
                               const SizedBox(width: 12,),
                              Text('${bookingTripModel.mySeats?.length.toString()??''} ${'seats_2'.translate()} : '  ,style: AppTextStyle2.getSemiBoldStyle(
                              fontSize: AppFontSize.size_12,
                              color:  Colors.black,
                              fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                               Expanded(
                                 child: Wrap(
                                   children: List.generate(bookingTripModel.mySeats?.length??0, (index) =>
                                       Text('${bookingTripModel.mySeats?[index].number.toString()??''}, '  ,style: AppTextStyle2.getSemiBoldStyle(
                                        fontSize: AppFontSize.size_12,
                                        color:  Colors.black,
                                        fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                                   overflow: TextOverflow.ellipsis,
                                     maxLines: 3,
                                     softWrap: true,
                                   )),
                                 ),
                               ),
                             ],
                           ),
                         ),
                         Row(
                           children: [
                             Text('pay'.translate(),  style: AppTextStyle2.getSemiBoldStyle(
                              fontSize: AppFontSize.size_14,
                              color: Colors.black,
                              fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                             const SizedBox(width: 16),
                             Text(((bookingTripModel.mySeats?.length??0)*(bookingTripModel.ticketPrice??0)).toString(),style: TextStyle(
                               fontSize: AppFontSize.size_14,
                               color: color,
                               fontFamily: 'Cairo_Regular',
                               fontWeight: FontWeight.w600,
                             ),),
                             const Spacer(),
                             if(!isHistory)
                             InkWell(
                               onTap: () {
                                 bookingTripModel.isSlidable=Slidable.of(context)!.actionPaneType.value == ActionPaneType.none;
                                 (bookingTripModel.isSlidable??false)
                                     ? {
                                   Slidable.of(context)?.openEndActionPane(),
                                  context.read<BookingCubit>().closeSlidableCard()}
                                     : {Slidable.of(context)?.close(),
                                      context.read<BookingCubit>().closeSlidableCard()};
                               },
                                 child: Container(
                                 decoration: BoxDecoration(
                                 border: Border.all(color: AppColors.lightXXGrey),
                                 borderRadius: const BorderRadius.all(Radius.circular(13))
                                 ),
                                 child:  const Padding(
                                 padding: EdgeInsets.all(8.0),
                                 child: Icon(
                                          Icons.arrow_forward_ios_rounded
                                       ,color: Colors.black,size: 18,),
                                   )),
                             ),
                             const SizedBox(width: 22,)
                           ],
                         ),
                       ],
                     ),
                   ),
                 ),
               ],
             ),
           ),
         ],
       );
    }));
  }
}