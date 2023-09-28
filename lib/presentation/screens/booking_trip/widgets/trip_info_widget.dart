import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trips/core/localization/app_localization.dart';
import '../../../../cubit/result_search_card/result_search_cubit.dart';
import '../../../../data/data_resource/local_resource/data_store.dart';
import '../../../style/app_colors.dart';
import '../../../style/app_font_size.dart';
import '../../../style/app_text_style_2.dart';
import 'cancel_reservation_dialog.dart';


class TripInfoWidget extends StatelessWidget {
  const TripInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 4,),
                      InkWell(
                          onTap:()=>cancelReservationDialog(context: context),
                          child: const Icon(Icons.arrow_back_outlined,color: Colors.white)),
                      const SizedBox(width: 12,),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(child: Text('${context.read<ResultSearchCubit>().selectedTripModel?.company?.name??''} ${'company'.translate()}',style:   AppTextStyle2.getSemiBoldStyle(
                              fontSize: AppFontSize.size_16,
                              color: Colors.white,
                              fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),maxLines: 2, )),
                            const Icon(Icons.timer_sharp,color: AppColors.darkYellow),
                            Text(DateFormat('jm',DataStore.instance.lang).format(context.read<ResultSearchCubit>().selectedTripModel!.startDate??DateTime.now()).toString(),style:   AppTextStyle2.getSemiBoldStyle(
                              fontSize: AppFontSize.size_16,
                              color: Colors.white,
                              fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',) ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2,),
                  Row(
                    children: [
                      const SizedBox(width: 40,),
                      Text('${context.read<ResultSearchCubit>().selectedTripModel?.sourceCity?.name??''} -  ${context.read<ResultSearchCubit>().selectedTripModel?.destinationCity?.name??''}',style:   AppTextStyle2.getSemiBoldStyle(
                        fontSize: AppFontSize.size_16,
                        color: Colors.white,
                        fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',) ),
                      const Spacer(),
                      Text('${context.read<ResultSearchCubit>().selectedTripModel?.startDate?.toString().substring(0,10)}',style:   AppTextStyle2.getSemiBoldStyle(
                        fontSize: AppFontSize.size_16,
                        color: Colors.white,
                        fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',) ),
                    ],
                  ),
                ],
              ),
            ),
            //  Spacer(),
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const SizedBox(width: 40,),
            //       // Row(
            //       //   children: [
            //       //     Icon(Icons.timer_sharp,color: AppColors.darkYellow),
            //       //     Text('17:00 ,',style:   AppTextStyle2.getSemiBoldStyle(
            //   fontSize: AppFontSize.size_16,
            //   color: Colors.white,
            //   fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',) ),
            //       //   ],
            //       // ),
            //     //  SizedBox(height: 10,),
            //       Text('Sat, 19th Aug',style:   AppTextStyle2.getSemiBoldStyle(
            //     fontSize: AppFontSize.size_16,
            //     color: Colors.white,
            //     fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',) ),
            //     ],
            //   ),
            const SizedBox(width: 12,),
          ],
        ),
      ),
    );
  }
}
