

import 'package:flutter/material.dart';
import 'package:trips/data/data_resource/local_resource/data_store.dart';

import '../../../style/app_font_size.dart';
import '../../../style/app_text_style_2.dart';

class SubClaimCard extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String content;
  const SubClaimCard({Key? key, required this.color, required this.textColor, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(content,
              style: AppTextStyle2.getRegularStyle(
                fontSize: AppFontSize.size_16,
                color: textColor,
                fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
            ),
          ),
      ),
    );
  }
}
