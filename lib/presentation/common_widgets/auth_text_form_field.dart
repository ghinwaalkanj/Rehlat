import 'package:flutter/material.dart';
import 'package:trips/presentation/style/app_text_style.dart';

import '../style/app_colors.dart';

class AuthTextFormField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final bool isObscure;
  final bool? readOnly;
  final Color? fillColor;
  final Color? borderColor;
  final Color? enableColor;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final TextInputType? keyboardType;
  final double? height;
  final double? width;
  final double? borderWidth;
  final double? borderRadius;
  final int? minLines;
  final VoidCallback? onComplete;
  final Function(String value)? onChanged;

  const AuthTextFormField(
      {Key? key,
        this.borderRadius,
        this.borderWidth,
      this.labelText,
        this.borderColor,
        this.minLines,
      this.errorText,
      this.isObscure = false,
       this.controller,
        this.enableColor,
      this.prefixIcon,
      this.suffixIcon,
      this.fillColor,
      this.hintText,
        this.labelStyle,
      this.hintStyle,
      this.textStyle,
      this.keyboardType,
      this.height,
        this.readOnly,
       this.onComplete,
        this.onChanged,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        minLines: minLines??1,
        maxLines: isObscure?1:14,
       scrollPadding: const EdgeInsets.only(bottom:300),
       onChanged:(value) {
         if(onChanged!=null)onChanged!(value);},
        onEditingComplete:onComplete,
        readOnly: readOnly??false,
        textInputAction: TextInputAction.next,
        keyboardType: keyboardType,
        style: textStyle,
        obscureText: isObscure,
        controller: controller,
        cursorColor: Colors.deepOrange,
        decoration: InputDecoration(
          contentPadding:  EdgeInsets.symmetric(horizontal: 34.0, vertical:(minLines!=null)?12:0),
          hintStyle: hintStyle,
          hintText: hintText,
          prefixIcon: prefixIcon,
          filled: true,
          enabled: true,
          fillColor: fillColor ?? Colors.transparent,
          border: InputBorder.none,
            focusedErrorBorder:  OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius??16.0)),
                borderSide:  BorderSide(
                  width: borderWidth??1,
                  color: borderColor??AppColors.darkGreen
                )),
            disabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                borderSide: BorderSide(
                  width: borderWidth??1,
                  color: borderColor??AppColors.darkGreen
                )),
            enabledBorder: OutlineInputBorder(
                borderRadius:  BorderRadius.all(Radius.circular(borderRadius??16.0)),
                borderSide: BorderSide(
                  width: borderWidth??1,
                  color: borderColor??AppColors.darkGreen
                )),
            focusedBorder:  OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius??16.0)),
                borderSide:  BorderSide(
                  width: borderWidth??1,
                  color:enableColor??borderColor??AppColors.darkGreen
                )),
            errorBorder:  OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius??16.0)),
                borderSide: const BorderSide(color: Colors.red)),
          labelText: labelText,
          labelStyle: labelStyle??AppTextStyle.darkXGrayW500_16,
          errorText: errorText,
          suffixIcon: suffixIcon,
          errorStyle:  AppTextStyle.redBold_14,
        ),
      ),
    );
  }
}
