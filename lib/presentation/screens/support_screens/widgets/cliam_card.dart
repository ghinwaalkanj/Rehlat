import 'package:flutter/material.dart';
import 'package:trips/data/data_resource/local_resource/data_store.dart';
import 'package:trips/data/model/claim_model.dart';
import 'package:trips/presentation/screens/support_screens/widgets/subclaim_card.dart';
import 'package:trips/presentation/style/app_font_size.dart';
import 'package:trips/presentation/style/app_text_style_2.dart';

import '../../../style/app_colors.dart';

class ClaimCard extends StatelessWidget {
  final ClaimModel claimModel;
  const ClaimCard({Key? key, required this.claimModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        collapsedBackgroundColor:Colors.grey.withOpacity(0.3),
        backgroundColor: Colors.grey.withOpacity(0.3),
        collapsedShape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        iconColor: AppColors.primary,
        title: Text('${claimModel.reservationNumber} , ${claimModel.createdAt.toString().substring(0, 10)}',
          style:AppTextStyle2.getMediumStyle(
          fontSize: AppFontSize.size_16,
          color:  Colors.black,
          fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
        children: <Widget>[
          SubClaimCard(color: AppColors.primary,textColor:Colors.white,content: claimModel.message??'', ),
          if(claimModel.answer!=null)
          SubClaimCard(color: Colors.white60,textColor:AppColors.primary,content: claimModel.answer!,),
        ],
      ),
    );
  }
}