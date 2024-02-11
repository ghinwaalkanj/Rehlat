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
import '../widgets/normal2_row_seat_widget.dart';
import '../widgets/price_container.dart';
import '../widgets/seats_info_widget.dart';
import '../widgets/time_widget.dart';
import '../widgets/trip_info_widget.dart';

class NormalSeatsInfoScreen extends StatefulWidget {
  const NormalSeatsInfoScreen({Key? key}) : super(key: key);

  @override
  State<NormalSeatsInfoScreen> createState() => _NormalSeatsInfoScreenState();
}

class _NormalSeatsInfoScreenState extends State<NormalSeatsInfoScreen> {
  bool lastStatus=true;

  ScrollController scrollController=ScrollController();

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
     lastStatus = _isShrink;    });
    }}

  bool get _isShrink {
    return  scrollController.hasClients && scrollController.offset > (1.sw - 96);}

  @override
  void initState() {
    super.initState();
    scrollController=scrollController..addListener(_scrollListener) ;
      context.read<SeatsCubit>().startTime(true);
  }

  @override
  Widget build(BuildContext context) {
     return BlocBuilder<SeatsCubit,SeatsStates>(
       bloc: context.read<SeatsCubit>()..selectedTicketPrice=context.read<ResultSearchCubit>().selectedTripModel?.ticketPrice??1,
       builder: (context, state) => WillPopScope(
         onWillPop: () async{
           cancelReservationDialog(context: context);
           return true;
         },
         child: Scaffold(
             body:
            Stack(
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
                          SocketWidget(tripId:context.read<ResultSearchCubit>().selectedTripModel?.id??0 ),
                          const TimeRowWidget(),
                          const SizedBox(height: 8,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 13.w,),
                              const VipSeatsInfoWidget(),
                              const SizedBox(
                                  height: 550,
                                  child: VerticalDivider(color: AppColors.lightXGrey,thickness:1,)),
                              Expanded(
                                child: ListView.separated(
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) => NormalRowSeatWidget(index:index),
                                    separatorBuilder: (context, index) => const SizedBox(height:6,),
                                    itemCount: 11),
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
