import 'package:flutter/material.dart';
import 'package:trips/core/localization/app_localization.dart';

import '../../../../data/data_resource/local_resource/data_store.dart';
import '../../../../domain/models/profile_card_model.dart';
import '../../../style/app_colors.dart';
import '../../../style/app_font_size.dart';
import '../../../style/app_text_style_2.dart';

class ProfileCard extends StatelessWidget {
  final Widget? widgetCard;
  final ProfileCardModel? profileCardModel;
  final BorderRadiusGeometry? borderRadius;
  final bool isLogout;
  const ProfileCard({Key? key,this.widgetCard, this.profileCardModel,this.borderRadius,  this.isLogout=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widgetCard==null? profileCardModel!.screenDestination:null,
      child: Container(
        clipBehavior: Clip.antiAlias,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
          borderRadius: borderRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 24),
          child: Row(
            children: [
              widgetCard ??
              Text(profileCardModel!.title.translate(),style:   AppTextStyle2.getBoldStyle(
                fontSize: AppFontSize.size_14,
                color:  Colors.black,
                fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
              const Spacer(),
              if(!isLogout)
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.lightXXGrey),
                      borderRadius: const BorderRadius.all(Radius.circular(13))
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_forward_ios_rounded,color: Colors.black,),
                  ))
            ],
          ),
        ),

      ),
    );
  }
}
