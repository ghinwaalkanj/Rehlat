import 'package:flutter/material.dart';

import '../screens/booking_trip/widgets/child_base_app_bar.dart';
import '../screens/booking_trip/widgets/title_passenger_screen.dart';
import '../style/app_colors.dart';

class SliverAppBarWidget extends StatelessWidget {
  final String titleScreen;
  final Widget? rightIcon;
  final Widget child;
  final double padding;
  final ScrollController scrollController;

  const SliverAppBarWidget(
      {Key? key, required this.titleScreen, this.rightIcon, required this.child, required this.padding, required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Stack(
                alignment: Alignment.topCenter,
                children: [
                    Container(
                    color: AppColors.darkGreen,
                    child: Padding(
                    padding:  EdgeInsets.only(top: padding),
                    child: NestedScrollView(
                        controller: scrollController,
                      headerSliverBuilder: (context, innerBoxIsScrolled) => [
                            const SliverAppBar(
                                automaticallyImplyLeading: false,
                                expandedHeight: 195,
                                titleSpacing: 0,
                                pinned: true,
                                floating: true,
                                title:  PassengerTitleWidget(titleScreen: 'passenger_information',),
                                backgroundColor: AppColors.darkGreen,
                                elevation: 0,
                                flexibleSpace: FlexibleSpaceBar(
                                  titlePadding: EdgeInsets.zero,
                                //  title:  PassengerTitleWidget(titleScreen: 'passenger_information',),
                                    collapseMode: CollapseMode.pin,
                                    /////  this widget will hide when expand
                                    background: Padding(
                                      padding: EdgeInsets.only(left:  16,right: 16,top: 60),
                                      child: ChildBaseAppBar(),
                                    )
                                    /////  this widget will show when collapsed
                                   ))
                          ],
                      body: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(33))
                          ),
                          child: child,
                        ),
                      ),
                  ))),
        ])));
  }
}
