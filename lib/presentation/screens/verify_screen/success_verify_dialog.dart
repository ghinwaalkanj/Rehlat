import 'package:flutter/material.dart';
import 'package:trips/core/localization/app_localization.dart';

import '../../../core/utils/image_helper.dart';
import '../../common_widgets/dialog/action_alert_dialog.dart';
import '../../style/app_images.dart';


successVerifyDialog({required BuildContext context,required VoidCallback? onConfirm,bool isVerifyOtp=false}) {
  return ActionAlertDialog.show(
              context,
              hideDialog:isVerifyOtp?()=> Future.delayed(const Duration(seconds: 1,milliseconds: 500), onConfirm):null,
              imageUrl: const ImageWidget(url: AppImages.successDialogImage,width: 88,height: 88,fit: BoxFit.fill,).buildAssetSvgImage(),
              dialogTitle: 'success_verify_title'.translate(),
              message: 'success_verify_msg'.translate(),
              confirmText: "got_it".translate(),
              onConfirm: onConfirm
    );
  }
