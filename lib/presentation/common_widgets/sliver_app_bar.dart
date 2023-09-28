// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:trips/core/localization/app_localization.dart';
// import '../../cubit/home/home_cubit.dart';
// import '../screens/booking_trip/widgets/cancel_reservation_dialog.dart';
// import '../screens/booking_trip/widgets/child_base_app_bar.dart';
// import '../style/app_colors.dart';
// import '../style/app_text_style.dart';
//
// class SliverAppBarWidget extends StatelessWidget {
//   final String titleScreen;
//   final Widget? rightIcon;
//   final Widget child;
//   final double padding;
//   final ScrollController scrollController;
//
//   const SliverAppBarWidget(
//       {Key? key, required this.titleScreen, this.rightIcon, required this.child, required this.padding, required this.scrollController})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//             child: Stack(
//                 alignment: Alignment.topCenter,
//                 children: [
//                   Container(
//               color: AppColors.darkGreen,
//               child: Padding(
//                   padding:  EdgeInsets.only(top: padding),
//                   child: NestedScrollView(
//                       controller: scrollController,
//                       headerSliverBuilder: (context, innerBoxIsScrolled) => [
//                             SliverAppBar(
//                                 automaticallyImplyLeading: false,
//                                 expandedHeight: 180,
//                                 pinned: true,
//                                 floating: true,
//                                 backgroundColor: AppColors.darkGreen,
//                                 elevation: 0,
//                                 flexibleSpace: FlexibleSpaceBar(
//                                   titlePadding:  EdgeInsets.symmetric(horizontal: 22.0, vertical: 0),
//                                   title: Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                           mainAxisAlignment: MainAxisAlignment.start,
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             const Icon(Icons.arrow_back_outlined, color: Colors.white),
//                                             const SizedBox(width: 16,),
//                                             Text(titleScreen, style: AppTextStyle.whiteW700_16),
//                                             const Spacer(),
//                                             InkWell(
//                                                 onTap: () => cancelReservationDialog(context:context ),
//                                                 child: Text('cancel'.translate(),style: AppTextStyle.whiteW600_14)),
//                                             if (rightIcon != null) rightIcon!
//                                           ]),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(horizontal: 38.0),
//                                         child: Text('${context.read<HomeCubit>().searchTripParam.sourceCity?.name}  -  ${context.read<HomeCubit>().searchTripParam.destinationCity?.name}',
//                                           style: AppTextStyle.whiteW400_14,),
//                                       )
//                                     ],
//                                   ),
//                                     collapseMode: CollapseMode.pin,
//                                     /////  this widget will hide when expand
//                                     background: Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                                       child: Column(
//                                         children: [
//                                           Row(
//                                               mainAxisAlignment: MainAxisAlignment.start,
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 const Icon(Icons.arrow_back_outlined, color: Colors.white),
//                                                 const SizedBox(width: 16,),
//                                                 Text(titleScreen, style: AppTextStyle.whiteW700_16),
//                                                 const Spacer(),
//                                                 InkWell(
//                                                     onTap: () => cancelReservationDialog(context:context ),
//                                                     child: Text('cancel'.translate(),style: AppTextStyle.whiteW600_14)),
//                                                 if (rightIcon != null) rightIcon!
//                                               ]),
//                                           const SizedBox(height: 19,),
//                                           const ChildBaseAppBar(),
//                                         ],
//                                       ),
//                                     ),
//                                     /////  this widget will show when collapsed
//                                    ))
//                           ],
//                       body: Padding(
//                         padding: const EdgeInsets.only(top: 15.0),
//                         child: Container(
//                           decoration: const BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.vertical(top: Radius.circular(33))
//                           ),
//                           child: child,
//                         ),
//                       ),
//                   ))),
//
//         ])));
//   }
// }
