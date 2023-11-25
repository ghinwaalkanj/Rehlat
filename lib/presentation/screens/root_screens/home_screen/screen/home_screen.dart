import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/data/data_resource/local_resource/data_store.dart';
import 'package:trips/presentation/common_widgets/cached_image.dart';
import 'package:trips/presentation/common_widgets/custom_error_screen.dart';
import 'package:trips/presentation/common_widgets/shimmer/horizontal_rectangle_list_shimmer.dart';
import 'package:trips/presentation/screens/root_screens/home_screen/screen/search_container_widget.dart';

import '../../../../../cubit/home/home_cubit.dart';
import '../../../../../cubit/home/home_states.dart';
import '../../../../style/app_font_size.dart';
import '../../../../style/app_text_style_2.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit,HomePageStates>(
      builder: (context, state) =>  Scaffold(
        body: (state is ErrorGetCompaniesState || state is ErrorGetCitiesState )
        ? CustomErrorScreen(onTap:() => context.read<HomeCubit>().getCities(), )
        : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SearchWidget(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14.0,horizontal: 21),
                child: Text('partners'.translate(),style:   AppTextStyle2.getBoldStyle(
              fontSize: AppFontSize.size_17,
              color:  Colors.black,
              fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
              ),
              context.read<HomeCubit>().isLoading
                  ?  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21),
                  child: SizedBox(
                      height: 187.h,
                      child: const HomeShimmerWidget()))
                  :  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 21),
                child: SizedBox(
                  height: 187.h,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
                          child: CachedImage(imageUrl:context.read<HomeCubit>().companiesList[index].logo,width: 200,fit: BoxFit.cover),
                      ) ,
                      separatorBuilder: (context, index) =>const SizedBox(width: 18) ,
                      itemCount: context.read<HomeCubit>().companiesList.length),
                ),
              ),

              const SizedBox(height: 12,)
            ],
          ),
        ),

      ),
    );
  }
}
