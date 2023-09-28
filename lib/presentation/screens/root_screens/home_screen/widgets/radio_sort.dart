import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';

import '../../../../../cubit/result_search_card/result_search_cubit.dart';
import '../../../../../cubit/result_search_card/result_search_state.dart';
import '../../../../../data/data_resource/local_resource/data_store.dart';
import '../../../../style/app_colors.dart';
import '../../../../style/app_font_size.dart';
import '../../../../style/app_text_style_2.dart';

class RadioSortByWidget extends StatelessWidget {
  const RadioSortByWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResultSearchCubit,ResultSearchStates>(
      builder: (context, state) =>  Expanded(
        child: ListView.builder(
          padding:EdgeInsets.zero,
          shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => RadioListTile(
                 contentPadding: EdgeInsets.zero,
                  dense: true,
                  selectedTileColor: AppColors.lightGreen,
                  activeColor:  AppColors.darkGreen,
                  title: Text(context.read<ResultSearchCubit>().sortByList[index].title.translate(),style:   AppTextStyle2.getBoldStyle(
                  fontSize: AppFontSize.size_14,
                  color:  Colors.black,
                  fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: context.read<ResultSearchCubit>().sortByList[index],
                  groupValue: context.read<ResultSearchCubit>().sortBy,
                  onChanged: (value) {
                    context.read<ResultSearchCubit>().onSelectSort(value,context.read<ResultSearchCubit>().sortByList[index].sort,context);
                  },
                ),
            itemCount: context.read<ResultSearchCubit>().sortByList.length),
      ),
    );
  }
}
