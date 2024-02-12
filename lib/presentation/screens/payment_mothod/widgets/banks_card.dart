import 'package:flutter/material.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/data/data_resource/local_resource/data_store.dart';
import 'package:trips/data/model/bank_model.dart';
import 'package:trips/presentation/style/app_colors.dart';
import 'package:trips/presentation/style/app_font_size.dart';
import 'package:trips/presentation/style/app_text_style_2.dart';

import 'banks_row_widget.dart';

class BanksListWidget extends StatelessWidget {
  final List<BankModel> bankList;
  const BanksListWidget({Key? key, required this.bankList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ExpansionTile(
        tilePadding: EdgeInsets.zero,
    childrenPadding: EdgeInsets.zero,
    collapsedShape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    iconColor: AppColors.primary,
    title: Text('banks'.translate(),
    style:AppTextStyle2.getMediumStyle(
    fontSize: AppFontSize.size_12,
    color:  Colors.black,
    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
    children: List.generate(bankList.length,
    (index) => BankRowWidget(bankModel:bankList[index])));
  }
}
