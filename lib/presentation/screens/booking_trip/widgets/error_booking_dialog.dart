import 'package:flutter/material.dart';
import 'package:trips/core/localization/app_localization.dart';

import '../../../../core/utils/image_helper.dart';
import '../../../common_widgets/dialog/action_alert_dialog.dart';
import '../../../style/app_images.dart';

  errorBookingDialog({required BuildContext context}) {
    return ActionAlertDialog.show(
              context,
              imageUrl: const ImageWidget(url:  AppImages.errorDialogImage,width: 88,height: 88,fit: BoxFit.fill,).buildAssetSvgImage(),
              dialogTitle: 'error_booking_title'.translate(),
              message: 'error_booking_msg'.translate(),
              confirmText: "try_again".translate(),
              onConfirm: () {},
    );
  }
