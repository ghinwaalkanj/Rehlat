import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trips/core/di.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/presentation/common_widgets/custom_error_screen.dart';
import 'package:trips/presentation/screens/profile_screens/widgets/html_text.dart';
import 'package:trips/presentation/style/app_text_style_2.dart';

import '../../../../cubit/privacy_cubit/privacy_cubit.dart';
import '../../../../cubit/privacy_cubit/privacy_states.dart';
import '../../../../data/data_resource/local_resource/data_store.dart';
import '../../../style/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => getIt<PrivacyCubit>()..getPrivacy(),
         child: BlocBuilder<PrivacyCubit,PrivacyStates>(
         builder: (context, state) => SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body:  SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back,color: Colors.black)),
                      SizedBox(width: 120.w,),
                      Center(child: Text('privacy_policy'.translate(),
                        style: AppTextStyle2.getBoldStyle(
                          color: Colors.black, fontSize:17,
                          fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                      ),
                    ],
                  ),
                  (state is LoadingGetPrivacyState)
                  ? const Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Center(child: CircularProgressIndicator(color: AppColors.darkGreen,)),
                  )
                  : (state is ErrorGetPrivacyState)
                  ? CustomErrorScreen(onTap: () => context.read<PrivacyCubit>().getPrivacy())
                  : HtmlContent(
                    html: context.read<PrivacyCubit>().privacyContent,
                    color:Colors.black ,
                    size:double.infinity ,),
                ],
              ),
            ),
          )
      ),
    ));
  }
}
