import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/service_locator_di.dart';
import 'package:trips/cubit/privacy_cubit/privacy_cubit.dart';
import 'package:trips/cubit/privacy_cubit/privacy_states.dart';
import 'package:trips/presentation/screens/profile_screens/widgets/html_text.dart';
import 'package:trips/presentation/style/app_text_style_2.dart';

import '../../../../data/data_resource/local_resource/data_store.dart';
import '../../../common_widgets/custom_error_screen.dart';
import '../../../style/app_colors.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (context) => getIt<PrivacyCubit>()..getTerms(),
      child: BlocBuilder<PrivacyCubit,PrivacyStates>(
        builder: (context, state) => SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
              body:  SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30,),
                    Row(
                      children: [
                        InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.arrow_back,color: Colors.black)),
                        SizedBox(width: 90.w,),
                        Center(child: Text('terms_text'.translate(),
                          style: AppTextStyle2.getBoldStyle(
                            color: Colors.black, fontSize:17,
                          fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',),),
                        ),
                      ],
                    ),
                    (state is LoadingGetTermsState)
                    ? const Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Center(child: CircularProgressIndicator(color: AppColors.darkGreen,)),
                    )
                    : (state is ErrorGetTermsState)
                    ? CustomErrorScreen(onTap: () => context.read<PrivacyCubit>().getTerms(),)
                    : HtmlContent(
                      html: context.read<PrivacyCubit>().termsContent,
                      color:Colors.black ,
                      size:double.infinity ,),
                     ],
                ),
              ),
              )
        ),
      ),
    );
  }
}
