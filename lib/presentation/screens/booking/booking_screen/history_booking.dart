import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';

import '../../../../cubit/booking/booking_cubit.dart';
import '../../../../cubit/booking/booking_states.dart';
import '../../../../cubit/root/root_cubit.dart';
import '../../../common_widgets/custom_error_screen.dart';
import '../../../common_widgets/shimmer/vertical_list_shimmer.dart';
import '../../../style/app_colors.dart';
import '../../root_screens/home_screen/screen/no_trip_screen.dart';
import '../widgets/booking_card.dart';

class HistoryBookingScreen extends StatelessWidget {
  const HistoryBookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   BlocBuilder<BookingCubit,BookingStates>(
        builder: (context, state) =>
        ( context.read<BookingCubit>().isLoading )
        ? const Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.0),
        child: VerticalShimmerListWidget(),)
        : (state is ErrorBookingState )
        ? CustomErrorScreen(onTap: () => context.read<BookingCubit>().getBookingList(),)
        :  context.read<BookingCubit>().historyList.isEmpty
        ? Expanded(
      child: NoTripScreen(title:'no_trip_booking'.translate() ,buttonTitle:'start'.translate() ,
          subTitle:'start_trip'.translate() ,onPressed:() {
            context.read<RootPageCubit>().changePageIndex(0);}),)
        : Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: RefreshIndicator(
                    onRefresh: () => context.read<BookingCubit>().getBookingList(),
                  child: ListView.separated(
                      itemBuilder: (context, index) =>  BookingCard(color: AppColors.lightGreyXX,
                          isHistory: true,
                          bookingTripModel:  context.read<BookingCubit>().historyList[index]
                      ),
                      separatorBuilder: (context, index) =>const SizedBox(height: 20) ,
                      itemCount: context.read<BookingCubit>().historyList.length),
                ),
    ),
        ));
  }
  }
