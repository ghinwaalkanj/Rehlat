import 'package:flutter/material.dart';

import '../../../../core/utils/utils_functions.dart';
import '../../../../data/data_resource/local_resource/data_store.dart';
import '../../../../data/model/notification_model/notification_model.dart';
import '../../../style/app_colors.dart';
import '../../../style/app_font_size.dart';
import '../../../style/app_text_style_2.dart';

class NotificationCardWidget extends StatelessWidget {
  final NotificationModel notificationModel;
   const NotificationCardWidget({Key? key, required this.notificationModel,}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
     width: double.infinity,
     color: AppColors.white,
     child: Padding(
       padding: const EdgeInsets.symmetric(vertical: 6.0),
       child: Row(
         crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 20.0,vertical: 10),
              child: CircleAvatar(
                 radius: 7,
                backgroundColor: AppColors.primary,),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 12.0),
                    child: Text(notificationModel.notification?.message??'',
                      textAlign: DataStore.instance.lang=='ar'? TextAlign.start :TextAlign.end,
                      textDirection:TextDirection.rtl,
                      style:   AppTextStyle2.getBoldStyle(
                        fontSize: AppFontSize.size_14,
                        color:  Colors.black,
                        fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                    ),
                  ),
                  const SizedBox(height: 4,),
                  Text(FunctionUtils().getHumanTime(notificationModel.createdAt)??'',
                    style:   AppTextStyle2.getBoldStyle(
                    fontSize: AppFontSize.size_12,
                    color:  Colors.grey,
                    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)
                  ),
                ],
              ),
            )
          ],
        ),
     )
    );
  }
}