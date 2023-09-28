import 'package:flutter/material.dart';
import 'package:trips/core/localization/app_localization.dart';

import 'action_alert_dialog.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
           onTap: () => ActionAlertDialog.show(
             context,
           //  imageUrl: AppImages.errorDialogImage,
           //  cancelText: 'cancel',
             dialogTitle: 'Cancel', message: 'cancel your resarvation and back to home',
             confirmText: "got_it".translate(),onCancel: () {},),
            child: const Text('data')),
      ),
    );
  }
}
