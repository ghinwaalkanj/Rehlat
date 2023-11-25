import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/data/model/trip_model.dart';
import 'package:trips/presentation/screens/root_screens/home_screen/screen/sort_by_bottom_sheet.dart';
import 'package:trips/presentation/screens/root_screens/root_screen.dart';

import '../../../../../core/utils/enums.dart';
import '../../../../../core/utils/image_helper.dart';
import '../../../../../cubit/home/home_cubit.dart';
import '../../../../../cubit/result_search_card/result_search_cubit.dart';
import '../../../../../cubit/result_search_card/result_search_state.dart';
import '../../../../../cubit/root/root_cubit.dart';
import '../../../../../cubit/seats/seats_cubit.dart';
import '../../../../../data/data_resource/local_resource/data_store.dart';
import '../../../../common_widgets/base_app_bar.dart';
import '../../../../common_widgets/dialog/error_dialog.dart';
import '../../../../common_widgets/dialog/loading_dialog.dart';
import '../../../../style/app_colors.dart';
import '../../../../style/app_font_size.dart';
import '../../../../style/app_images.dart';
import '../../../../style/app_text_style.dart';
import '../../../../style/app_text_style_2.dart';
import '../../../booking_trip/screens/hop_hop_seats_info_screen.dart';
import '../../../booking_trip/screens/normal2_seats_info_screen.dart';
import '../../../booking_trip/screens/unknown_bus_info_screen.dart';
import '../../../booking_trip/screens/vip_seats_info_screen.dart';
import '../widgets/search_card_result.dart';
import 'no_trip_screen.dart';

class SearchResultScreen extends StatelessWidget {
  final List<TripModel> tripsList;
  const SearchResultScreen({Key? key, required this.tripsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   BlocConsumer<ResultSearchCubit,ResultSearchStates>(
      bloc:  context.read<ResultSearchCubit>()..tripsList=tripsList,
      listener: (context, state) {
        context.read<SeatsCubit>().seatsIds=[];
        context.read<SeatsCubit>().price=0;
        LoadingDialog().closeDialog(context);
        if(state is LoadingGetTripDetailsState&&context.read<ResultSearchCubit>().goToSendOtp==false)LoadingDialog().openDialog(context);
        if(state is SuccessGetTripDetailsState){
          LoadingDialog().closeDialog(context);
          if(context.read<ResultSearchCubit>().goToSendOtp==false){
             if(context.read<ResultSearchCubit>().selectedTripModel?.busModel?.numberSeat==33) {
              AppRouter.navigateRemoveTo(context: context, destination: const VipSeatsInfoScreen());
            }
            else if(context.read<ResultSearchCubit>().selectedTripModel?.busModel?.numberSeat==45) {
              AppRouter.navigateRemoveTo(context: context, destination: const NormalSeatsInfoScreen());
            }
            else if(context.read<ResultSearchCubit>().selectedTripModel?.busModel?.numberSeat==27) {
              AppRouter.navigateRemoveTo(context: context, destination: const SmallSeatsInfoScreen());
            }
            else{
              AppRouter.navigateRemoveTo(context: context, destination: const UnknownBusScreen());
            }
          }
        }
        if(state is ErrorGetTripDetailsState){
          LoadingDialog().closeDialog(context);
          ErrorDialog.openDialog(context, 'error_evaluation'.translate());
        }
      },
      builder: (context, state) => WillPopScope(
              onWillPop: () async{
                AppRouter.navigateRemoveTo(context: context, destination: const RootScreen());
                return true;
              },
        child: BaseAppBar(
          onTap: () => AppRouter.navigateRemoveTo(context: context, destination: const RootScreen()),
          titleScreen:DataStore.instance.lang=='en'
              ?  '${context.read<HomeCubit>().srcCity?.nameEn} -  ${context.read<HomeCubit>().destCity?.nameEn}'
              :  '${context.read<HomeCubit>().srcCity?.nameAr} -  ${context.read<HomeCubit>().destCity?.nameAr}',
          rightIcon: context.read<ResultSearchCubit>().tripsList.isNotEmpty?
          InkWell(
              onTap: () => showModalBottomSheet(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top:Radius.circular(50)),),
                  context: context, builder: (context) =>  const SortByBottomSheet()),
              child: const ImageWidget(url: AppImages.arrowsImage,width: 28,height: 28,fit: BoxFit.fill,).buildAssetSvgImage()):null,
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Container(
                    height: 60,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                       border:  Border.symmetric(vertical:BorderSide.none,),
                      color: AppColors.greyXx,
                      borderRadius: BorderRadius.all(Radius.circular(13))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child:ListView.separated(
                        shrinkWrap: true,
                           scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) =>Center(
                            child: InkWell(
                              onTap: () {
                                 context.read<HomeCubit>().selectDate(context.read<HomeCubit>().weekList[index]);
                                 context.read<HomeCubit>().searchTrip();
                                 context.read<ResultSearchCubit>().afterSearchTrip(newTripsList:  context.read<HomeCubit>().tripsList);
                              },
                              child: Text(DateFormat('E, LLL d ',DataStore.instance.lang).format(context.read<HomeCubit>().weekList[index]).toString(),
                                 style: context.read<HomeCubit>().weekList[index]== context.read<HomeCubit>().selectedDate?
                                 AppTextStyle.darkXGreenW500_14 :  AppTextStyle2.getBoldStyle(
                                fontSize: AppFontSize.size_14,
                                color:  Colors.black,
                                fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',).copyWith(fontWeight: FontWeight.w400),),
                            ),
                          ),
                          separatorBuilder: (context, index) => const SizedBox(width: 16,),
                          itemCount: 7)
                    ),
                  ),
                  context.read<ResultSearchCubit>().tripsList.isNotEmpty
                  ? Expanded(
                    child: ListView.builder(
                        itemBuilder: (context, index) =>SearchResultCard(index:index,
                          tripModel:(context.read<ResultSearchCubit>().selectedSort==Sort.companyName)
                              ? context.read<ResultSearchCubit>().companyTripsList[index]
                              : context.read<ResultSearchCubit>().tripsList[index] , ) ,
                        itemCount:(context.read<ResultSearchCubit>().selectedSort==Sort.companyName)
                        ? context.read<ResultSearchCubit>().companyTripsList.length
                        : context.read<ResultSearchCubit>().tripsList.length),
                         )
                      :  Expanded(
                        child: NoTripScreen(title:'no_trip'.translate() ,buttonTitle:'search_again'.translate() ,
                        subTitle:'change_date'.translate() ,onPressed:() {
                          context.read<RootPageCubit>().index=0;
                          AppRouter.navigateRemoveTo(context: context, destination: const RootScreen());}),
                      ),
                ]),
          )
        ),
      ),
    );
  }
}
