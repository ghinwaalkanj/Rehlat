import 'package:flutter/material.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/presentation/common_widgets/dialog/loading_dialog.dart';
import '../../../core/utils/image_helper.dart';
import '../../common_widgets/dialog/action_alert_dialog.dart';
import '../../style/app_images.dart';


thanksDialog({required BuildContext context}) {
  return ActionAlertDialog.show(
              context,
              imageUrl:const ImageWidget(url:AppImages.heartIcon,).buildAssetSvgImage(),
              dialogTitle: 'thanks_dialog'.translate(),
              message: 'thanks_dialog_message'.translate(),
              confirmText: "got_it".translate(),
              onCancel: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
               onConfirm: () {
                 Navigator.pop(context);
                 Navigator.pop(context);
                 Navigator.pop(context);
               },
    );
  }
