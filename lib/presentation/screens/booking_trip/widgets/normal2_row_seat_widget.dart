import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/presentation/screens/booking_trip/widgets/seat_widget.dart';
import '../../../../cubit/result_search_card/result_search_cubit.dart';

class NormalRowSeatWidget extends StatelessWidget {
  final int index;
  const NormalRowSeatWidget({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
         SeatWidget(seatModel: context.read<ResultSearchCubit>().selectedTripModel?.seats?[index*4+0]),
         SeatWidget(seatModel: context.read<ResultSearchCubit>().selectedTripModel?.seats?[index*4+1]),
         (index==10)?SeatWidget(seatModel: context.read<ResultSearchCubit>().selectedTripModel?.seats?[index*4+2]):const SizedBox(width: 42,),
         SeatWidget(seatModel: context.read<ResultSearchCubit>().selectedTripModel?.seats?[(index!=10)?index*4+2:index*4+3]),
         SeatWidget(seatModel: context.read<ResultSearchCubit>().selectedTripModel?.seats?[(index!=10)?index*4+3:index*4+4]),
         const SizedBox(width: 3,),
      ],
    );
  }
}
