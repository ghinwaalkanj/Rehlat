import 'package:flutter/material.dart';
import 'package:trips/core/localization/app_localization.dart';
import '../../common_widgets/dialog/action_alert_dialog.dart';
import '../../style/app_images.dart';


waitingDialog({required BuildContext context}) {
    return ActionAlertDialog.show(
              context,
              imageUrl:Image.asset(AppImages.loveEmojiIcon,width:42 ,height:52, ),
              dialogTitle: 'waiting_feature'.translate(),
              message: 'waiting_dialog_msg'.translate(),
              confirmText: 'ok'.translate(),
              cancelText: 'cancel'.translate(),
              onConfirm: () {},
              onCancel: () {},
    );
  }
