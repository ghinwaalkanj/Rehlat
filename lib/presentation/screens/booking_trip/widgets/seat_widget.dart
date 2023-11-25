import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/utils/image_helper.dart';

import '../../../../cubit/home/home_cubit.dart';
import '../../../../cubit/seats/seats_cubit.dart';
import '../../../../cubit/seats/seats_states.dart';
import '../../../../data/data_resource/local_resource/data_store.dart';
import '../../../../domain/models/seat_model.dart';
import '../../../style/app_font_size.dart';
import '../../../style/app_images.dart';
import '../../../style/app_text_style_2.dart';

// ignore: must_be_immutable
class SeatWidget extends StatelessWidget {
  final SeatModel? seatModel;
  final double? height;
  final double? width;
  final double? padding;
   const SeatWidget({Key? key,  this.seatModel,  this.height,  this.width, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SeatsCubit,SeatsStates>(
      listener: (context, state) {},
       builder: (context, state) => InkWell(
        onTap: () {
          context.read<SeatsCubit>().selectSeatEvent(seatModel!,context.read<HomeCubit>().passengers);
          },
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            if(seatModel!.status=="available")ImageWidget(url: AppImages.whiteSeatImage,height:height?? 42,width:width?? 42,).buildAssetSvgImage(),
            if(seatModel!.status=="temporary") ImageWidget(url: AppImages.yellowSeatImage,height: height??42,width: width??42,).buildAssetSvgImage(),
            if(seatModel!.status=="available"&&seatModel!.selectedByMe==true) ImageWidget(url: AppImages.greenSeatImage,height:height?? 42,width:width?? 42,).buildAssetSvgImage(),
            if(seatModel!.status=="unavailable") ImageWidget(url: AppImages.greySeatImage,height:height?? 42,width:width?? 42,).buildAssetSvgImage(),
            if(seatModel!.status=="available"&&seatModel!.isSelected==true) ImageWidget(url: AppImages.inUseSeatIcon,height:height?? 42,width:width?? 42,).buildAssetSvgImage(),
            Padding(
              padding:  EdgeInsets.only(top:(padding!= null)?padding!: 6.0),
              child: Text(seatModel!.number.toString(),style:(padding!= null)?   AppTextStyle2.getBoldStyle(
                fontSize: AppFontSize.size_12,
                color:  Colors.black,
                fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',):   AppTextStyle2.getBoldStyle(
                fontSize: AppFontSize.size_14,
                color:  Colors.black,
                fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
            ),
          ],
        ),
      ),
    );
  }
}
