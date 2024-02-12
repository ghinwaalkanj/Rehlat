import 'package:flutter/material.dart';
import 'package:trips/data/data_resource/local_resource/data_store.dart';
import 'package:trips/data/model/bank_model.dart';
import 'package:trips/presentation/style/app_font_size.dart';
import 'package:trips/presentation/style/app_text_style_2.dart';

class BankRowWidget extends StatelessWidget {
  final BankModel bankModel;
  const BankRowWidget({Key? key, required this.bankModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              child: Image.network(bankModel.logo??'',height: 30,width: 30)),
          const SizedBox(width: 30,),
          Text(bankModel.name??'',style: AppTextStyle2.getMediumStyle(
            fontSize: AppFontSize.size_12,
            color:  Colors.black,
            fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
        ],
      ),
    );
  }
}
