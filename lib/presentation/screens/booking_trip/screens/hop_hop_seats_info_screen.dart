import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trips/core/localization/app_localization.dart';

import '../../../../cubit/result_search_card/result_search_cubit.dart';
import '../../../../cubit/seats/seats_cubit.dart';
import '../../../../cubit/seats/seats_states.dart';
import '../../../common_widgets/base_app_bar.dart';
import '../../../style/app_colors.dart';
import '../widgets/cancel_reservation_dialog.dart';
import '../widgets/hop_hop_row_seat_widget.dart';
import '../widgets/price_container.dart';
import '../widgets/seats_info_widget.dart';
import '../widgets/time_widget.dart';
import '../widgets/trip_info_widget.dart';

class SmallSeatsInfoScreen extends StatefulWidget {
  const SmallSeatsInfoScreen({Key? key}) : super(key: key);

  @override
  State<SmallSeatsInfoScreen> createState() => _SmallSeatsInfoScreenState();
}

class _SmallSeatsInfoScreenState extends State<SmallSeatsInfoScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SeatsCubit>().startTime(true);
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SeatsCubit,SeatsStates>(
        bloc:  context.read<SeatsCubit>()..selectedTicketPrice=context.read<ResultSearchCubit>().selectedTripModel?.ticketPrice??1,
        listener: (context, state) {

        },
        builder: (context, state) =>  WillPopScope(
            onWillPop: () async {
              print(context.read<ResultSearchCubit>().selectedTripModel?.seats![0].number);
              print(context.read<ResultSearchCubit>().selectedTripModel?.seats![1].number);
              print(context.read<ResultSearchCubit>().selectedTripModel?.seats![2].number);
              print(context.read<ResultSearchCubit>().selectedTripModel?.seats![3].number);
              print(context.read<ResultSearchCubit>().selectedTripModel?.seats![4].number);
              cancelReservationDialog(context: context);
              return false;
            },
        child: Scaffold(
            body: Stack(
              children: [
              BaseAppBar(
                  titleScreen: 'seats_information'.translate(),
                  tripInfo: const TripInfoWidget(),
                  child:Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                              children:  [
                                const TimeRowWidget(),
                                const SizedBox(height: 24,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 22.w,),
                                    const VipSeatsInfoWidget(),
                                     SizedBox(
                                        height: MediaQuery.of(context).size.height*0.66,
                                        child: const VerticalDivider(color: AppColors.lightXGrey,thickness:1,)),
                                    SizedBox(width: 12.w,),
                                    Expanded(
                                      child: ListView.separated(
                                          padding: EdgeInsets.zero,
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) => HopHopRowSeatWidget(index:index),
                                          separatorBuilder: (context, index) => const SizedBox(height: 6,),
                                          itemCount: 7),
                                    ),
                                  ],
                                ),
                                const PriceContainer()
                              ]),
                        ),
                        if(context.read<SeatsCubit>().isLoadingSelect||context.read<SeatsCubit>().isLoadingUnSelect)
                          Container(
                            alignment: Alignment.center,
                            color: Colors.white60,
                            height: double.infinity,
                            width: double.infinity,
                            child: const CupertinoActivityIndicator(
                              color: AppColors.darkXGreen,
                              radius: 35,
                            ),)
                      ])),
            ],
          )),
    ));
  }
}
