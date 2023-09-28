import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/cubit/main/main_cubit.dart';
import '../../../../cubit/profile/profile_cubit.dart';
import '../../../../cubit/root/root_cubit.dart';
import '../../../../data/data_resource/local_resource/data_store.dart';
import '../../../style/app_font_size.dart';
import '../../../style/app_text_style.dart';
import '../../../style/app_text_style_2.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("english".translate(),
                          style: AppTextStyle2.getSemiBoldStyle(
                  fontSize: AppFontSize.size_16,
                  color:  Colors.black,
                  fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                  ),
                  onTap: () {
                   context.read<MainCubit>().changeLanguage(lang: 'en', whenDone:(){
                     context.read<ProfileCubit>().getChangeUpdate() ;
                     context.read<RootPageCubit>().updateLanguage() ;
                   }
                   );
                   Navigator.pop(context);
                  }),
              GestureDetector(
                  onTap: () {
                    context.read<MainCubit>().changeLanguage(lang: 'ar', whenDone: () {
                      context.read<ProfileCubit>().getChangeUpdate();
                      context.read<RootPageCubit>().updateLanguage() ;
                    }
                    );
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("arabic".translate(),
                             style: AppTextStyle2.getSemiBoldStyle(
  fontSize: AppFontSize.size_16,
  color:  Colors.black,
  fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                  )),
            ],
          ),
        );
  }
}
