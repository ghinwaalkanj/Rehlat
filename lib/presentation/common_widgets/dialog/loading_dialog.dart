import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trips/core/localization/app_localization.dart';

import '../../style/app_colors.dart';
import '../../style/app_images.dart';
import 'dialog_transition_builder.dart';

class LoadingDialog {
  static final LoadingDialog _loadingDialog = LoadingDialog._internal();

  factory LoadingDialog() {
    return _loadingDialog;
  }

  LoadingDialog._internal();

  bool _isShown = false;

  void closeDialog(BuildContext context) {
    if (_isShown) {
      Navigator.of(context).pop();
      _isShown = false;
    }
  }

  void openDialog(BuildContext context) {
    _isShown = true;
    dialogTransitionBuilder(context, const _LoadingDialogBody())
        .whenComplete(() => _isShown = false);
  }
}

class _LoadingDialogBody extends StatelessWidget {
  const _LoadingDialogBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          height: 120,
          width: 120,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(28)),
            color: AppColors.darkGreen,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitCircle(
                itemBuilder: (_, int index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1.0),
                      child: Image.asset(
                        AppImages.whiteLogoImage,
                        width: 40,
                        height: 40,
                        fit: BoxFit.fill,
                      ));
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 11.0),
                child: Text('loading'.translate(),
                  style: const TextStyle(
                    // fontFamily: appFontFamily,
                    fontSize: 16,
                    decoration: TextDecoration.none, ////set decoration to .none
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                    // fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
