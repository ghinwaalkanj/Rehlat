import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/cubit/home/home_states.dart';
import 'package:trips/data/data_resource/local_resource/data_store.dart';
import 'package:trips/presentation/screens/root_screens/home_screen/screen/search_result_screen.dart';
import '../../../../../core/utils/image_helper.dart';
import '../../../../../cubit/home/home_cubit.dart';
import '../../../../../cubit/result_search_card/result_search_cubit.dart';
import '../../../../common_widgets/GENDER_DROP_DOWN.dart';
import '../../../../common_widgets/auth_text_form_field.dart';
import '../../../../common_widgets/custom_button.dart';
import '../../../../common_widgets/dialog/error_dialog.dart';
import '../../../../common_widgets/dialog/loading_dialog.dart';
import '../../../../style/app_font_size.dart';
import '../../../../style/app_text_style_2.dart';
import '../widgets/date_time_picker.dart';
import '../../../../style/app_colors.dart';
import '../../../../style/app_images.dart';
import '../../../../style/app_text_style.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<HomeCubit,HomePageStates>(
      bloc:  context.read<HomeCubit>()..isHomePage=true,
      listener: (context, state) {
        if (state is ValidateState)ErrorDialog.openDialog(context, 'fill_search_trip'.translate());
        if (state is ValidateReturnDateState)ErrorDialog.openDialog(context, 'return_date_validate'.translate());
        if (state is LoadingSearchTripState) LoadingDialog().openDialog(context);
        if (state is SuccessSearchTripState){
          LoadingDialog().closeDialog(context);
          if(context.read<HomeCubit>().isHomePage)AppRouter.navigateTo(context: context, destination:  SearchResultScreen(tripsList: context.read<HomeCubit>().tripsList,));
          context.read<HomeCubit>().isHomePage=false;
          context.read<ResultSearchCubit>().afterSearchTrip(newTripsList: context.read<HomeCubit>().tripsList);
        }
        if (state is ErrorSearchTripState) {
          LoadingDialog().closeDialog(context);
          ErrorDialog.openDialog(context,'${state.error} ${'try_again'.translate()}');
        }
      },
      builder: (context, state) =>
       Container(
          width: 430.w,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.center ,
                  colors: [
                    AppColors.lightGreen,
                    AppColors.darkGreen,
                  ]),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))
          ),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21.0),
              child: Column(
                  children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 10),
              Row(
               children: [
               Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                   Text('welcome_rehlat'.translate(), style:  AppTextStyle2.getSemiBoldStyle(
                     fontSize: AppFontSize.size_24,
                     fontWeight: DataStore.instance.lang=='ar'?FontWeight.w700:FontWeight.w600,
                     color: Colors.white,
                     fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                  ),
                   Text('enter_trip_info'.translate(), style:   AppTextStyle2.getMediumStyle(
                     fontSize: AppFontSize.size_16,
                     color: Colors.white,
                     fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
                ],
              ),
              const Spacer(),
               Image.asset(AppImages.whiteLogoImage)
                 ],
               ),
                    const SizedBox(height: 10,),
              Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16))
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height:21,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: DropDownAppWidget(
                            isSearch: true,
                            isSource: true,
                            borderSideColor: AppColors.xBlack,
                            fillColor: Colors.transparent,
                            textStyle:   AppTextStyle2.getBoldStyle(
                            fontSize: AppFontSize.size_14,
                            color:  Colors.black,
                            fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                            dropDownList: context.read<HomeCubit>().citiesList,
                            chooseTitle:'enter_src'.translate(),
                            selectionItem:context.read<HomeCubit>().source!=null?context.read<HomeCubit>().source.toString():null,
                            getSelectionId: (id) {
                              context.read<HomeCubit>().source=id;
                              int? x=int.tryParse(id!);
                              context.read<HomeCubit>().searchTripParam.sourceCity=x;
                               },),),
                        const SizedBox(height: 18,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: DropDownAppWidget(
                            isSearch: true,
                            borderSideColor: AppColors.xBlack,
                            fillColor: Colors.transparent,
                            textStyle:   AppTextStyle2.getBoldStyle(
                              fontSize: AppFontSize.size_14,
                              color:  Colors.black,
                              fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                            dropDownList: context.read<HomeCubit>().citiesList,
                            chooseTitle:'enter_dest'.translate(),
                             selectionItem: context.read<HomeCubit>().dest!=null?context.read<HomeCubit>().dest.toString():null,
                            getSelectionId: (id) {
                              context.read<HomeCubit>().dest=id;
                               context.read<HomeCubit>().searchTripParam.destinationCity=int.parse(id!);

                            },),),
                      ],
                    ),
                    if(state is !LoadingGetCitiesState)
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 38.0,right: 38,top: 18),
                          child: SizedBox(
                              height:54,
                              child: VerticalDivider(color: AppColors.darkXGreen,thickness: 1.5,)),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 50,
                          child: FloatingActionButton(
                             // mini: true,
                              onPressed: () {
                            context.read<HomeCubit>().reverseSource();
                          },
                              backgroundColor: AppColors.darkYellow,
                              child: const ImageWidget(url: AppImages.arrowsImage).buildAssetSvgImage()
                          ),
                        ),
                        const SizedBox(width: 28),
                      ],
                    ),
                    ]),
                    const SizedBox(height: 18,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              h: 50,
                              rowChild: const Icon(Icons.calendar_today_outlined,
                                  color: AppColors.darkGreen),
                              borderSideColor: AppColors.xBlack,
                              color: Colors.transparent,
                              text: context.read<HomeCubit>().searchTripParam.date?? 'go_date'.translate(),
                              textStyle:   AppTextStyle2.getBoldStyle(
                              fontSize: AppFontSize.size_12,
                              color:  Colors.black,
                              fontWeight: FontWeight.w900,
                              fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                              onPressed: () {
                                DateTimeWidget.selectDate(context, (dateTime) {
                                  context.read<HomeCubit>().date=dateTime;
                                  context.read<HomeCubit>().selectedDate=dateTime;
                                  context.read<HomeCubit>().addWeek(dateTime);
                                  context.read<HomeCubit>().addGoDate(dateTime);
                                });
                              },),
                          ),
                          const SizedBox(width: 15,),
                          Expanded(
                            child: CustomButton(
                              h: 50,
                              rowChild: const Icon(Icons.calendar_today_outlined,
                                  color: AppColors.darkGreen),
                              borderSideColor: AppColors.xBlack,
                              color: Colors.transparent,
                              text: ( context.read<HomeCubit>().returnDate!= null)?context.read<HomeCubit>().returnDate.toString().substring(0,10):'return_date'.translate(),
                              textStyle: AppTextStyle.lightGrayW500_16.copyWith(fontSize: 14),
                              onPressed: () {
                                DateTimeWidget.selectDate(context, (dateTime) {

                                  context.read<HomeCubit>().addReturnDate(dateTime);

                                });},),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18,),
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: AuthTextFormField(
                    controller:  context.read<HomeCubit>().passengerController,
                      onChanged: (value) {
                        context.read<HomeCubit>().passengers=value;
                        context.read<HomeCubit>().searchTripParam.passenger=value;},
                      textStyle:   AppTextStyle2.getMediumStyle(
                      fontSize: AppFontSize.size_16,
                      color:  Colors.black,
                      fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                      labelText: 'passenger_count'.translate(),
                      prefixIcon:Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0,),
                        child: const ImageWidget(url: AppImages.userIcon,width: 5,height: 5,fit: BoxFit.contain,).buildAssetSvgImage(),
                      ),
                      labelStyle: AppTextStyle.darkGreyNormal_16,
                      borderColor:AppColors.xBlack,
                      keyboardType: TextInputType.number,
                      enableColor: AppColors.darkGreen),
                   ),
                    const SizedBox(height: 18,),
                    CustomButton(
                      h: 50,
                      w: 346.w,
                      radius: 32,
                      color: AppColors.darkGreen,
                      text: 'search'.translate(),
                       textStyle: AppTextStyle2.getSemiBoldStyle(
                    fontSize: AppFontSize.size_14,
                    color: Colors.white,
                    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                      onPressed: () {
                        context.read<HomeCubit>().searchTrip();
                      },),
                const SizedBox(height: 16,),
                  ],
                ),
          ),
                    const SizedBox(height: 36,),
                  ],
            ),
          )
        ),
    );
  }
}
