import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';

import '../../../../cubit/seats/seats_cubit.dart';
import '../../../../cubit/seats/seats_states.dart';
import '../../../../data/data_resource/local_resource/data_store.dart';
import '../../../common_widgets/dialog/error_dialog.dart';
import '../../../style/app_colors.dart';
import '../../../style/app_font_size.dart';
import '../../../style/app_text_style.dart';
import '../../../style/app_text_style_2.dart';

class TimeRowWidget extends StatelessWidget {
  const TimeRowWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SeatsCubit,SeatsStates>(
      builder: (context, state) => Container(
        decoration:  const BoxDecoration(
            color: AppColors.lightGreyX,
            borderRadius: BorderRadius.vertical(top: Radius.circular(33))
        ) ,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 19.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.timer_sharp,color: Colors.black,),
              const SizedBox(width: 8,),
              Text('reserved_time'.translate(),style:  AppTextStyle2.getRegularStyle(
                fontSize: AppFontSize.size_15,
                color:  Colors.black,
                fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
              const SizedBox(width: 4,),
              Text(context.read<SeatsCubit>().x,style: AppTextStyle.darkYellowNormal_16),
            ],
          ),
        ),
      ),
    );
  }
}
