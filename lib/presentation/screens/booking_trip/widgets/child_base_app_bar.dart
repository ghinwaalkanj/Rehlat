import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:trips/core/localization/app_localization.dart';
import '../../../../core/utils/image_helper.dart';
import '../../../../cubit/home/home_cubit.dart';
import '../../../../cubit/main/main_cubit.dart';
import '../../../../cubit/result_search_card/result_search_cubit.dart';
import '../../../../cubit/seats/seats_cubit.dart';
import '../../../../data/data_resource/local_resource/data_store.dart';
import '../../../style/app_font_size.dart';
import '../../../style/app_images.dart';
import '../../../style/app_text_style.dart';
import '../../../style/app_text_style_2.dart';

class ChildBaseAppBar extends StatelessWidget {
  const ChildBaseAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Container(
            //   clipBehavior: Clip.antiAliasWithSaveLayer,
            //   decoration: const BoxDecoration(
            //     shape: BoxShape.circle,
            //     //borderRadius: BorderRadius.all(Radius.circular(50)),
            //  //   image: DecorationImage(image:AssetImage(AppImages.lmaImage,)
            //    // ),
            //   ),child: Image.asset( AppImages.lmaImage,height: 25,width: 25,),
            // ),
             Expanded(child: Text(context.read<ResultSearchCubit>().selectedTripModel?.company?.name??'',style:  AppTextStyle2.getSemiBoldStyle(
               fontSize: AppFontSize.size_14,
               color: Colors.white,
               fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),softWrap: true,)),
           // / const SizedBox(width: 12,),
             Text('${context.read<HomeCubit>().passengers} ${'passenger'.translate()}',style:   AppTextStyle2.getSemiBoldStyle(
               fontSize: AppFontSize.size_12,
               color: Colors.white,
               fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',))
          ],
        ),
        const SizedBox(height: 0,),
        Text(DateFormat('E, LLL d ',DataStore.instance.lang).format(context.read<HomeCubit>().date??DateTime.now()).toString(),
          style: AppTextStyle2.getSemiBoldStyle(
                    fontSize: AppFontSize.size_14,
                    color: Colors.white,
                    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${context.read<ResultSearchCubit>().selectedTripModel?.startDate?.hour??''} : ${context.read<ResultSearchCubit>().selectedTripModel?.startDate?.minute??''}',style:   AppTextStyle2.getSemiBoldStyle(
  fontSize: AppFontSize.size_16,
  color: Colors.white,
  fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                  Text(context.read<ResultSearchCubit>().selectedTripModel?.sourceCity?.name??'',style: AppTextStyle.whiteW400_14,
                    softWrap: true,
                  ),
                ],
              ),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 6.w),
              child: ImageWidget(url:AppImages.betweenImage,color: Colors.white ,).buildAssetSvgImage(),
             // Image.asset(AppImages.betweenImage,width: 180.w,height: 45.h,color: Colors.white,fit: BoxFit.contain),
            ),
             Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.read<ResultSearchCubit>().selectedTripModel?.destinationCity?.name??'',style: AppTextStyle.whiteW400_14,
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14,),
         Row(
          children: [
            Text('pay'.translate(),style:  AppTextStyle2.getSemiBoldStyle(
              fontSize: AppFontSize.size_18,
              color: Colors.white,
              fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
            SizedBox(width: 16),
            Expanded(
              child: Text('${context.read<SeatsCubit>().price.toString()} ${context.read<MainCubit>().currency}',
                style: AppTextStyle.yellowW600_20,
                softWrap: true,
              ),
            ),
          ],
         ),
      ],
    );
  }
}