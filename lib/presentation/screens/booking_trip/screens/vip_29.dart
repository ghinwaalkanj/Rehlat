import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/presentation/common_widgets/socket_io/socket.dart';

import '../../../../cubit/result_search_card/result_search_cubit.dart';
import '../../../../cubit/seats/seats_cubit.dart';
import '../../../../cubit/seats/seats_states.dart';
import '../../../common_widgets/base_app_bar.dart';
import '../../../style/app_colors.dart';
import '../widgets/cancel_reservation_dialog.dart';
import '../widgets/price_container.dart';
import '../widgets/seats_info_widget.dart';
import '../widgets/time_widget.dart';
import '../widgets/trip_info_widget.dart';
import '../widgets/vip_row_seat_widget.dart';

class VipSeats29InfoScreen extends StatefulWidget {
  const VipSeats29InfoScreen({Key? key}) : super(key: key);

  @override
  State<VipSeats29InfoScreen> createState() => _VipSeats29InfoScreenState();
}

class _VipSeats29InfoScreenState extends State<VipSeats29InfoScreen> {
  // todo  remove this and rely on api
  updateSeats() {
    for (int i = 0; i < 19; i++) {
      context.read<ResultSearchCubit>().selectedTripModel?.seats?[i].status='unavailable';
    }
  }
  @override
  void initState() {
    super.initState();
    context.read<SeatsCubit>().startTime(true);
    updateSeats();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SeatsCubit,SeatsStates>(
      bloc: context.read<SeatsCubit>()..selectedTicketPrice=context.read<ResultSearchCubit>().selectedTripModel?.ticketPrice??1,
      listener: (context, state) {},
      builder: (context, state) =>  WillPopScope(
        onWillPop: () async{
          cancelReservationDialog(context: context);
          return true;
        },
        child: Scaffold(
            body: Stack(
              children: [
                BaseAppBar(
                    titleScreen:'seats_information'.translate(),
                    tripInfo: const TripInfoWidget(),
                    child:Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          SingleChildScrollView(
                            child: Column(
                                children:  [
                                  SocketWidget(tripId:context.read<ResultSearchCubit>().selectedTripModel?.id??0 ),
                                  const TimeRowWidget(),
                                  const SizedBox(height: 8,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 22.w,),
                                      const VipSeatsInfoWidget(),
                                      SizedBox(
                                          height: MediaQuery.of(context).size.height*0.68,
                                          child: const VerticalDivider(color: AppColors.lightXGrey,thickness:1,)),
                                      SizedBox(width: 12.w,),
                                      Expanded(
                                        child: ListView.separated(
                                            padding: EdgeInsets.zero,
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) => VipRowSeatWidget(index:index,isVip29: true),
                                            separatorBuilder: (context, index) => const SizedBox(height: 6,),
                                            itemCount: 10),
                                      ),
                                    ],
                                  ),
                                  const PriceContainer()
                                ]),
                          )
                        ])),
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
              ],
            )),
      ),
    );
  }
}
