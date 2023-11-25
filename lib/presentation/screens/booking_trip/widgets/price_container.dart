import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/cubit/home/home_cubit.dart';
import 'package:trips/cubit/main/main_cubit.dart';

import '../../../../cubit/seats/seats_cubit.dart';
import '../../../../cubit/seats/seats_states.dart';
import '../../../../data/data_resource/local_resource/data_store.dart';
import '../../../common_widgets/custom_button.dart';
import '../../../common_widgets/dialog/error_dialog.dart';
import '../../../style/app_colors.dart';
import '../../../style/app_font_size.dart';
import '../../../style/app_text_style_2.dart';
import '../screens/fill_passengers_info.dart';


class PriceContainer extends StatelessWidget {
  const PriceContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   BlocBuilder<SeatsCubit,SeatsStates>(
      builder: (context, state) => Container(
        color: AppColors.lightGreyX,
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 32.w,vertical: 16.h),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Row(
                        children: [
                          Text('${'seats'.translate()} : ',style: AppTextStyle2.getSemiBoldStyle(
                          fontSize: AppFontSize.size_16,
                          color: Colors.black,
                          fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),softWrap: true),
                          Expanded(
                            child: SizedBox(
                              child: Wrap(
                                children: List.generate(context.read<SeatsCubit>().seatsIds.length, (index) =>Text('${context.read<SeatsCubit>().seatsIds[index].number.toString()}, ',style: AppTextStyle2.getSemiBoldStyle(
                                fontSize: AppFontSize.size_16,
                                color: Colors.black,
                                fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),softWrap: true,maxLines: 2),),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12,),
                    if(context.read<SeatsCubit>().price!=0)
                      Text('${context.read<SeatsCubit>().price.toString()} ${context.read<MainCubit>().currency}',style:   AppTextStyle2.getBoldStyle(
                        fontSize: AppFontSize.size_16,
                        color:  Colors.black,
                        fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
                  ],
                ),
              ),
              const SizedBox(width: 12,),
              CustomButton(
                h: 52,
                w: 121.w,
                radius: 32,
                color: AppColors.darkGreen,
                text: 'confirm'.translate(),
                 textStyle: AppTextStyle2.getSemiBoldStyle(
                    fontSize: AppFontSize.size_14,
                    color: Colors.white,
                    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                onPressed: () {
                  if(context.read<SeatsCubit>().seatsIds.length.toString()==context.read<HomeCubit>().passengers) {
                    AppRouter.navigateTo(context: context, destination: const PassengersInfoScreens());
                  } else {
                    ErrorDialog.openDialog(context, 'selected_seats_validate'.translate());
                  }
                },),
            ],
          ),
        ),
      ),
    );
  }
}
