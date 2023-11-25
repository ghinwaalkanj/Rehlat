import 'package:flutter/material.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/presentation/style/app_colors.dart';
import 'package:trips/presentation/style/app_text_style.dart';

import '../../../../core/utils/image_helper.dart';
import '../../../../data/data_resource/local_resource/data_store.dart';
import '../../../common_widgets/dialog/action_alert_dialog.dart';
import '../../../style/app_font_size.dart';
import '../../../style/app_images.dart';
import '../../../style/app_text_style_2.dart';

  successBookingDialog({required BuildContext context}) {
    return ActionAlertDialog.show(
              context,
              imageUrl:const ImageWidget(url: AppImages.successDialogImage,width: 88,height: 88,fit: BoxFit.fill,).buildAssetSvgImage(),
              dialogTitle: 'success_booking_title'.translate(),
              isExistOr: true,
              secondaryWidget: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('to_cancel_booking'.translate(),style: AppTextStyle.lightBlackW400_13.copyWith(
                          fontFamily: DataStore.instance.lang=='ar'?'Tajawal-Regular':null
                      ),),
                      Text('my_booking'.translate(),style: AppTextStyle2.getSemiBoldStyle(
                        fontSize: AppFontSize.size_14,
                        color: AppColors.xBlack,
                        fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 23.0,bottom: 15),
                    child: Text('complete_reservation'.translate(),style: AppTextStyle2.getSemiBoldStyle(
                      fontSize: AppFontSize.size_16,
                      color: Colors.black,
                      fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),softWrap: true),
                  ),
                  Text('got_it'.translate(),style:  AppTextStyle2.getSemiBoldStyle(
                    fontSize: AppFontSize.size_16,
                    color:  AppColors.darkXGreen,
                    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),

                ],
              ),
              confirmText: 'home'.translate(),
              onConfirm: () {}
    );
  }
