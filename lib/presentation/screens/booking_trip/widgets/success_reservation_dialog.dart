import 'package:flutter/material.dart';
import 'package:trips/core/localization/app_localization.dart';
import '../../../../core/utils/image_helper.dart';
import '../../../common_widgets/dialog/action_alert_dialog.dart';
import '../../../style/app_images.dart';

  successReservationDialog({required BuildContext context,required VoidCallback? onConfirm,}) {
    return ActionAlertDialog.show(
              context,
              onWillPopScope: onConfirm,
              hideDialog:()=>Future.delayed(Duration(seconds: 1,milliseconds: 500),() =>  onConfirm),
              imageUrl:  const ImageWidget(url: AppImages.successDialogImage,width: 88,height: 88,fit: BoxFit.fill,).buildAssetSvgImage(),
              dialogTitle: 'success_reservation_title'.translate(),
              message: 'success_reservation_msg'.translate(),
              confirmText: "got_it".translate(),
              onConfirm: onConfirm,
    );
  }