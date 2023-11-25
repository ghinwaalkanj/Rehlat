import 'package:flutter/material.dart';

import '../../../../core/utils/utils_functions.dart';
import '../../../../data/data_resource/local_resource/data_store.dart';
import '../../../../data/model/notification_model/notification_model.dart';
import '../../../style/app_colors.dart';
import '../../../style/app_font_size.dart';
import '../../../style/app_text_style_2.dart';

class NotificationWidget extends StatelessWidget {
  final NotificationModel notificationModel;
   const NotificationWidget({Key? key, required this.notificationModel,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 90,
     width: double.infinity,
     color: AppColors.white,
     child: Padding(
       padding: const EdgeInsets.symmetric(vertical: 6.0),
       child: Row(
         crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 26.0,vertical: 10),
              child: CircleAvatar(
                 radius: 7,
                backgroundColor: AppColors.primary,),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(notificationModel.notification?.message??'',
                        style:   AppTextStyle2.getBoldStyle(
                          fontSize: AppFontSize.size_14,
                          color:  Colors.black,
                          fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      child: Text(FunctionUtils().getHumanTime(notificationModel.createdAt)??'',
                        style:   AppTextStyle2.getBoldStyle(
                        fontSize: AppFontSize.size_12,
                        color:  Colors.grey,
                        fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
     )
    );
  }
}