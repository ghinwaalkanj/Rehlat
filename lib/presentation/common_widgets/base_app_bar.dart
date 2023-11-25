import 'package:flutter/material.dart';

import '../../data/data_resource/local_resource/data_store.dart';
import '../style/app_colors.dart';
import '../style/app_font_size.dart';
import '../style/app_text_style_2.dart';

class BaseAppBar extends StatelessWidget {
  final Widget child;
  final Widget? childAppBar;
  final Widget? tripInfo;
  final Widget? rightIcon;
  final String titleScreen;
  final VoidCallback? onTap;
  final bool notExistArrow;

  const BaseAppBar({Key? key, required this.child,this.notExistArrow=false, required this.titleScreen, this.childAppBar, this.rightIcon, this.tripInfo, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
            color:AppColors.darkGreen,
            child: Padding(
              padding:  EdgeInsets.only(top:tripInfo==null?35:12),
              child: Column(
                children: [
                  tripInfo??  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(!notExistArrow)
                        InkWell(
                            onTap:onTap??()=>Navigator.pop(context),
                            child: const Icon(Icons.arrow_back_outlined,color: Colors.white)),
                        const SizedBox(width: 16,),
                        Text(titleScreen,style:
                          AppTextStyle2.getSemiBoldStyle(
                              fontSize: AppFontSize.size_16,
                              color: Colors.white,
                              fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
                        const Spacer(),
                        if(rightIcon!=null)rightIcon!,
                      ],
                    ),
                  ),
                  if(childAppBar!=null)const SizedBox(height:12,),
                  if(childAppBar!=null)Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: childAppBar!,
                  ),
                ],
              ),
            ),
          ),
                Padding(
              padding:  EdgeInsets.only(top: (childAppBar!=null)? 230:85.0),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(33))
                ),
                child: child,
              ),
            ),
   ] ),
      ),
    );
  }
}
