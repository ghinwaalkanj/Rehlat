import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/image_helper.dart';
import 'package:trips/data/data_resource/local_resource/data_store.dart';

import '../../../../cubit/result_search_card/result_search_cubit.dart';
import '../../../../cubit/seats/seats_cubit.dart';
import '../../../../cubit/seats/seats_states.dart';
import '../../../common_widgets/dialog/error_dialog.dart';
import '../../../style/app_colors.dart';
import '../../../style/app_font_size.dart';
import '../../../style/app_images.dart';
import '../../../style/app_text_style_2.dart';

class VipSeatsInfoWidget extends StatelessWidget {
  const VipSeatsInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<SeatsCubit,SeatsStates>(
      bloc: context.read<SeatsCubit>()..getAllList(tripModel:context.read<ResultSearchCubit>().selectedTripModel! ),
        listener: (context, state) {
          if(state is ValidateSeatsLengthState) ErrorDialog.openDialog(context, 'selected_seats_validate'.translate());
          if(state is StatusValidateState) ErrorDialog.openDialog(context, state.error);
        },
        builder: (context, state) =>  Padding(
        padding:  const EdgeInsets.only(top: 50,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('seats_info'.translate(),style:  AppTextStyle2.getBoldStyle(
              fontSize: AppFontSize.size_12,
              color:  Colors.black,
              fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
            const SizedBox(height:8,),
            Row(
              children: [
                const ImageWidget(url:AppImages.whiteSeatImage,height: 32,width: 32,fit: BoxFit.fill,).buildAssetSvgImage(),
                const SizedBox(width: 7,),
                Text('available'.translate(),style: AppTextStyle2.getSemiBoldStyle(
                  fontSize: AppFontSize.size_14,
                  color: Colors.black,
                  fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
              ],
            ),
            const SizedBox(height: 12,),
            Row(
              children: [
                const ImageWidget(url:AppImages.yellowSeatImage,height: 32,width: 32,fit: BoxFit.fill,).buildAssetSvgImage(),
                 const SizedBox(width: 7,),
                Text('temp'.translate(), style: AppTextStyle2.getSemiBoldStyle(
                      fontSize: AppFontSize.size_14,
                      color: Colors.black,
                      fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
              ],
            ),
                  const SizedBox(height: 12,),
            Row(
              children: [
                const ImageWidget(url:AppImages.greySeatImage,height: 32,width: 32,fit: BoxFit.fill,).buildAssetSvgImage(),
                 const SizedBox(width: 7,),
                Text('unavailable'.translate(), style: AppTextStyle2.getSemiBoldStyle(
                fontSize: AppFontSize.size_14,
                color: Colors.black,
                fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
              ],
            ),
                  const SizedBox(height: 12,),
            Row(
              children: [
                const ImageWidget(url:AppImages.greenSeatImage,height: 32,width: 32,fit: BoxFit.fill,).buildAssetSvgImage(),
                const SizedBox(width: 7,),
                Text('selected'.translate(), style: AppTextStyle2.getSemiBoldStyle(
                fontSize: AppFontSize.size_14,
                color: Colors.black,
                fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
              ],
            ),
                  const SizedBox(height: 12,),
            Row(
              children: [
                const ImageWidget(url:AppImages.inUseSeatIcon,height: 32,width: 32,fit: BoxFit.fill,).buildAssetSvgImage(),
                const SizedBox(width: 7,),
                Text('inuse'.translate(), style: AppTextStyle2.getSemiBoldStyle(
                fontSize: AppFontSize.size_14,
                color: Colors.black,
                fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
              ],
            ),
            const SizedBox(
                width: 110,
                child: Divider(color: AppColors.lightXGrey,thickness:1,height: 33,)),
            Row(
              children: [
                const ImageWidget(url: AppImages.whiteSeatImage,height: 32,width: 32,).buildAssetSvgImage(),
                const SizedBox(width: 7,),
                Text('seats'.translate(), style: AppTextStyle2.getSemiBoldStyle(
                fontSize: AppFontSize.size_14,
                color: Colors.black,
                fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
              ],
            ),
                  const SizedBox(height: 12,),
            Row(
              children: [
                Text('all_seats'.translate(), style: AppTextStyle2.getSemiBoldStyle(
                fontSize: AppFontSize.size_14,
                color: Colors.black,
                fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                const SizedBox(width: 7,),
                Text(context.read<ResultSearchCubit>().selectedTripModel?.seatsLeaft.toString()??"0", style: AppTextStyle2.getSemiBoldStyle(
                fontSize: AppFontSize.size_14,
                color: Colors.black,
                fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
              ],
            ),
            const SizedBox(height: 13,),
            Row(
              children: [
                const ImageWidget(url: AppImages.whiteSeatImage,height: 32,width: 32,).buildAssetSvgImage(),
                const SizedBox(width: 7,),
                Row(
                  children: [
                    Text('available'.translate()  ,style: AppTextStyle2.getSemiBoldStyle(
                    fontSize: AppFontSize.size_12,
                    color:  Colors.black,
                    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                    const SizedBox(height: 6,),
                     Text(': ${context.read<SeatsCubit>().availableList.length.toString()}'  ,style: AppTextStyle2.getSemiBoldStyle(
                      fontSize: AppFontSize.size_12,
                      color:  Colors.black,
                      fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                  ],
                ),
              ],
            ),
               //   const SizedBox(height: 12,),
            // Row(
            //   children: [
            //     ImageWidget(url: AppImages.yellowSeatImage,height: 32,width: 32,).buildAssetSvgImage(),
            //      const SizedBox(width: 7,),
            //     Row(
            //       children: [
            //         Text('temp'.translate()  style: AppTextStyle2.getSemiBoldStyle(
  // fontSize: AppFontSize.size_12,
  // color:  Colors.black,
  // fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
            //         const SizedBox(height: 6,),
            //          Text(': ${context.read<ReserveTripCubit>().tempList.length.toString()}'  style: AppTextStyle2.getSemiBoldStyle(
  // fontSize: AppFontSize.size_12,
  // color:  Colors.black,
  // fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
            //       ],
            //     ),
            //       ]),
                  const SizedBox(height: 12,),
                  Row(
                  children: [
                  const ImageWidget(url: AppImages.greenSeatImage,height: 32,width: 32,).buildAssetSvgImage(),
                  const SizedBox(width: 7,),
                  Row(
                  children: [
                  Text('selected'.translate()  ,style: AppTextStyle2.getSemiBoldStyle(
                    fontSize: AppFontSize.size_12,
                    color:  Colors.black,
                    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                  const SizedBox(height: 6,),
                  Text(': ${context.read<SeatsCubit>().seatsIds.length.toString()}'.toString()  ,style: AppTextStyle2.getSemiBoldStyle(
                    fontSize: AppFontSize.size_12,
                    color:  Colors.black,
                    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                  ],
                  ),
              ],
            ),
          ],
        ),
    ));
  }
}
