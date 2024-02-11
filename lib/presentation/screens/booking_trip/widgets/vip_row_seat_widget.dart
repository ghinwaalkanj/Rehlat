import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trips/presentation/screens/booking_trip/widgets/seat_widget.dart';

import '../../../../cubit/result_search_card/result_search_cubit.dart';

class VipRowSeatWidget extends StatelessWidget {
  final int index;
  final bool isVip29;
  const VipRowSeatWidget({Key? key, required this.index,  this.isVip29=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SeatWidget(seatModel: context.read<ResultSearchCubit>().selectedTripModel?.seats?[index*3+0] ),
        SeatWidget(seatModel: context.read<ResultSearchCubit>().selectedTripModel?.seats?[index*3+1]),
        const Spacer(),
        (isVip29&&index==9)?const SizedBox(width: 0,):
        SeatWidget(seatModel: context.read<ResultSearchCubit>().selectedTripModel?.seats?[index*3+2]),
        SizedBox(width: 8.w,),
      ],
    );
  }
}
