import 'package:flutter/material.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/image_helper.dart';

import '../../../../common_widgets/dialog/action_alert_dialog.dart';
import '../../../../style/app_images.dart';

waitingCardDialog({required BuildContext context}) {
  return ActionAlertDialog.show(
    context,
    padding: 35,
    imageUrl:Padding(
      padding: const EdgeInsets.only(top: 22.0),
      child: const ImageWidget(url: AppImages.waitingFeatureIcon,width:42 ,height:52, ).buildAssetSvgImage(),
    ),
    dialogTitle: 'waiting_feature'.translate(),
    message: 'waiting_content'.translate(),
    confirmText: 'ok'.translate(),
    cancelText: 'cancel'.translate(),
    onConfirm: () {Navigator.pop(context);},
    onCancel: () {Navigator.pop(context);},
  );
}
