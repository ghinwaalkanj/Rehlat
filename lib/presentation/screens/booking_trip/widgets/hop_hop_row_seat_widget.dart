import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trips/presentation/screens/booking_trip/widgets/seat_widget.dart';
import '../../../../cubit/result_search_card/result_search_cubit.dart';

class HopHopRowSeatWidget extends StatelessWidget {
  final int index;
  const HopHopRowSeatWidget({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SeatWidget( seatModel: context.read<ResultSearchCubit>().selectedTripModel?.seats?[index*4+0], ),
        SeatWidget( seatModel: context.read<ResultSearchCubit>().selectedTripModel?.seats?[index*4+1],),
        (!((index==0)||(index==6)))? Padding(
         padding: const EdgeInsets.only(top: 32.0),
         child: SeatWidget(
           seatModel: context.read<ResultSearchCubit>().selectedTripModel?.seats?[(!((index==0)||(index==6)))?index*4+2:index*4+3],
           width:35,height:35 ,padding: 4, ),
          ): SizedBox(width: 33.w,),
        SeatWidget( seatModel: context.read<ResultSearchCubit>().selectedTripModel?.seats?[(((index==0)||(index==6)))?index*4+2:index*4+3]),
        SizedBox(width: 8.w,),
      ],
    );
  }
}
