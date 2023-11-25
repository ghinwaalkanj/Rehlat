import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/presentation/common_widgets/gender_drop_down.dart';

import '../../../../../cubit/home/home_cubit.dart';
import '../../../../../cubit/result_search_card/result_search_cubit.dart';
import '../../../../../data/data_resource/local_resource/data_store.dart';
import '../../../../common_widgets/dialog/action_alert_dialog.dart';
import '../../../../style/app_font_size.dart';
import '../../../../style/app_text_style_2.dart';

companiesFilterDialog({required BuildContext context,required VoidCallback? onConfirm,}) {
  return ActionAlertDialog.show(
    context,
      titleStyle: AppTextStyle2.getRegularStyle(
    fontSize: AppFontSize.size_16,
    color:  Colors.black,
    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
     dialogTitle: 'choose_company'.translate(),
    secondaryWidget: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: DropDownAppWidget(
          dropDownList: context.read<HomeCubit>().companiesList,
          chooseTitle: 'companies'.translate(),
          getSelectionId: (id) {
            context.read<ResultSearchCubit>().selectedCompany=id;
          },),
    ),
    confirmText: "apply".translate(),
    onConfirm: onConfirm,
  );
}