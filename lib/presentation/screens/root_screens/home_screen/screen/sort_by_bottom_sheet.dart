import 'package:flutter/material.dart';
import 'package:trips/core/localization/app_localization.dart';

import '../../../../../data/data_resource/local_resource/data_store.dart';
import '../../../../style/app_font_size.dart';
import '../../../../style/app_text_style_2.dart';
import '../widgets/radio_sort.dart';

class SortByBottomSheet extends StatelessWidget {
  const SortByBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.49,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.vertical(top:Radius.circular(50)),
      ),
        child: Padding(
          padding: const EdgeInsets.only(left: 34.0,right: 22,top: 30),
          child: Column(
            children: [
              Row(
                children: [
                  Text('sort_by'.translate(),style: AppTextStyle2.getSemiBoldStyle(
                    fontSize: AppFontSize.size_21,
                    color:  Colors.black,
                    fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                  const Spacer(),
                  IconButton(
                      onPressed: ()=>Navigator.pop(context),
                      icon:const Icon(Icons.close_rounded,color: Colors.black)),
                ],
              ),
              const RadioSortByWidget(),
            ],
          ),
        ),
    );
  }
}
