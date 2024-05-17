import 'package:flutter/material.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/data/data_resource/local_resource/data_store.dart';
import 'package:trips/presentation/common_widgets/auth_text_form_field.dart';
import 'package:trips/presentation/common_widgets/custom_button.dart';
import 'package:trips/presentation/style/app_colors.dart';
import 'package:trips/presentation/style/app_font_size.dart';
import 'package:trips/presentation/style/app_text_style_2.dart';

import '../../../common_widgets/sliver_app_bar.dart';
import '../../booking_trip/widgets/time_widget.dart';

class BaseCashScreen extends StatelessWidget {
  final String titleScreen;
  final TextEditingController phoneController;
  final Function(String value) onChanged;
  final VoidCallback onConfirm;
  const BaseCashScreen({Key? key, required this.titleScreen, required this.phoneController, required this.onChanged, required this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SliverAppBarWidget(
            titleScreen: '',
            padding:12,
            scrollController: ScrollController(),
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TimeRowWidget(),
                const SizedBox(height: 25,),
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: 25.0,start: 26),
                  child: Text(titleScreen,
                      style: AppTextStyle2.getSemiBoldStyle(fontSize: AppFontSize.size_16, color: Colors.black,
                        fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('number'.translate(),
                            style: AppTextStyle2.getSemiBoldStyle(fontSize: AppFontSize.size_16, color: Colors.black,
                              fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
                        const SizedBox(height: 25,),
                        AuthTextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          hintText: '09xxxxxxxx',
                          labelStyle: AppTextStyle2.getBoldStyle(
                            fontSize: AppFontSize.size_14,
                            color: AppColors.lightXGreen,
                            fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                          borderRadius: 16,
                          fillColor: Colors.transparent,
                          borderColor: AppColors.lightXGreen,
                          onChanged: (value)=>onChanged(value),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 60.0,left: 26,right: 26),
                  child: CustomButton(
                      h: 55,
                      radius: 32,
                      color: AppColors.darkGreen,
                      text: 'pay2'.translate(),
                      textStyle: AppTextStyle2.getSemiBoldStyle(
                        fontSize: AppFontSize.size_14,
                        color: Colors.white,
                        fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),
                      onPressed:onConfirm
                  ),
                ),
              ],)
        ));
  }
}
