import 'package:flutter/material.dart';
import 'app_font_size.dart';
import 'font_weight.dart';

class AppTextStyle2 {

  static TextStyle getTextStyle(double fontSize, Color color, FontWeight fontWeight,String fontFamily ){
    return TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        fontFamily: fontFamily
    );
  }

  static TextStyle getRegularStyle({double fontSize = AppFontSize.size_12,FontWeight? fontWeight, required Color color,required String fontFamily}){
    return getTextStyle(fontSize, color,fontWeight?? AppFontWeight.regular,fontFamily);
  }

  static TextStyle getMediumStyle(
      {double fontSize = AppFontSize.size_12, required Color color,FontWeight? fontWeight,required String fontFamily}){
    return getTextStyle(fontSize, color,fontWeight?? AppFontWeight.medium,fontFamily);
  }

  static TextStyle getLightStyle(
      {double fontSize = AppFontSize.size_12, required Color color,FontWeight? fontWeight,required String fontFamily}){
    return getTextStyle(fontSize, color,fontWeight?? AppFontWeight.light,fontFamily);
  }

  static TextStyle getBoldStyle(
      {double fontSize = AppFontSize.size_12, required Color color,FontWeight? fontWeight,required String fontFamily}){
    return getTextStyle(fontSize, color,fontWeight?? AppFontWeight.bold,fontFamily);
  }

  static TextStyle getSemiBoldStyle(
      {double fontSize = AppFontSize.size_12, required Color color,FontWeight? fontWeight,required String fontFamily}){
    return getTextStyle(fontSize, color,fontWeight?? AppFontWeight.semiBold,fontFamily);
  }
}