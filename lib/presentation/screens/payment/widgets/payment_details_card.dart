import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/presentation/style/app_text_style.dart';

import '../../../../cubit/main/main_cubit.dart';
import '../../../../cubit/passenger_cubit/passenger_cubit.dart';
import '../../../../cubit/result_search_card/result_search_cubit.dart';
import '../../../../cubit/reverse_trip/reserve_trip_cubit.dart';
import '../../../../cubit/reverse_trip/reserve_trip_states.dart';
import '../../../../cubit/seats/seats_cubit.dart';
import '../../../../data/data_resource/local_resource/data_store.dart';
import '../../../style/app_colors.dart';
import '../../../style/app_font_size.dart';
import '../../../style/app_images.dart';
import '../../../style/app_text_style_2.dart';

class PaymentDetailsCard extends StatelessWidget {
  const PaymentDetailsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReserveTripCubit,ReserveTripStates>(
      bloc:context.read<ReserveTripCubit>()..acceptTerms=false ,
      builder: (context, state) => SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 33.0,vertical: 10),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('details'.translate(),style: AppTextStyle2.getSemiBoldStyle(
                      fontSize: AppFontSize.size_14,
                      color: Colors.black,
                      fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                        Center(child: Text(DateFormat('E, LLL d ',DataStore.instance.lang).format(context.read<ResultSearchCubit>().selectedTripModel!.startDate??DateTime.now()).toString(),style: AppTextStyle.lightYellowNormal_14)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Text(DateFormat('jm',DataStore.instance.lang).format(context.read<ResultSearchCubit>().selectedTripModel!.startDate??DateTime.now()).toString(),style:   AppTextStyle2.getMediumStyle(
                            fontSize: AppFontSize.size_16,
                            color:  Colors.black,
                            fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Image.asset(AppImages.between2Image,width: 150,fit: BoxFit.cover,),
                          ),
                           Text('-',style:   AppTextStyle2.getMediumStyle(
                          fontSize: AppFontSize.size_16,
                          color:  Colors.black,
                          fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                        ],
                      ),
                      const SizedBox(height: 18,),
                      const Divider(color:AppColors.darkGrey ,),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                         // Image.network(context.read<ResultSearchCubit>().selectedTripModel?.company?.logo??''),
                          const SizedBox(width: 4,),
                           Row(
                             children: [
                               Text(context.read<ResultSearchCubit>().selectedTripModel?.company?.name??'',style:   AppTextStyle2.getBoldStyle(
                                fontSize: AppFontSize.size_14,
                                color:  Colors.black,
                                fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',).copyWith(
                                 fontFamily: DataStore.instance.lang=='ar'?'Tajawal-SemiBold':'Poppins-SemiBold',
                               ),),
                               Text('company'.translate(),style:   AppTextStyle2.getBoldStyle(
                                fontSize: AppFontSize.size_14,
                                color:  Colors.black,
                                fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',).copyWith(
                                 fontFamily: DataStore.instance.lang=='ar'?'Tajawal-SemiBold':'Poppins-SemiBold',
                               ),),
                             ],
                           ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          const Icon(Icons.account_box_outlined),
                          const SizedBox(width: 6),
                           Text(context.read<PassengerCubit>().passengerList.length.toString()  ,style: AppTextStyle2.getSemiBoldStyle(
                          fontSize: AppFontSize.size_12,
                          color:  Colors.black,
                          fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                          const SizedBox(width: 4),
                          Text('passenger'.translate()  ,style: AppTextStyle2.getSemiBoldStyle(
                          fontSize: AppFontSize.size_12,
                          color:  Colors.black,
                          fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) =>  Row(
                            children: [
                              Text(context.read<PassengerCubit>().passengerList[index].name??"", style: AppTextStyle2.getSemiBoldStyle(
                          fontSize: AppFontSize.size_14,
                          color: Colors.black,
                          fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                              const Spacer(),
                              Text(context.read<PassengerCubit>().passengerList[index].age.toString(), style: AppTextStyle2.getSemiBoldStyle(
                          fontSize: AppFontSize.size_14,
                          color: Colors.black,
                          fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                            ],
                          ),
                          separatorBuilder: (context, index) => const SizedBox(height: 15,) ,
                          itemCount: context.read<PassengerCubit>().passengerList.length),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.0),
                        child: Divider(color:AppColors.darkGrey ,),
                      ),
                      SizedBox(
                        child: Row(
                          children: [
                             Text(context.read<SeatsCubit>().seatsIds.length.toString(),style: AppTextStyle2.getSemiBoldStyle(
                            fontSize: AppFontSize.size_16,
                            color: Colors.black,
                            fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),softWrap: true),
                            const SizedBox(width: 4,),
                            Text('${'seats_2'.translate()} : ',style: AppTextStyle2.getSemiBoldStyle(
                            fontSize: AppFontSize.size_16,
                            color: Colors.black,
                            fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),softWrap: true),
                            Expanded(
                              child: SizedBox(
                                child: Wrap(
                                  children: List.generate(context.read<SeatsCubit>().seatsIds.length, (index) =>Text('${context.read<SeatsCubit>().seatsIds[index].number.toString()}, ',style: AppTextStyle2.getSemiBoldStyle(
                                fontSize: AppFontSize.size_16,
                                color: Colors.black,
                                fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins'),softWrap: true,maxLines: 2,),),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14,),
                      SizedBox(
                      width: double.infinity,
                      child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                       Text('${context.read<ResultSearchCubit>().selectedTripModel?.ticketPrice??''}',style:   AppTextStyle2.getRegularStyle(
                      fontSize: AppFontSize.size_18,
                      color:  Colors.black,
                      fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),softWrap: true,maxLines: 2,),
                      Text('price_per_ticket'.translate(),style:   AppTextStyle2.getRegularStyle(
                            fontSize: AppFontSize.size_18,
                            color:  Colors.black,
                            fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',).copyWith(fontSize: 14,
                          fontFamily: DataStore.instance.lang=='ar'?'Tajawal-Regular':'Poppins-Regular',)),
                      SizedBox(width: 22.w,),
                      ])),
                      const Divider(color:AppColors.darkGrey ,),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          children: [
                            Text('pay'.translate(),style: AppTextStyle2.getSemiBoldStyle(
                            fontSize: AppFontSize.size_21,
                            color:  Colors.black,
                            fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                            const Spacer(),
                             Text('${context.read<SeatsCubit>().price.toString()} ${context.read<MainCubit>().currency}',style: AppTextStyle.yellowW600_20,),
                          ],
                        ),
                      ),
              ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: CheckboxListTile(
                activeColor: AppColors.darkGreen,
                controlAffinity:ListTileControlAffinity.leading ,
                title:Text('terms_cond'.translate(),style: AppTextStyle2.getSemiBoldStyle(
                fontSize: AppFontSize.size_16,
                color: Colors.black,
                fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),softWrap: true
                  ,  maxLines: 2) ,
                value:context.read<ReserveTripCubit>().acceptTerms ,
                onChanged: (value) {
                  context.read<ReserveTripCubit>().acceptTermsFun(value??false);
                },),
            ),
          ],
        ),
      ),
    );
  }
}
