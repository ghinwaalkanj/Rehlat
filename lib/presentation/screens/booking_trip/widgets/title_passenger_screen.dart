import 'package:flutter/material.dart';
import 'package:trips/core/localization/app_localization.dart';

import '../../../../data/data_resource/local_resource/data_store.dart';
import '../../../style/app_font_size.dart';
import '../../../style/app_text_style_2.dart';
import 'cancel_reservation_dialog.dart';

class PassengerTitleWidget extends StatelessWidget {
  final String titleScreen;
  const PassengerTitleWidget({Key? key, required this.titleScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 2,),
              InkWell(
                  onTap:()=>Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_outlined,color: Colors.white)),
              const SizedBox(width: 16,),
              Expanded(
                child: Text(titleScreen.translate(),style:  AppTextStyle2.getSemiBoldStyle(
                  fontSize: AppFontSize.size_16,
                  color: Colors.white,
                  fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
              ),
              //const Spacer(),
              InkWell(
                  onTap: () => cancelReservationDialog(context:context ),
                  child: Text('cancel'.translate(),style: AppTextStyle2.getSemiBoldStyle(
                    fontSize: AppFontSize.size_14,
                    color: Colors.white,
                    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),)),
              const SizedBox(width: 16,),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text('${'welcome'.translate()} ${DataStore.instance.name}',style: AppTextStyle2.getSemiBoldStyle(
              fontSize: AppFontSize.size_14,
              color: Colors.white,
              fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
          ),
        ],
      ),
    );
  }
}
