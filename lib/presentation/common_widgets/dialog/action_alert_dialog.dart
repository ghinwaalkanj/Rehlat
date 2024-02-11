import 'package:flutter/material.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/presentation/style/app_colors.dart';
import '../../../data/data_resource/local_resource/data_store.dart';
import '../../style/app_font_size.dart';
import '../../style/app_text_style.dart';
import '../../style/app_text_style_2.dart';

class ActionAlertDialog extends StatelessWidget {
  final String? message;
  final String dialogTitle;
  final Widget? imageWidget;
  final String? cancelText;
  final String? confirmText;
  final Widget? secondaryWidget;
  final VoidCallback? onCancel;
  final Function? onWillPopScope;
  final VoidCallback? onConfirm;
  final Function? hideDialog;
  final bool? isExistOr;
  final double? padding;
  final Color? color;
  final Color? confirmFillColor;
  final TextStyle? titleStyle;
  final TextStyle? buttonStyle;



  static Future<void> show(
      BuildContext context, {
         String? message,
        required String dialogTitle,
         Widget? imageUrl,
        String? cancelText,
        TextStyle? titleStyle,
        String? confirmText,
        TextStyle? buttonStyle,
        VoidCallback? onCancel,
        final VoidCallback? onWillPopScope,
        VoidCallback? onConfirm,
        Alignment? alignment,
        Color? color,
        Color? confirmFillColor,
        Function? hideDialog,
        final Widget? secondaryWidget,
        bool isExistOr=false,
        double? padding,
      }) {
    return showDialog(
      context: context,
      builder: (context) {
        if(hideDialog != null) hideDialog();
        return   WillPopScope(
          onWillPop: () async {
           if(onWillPopScope!=null)onWillPopScope();
            return true;
          },
          child: Dialog(
            alignment: alignment,
            backgroundColor:color?? Colors.white,
            insetPadding:  EdgeInsets.all(padding??20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: ActionAlertDialog(
              message: message,
              onCancel: onCancel,
              onConfirm: onConfirm,
              cancelText: cancelText,
              confirmText: confirmText,
              dialogTitle: dialogTitle,
              imageWidget: imageUrl,
              isExistOr: isExistOr,
              titleStyle: titleStyle,
              buttonStyle: buttonStyle,
              secondaryWidget: secondaryWidget,
              color: color,
              confirmFillColor: confirmFillColor,
            ),
          ),
        );
      },
    );
  }

  const ActionAlertDialog({
    Key? key,
    required this.message,
    required this.dialogTitle,
    this.onWillPopScope,
     this.onCancel,
    this.titleStyle,
    this.buttonStyle,
    required this.onConfirm,
    required this.cancelText,
    required this.confirmText,
     this.imageWidget,
    this.secondaryWidget,
    this.hideDialog,
    this.isExistOr,
    this.padding,
    this.color,
    this.confirmFillColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: 28.0,horizontal:padding?? 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if(imageWidget != null) imageWidget!,
             const SizedBox(height: 22),
            Text(
              dialogTitle,
              textAlign: TextAlign.center,
              style:titleStyle?? AppTextStyle.lightBlackW700_21.copyWith(fontSize: 16),
            ),
            if(message != null)
            Padding(
              padding: const EdgeInsets.only(top: 22.0),
              child: Text(
                message!,
                textAlign: TextAlign.center,
                style: AppTextStyle.lightGrey1W400_14,
              ),
            ),
            const SizedBox(height: 22),
            if(secondaryWidget != null)secondaryWidget!,
            if(isExistOr!=false)
              Padding(
                padding: const EdgeInsets.only(top: 14.0,bottom: 25),
                child: Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.lightXGrey)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Text('or'.translate(),  style: AppTextStyle2.getSemiBoldStyle(
                    fontSize: AppFontSize.size_16,
                    color:  Colors.black,
                    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                  ),
                  const Expanded(child: Divider(color: AppColors.lightX2Grey)),
                ],
            ),
              ),
            if(secondaryWidget == null) const SizedBox(height: 8),
            Row(
              children: [
                if(cancelText != null)
                  Expanded(
                    child:InkWell(
                    onTap: onCancel,
                    child: Text(
                      cancelText!,
                      style:buttonStyle??    AppTextStyle2.getBoldStyle(
                      fontSize: AppFontSize.size_14,
                      color:  Colors.black,
                      fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                      textAlign: TextAlign.center,
                    ),
                  ),),
                const SizedBox(width: 2),
                if(confirmText != null)
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: const MaterialStatePropertyAll(0),
                          backgroundColor: MaterialStatePropertyAll(confirmFillColor?? Colors.white,),
                          shape:MaterialStatePropertyAll(RoundedRectangleBorder(
                            side: BorderSide(
                                color: AppColors.lightXBlack.withOpacity(0.1)),
                              borderRadius:const BorderRadius.all(Radius.circular(28))
                          )),
                        ),
                        onPressed: onConfirm,
                        child: Text(
                          confirmText!,
                          style:buttonStyle??   AppTextStyle2.getBoldStyle(
                      fontSize: AppFontSize.size_16,
                      color:  Colors.black,
                      fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
