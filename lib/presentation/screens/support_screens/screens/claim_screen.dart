import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/data/data_resource/local_resource/data_store.dart';
import 'package:trips/presentation/common_widgets/custom_error_screen.dart';
import 'package:trips/presentation/common_widgets/must_login.dart';
import 'package:trips/presentation/screens/support_screens/screens/create_claim_screen.dart';
import 'package:trips/presentation/screens/support_screens/widgets/logo.dart';
import 'package:trips/presentation/style/app_colors.dart';
import 'package:trips/presentation/style/app_images.dart';
import 'package:trips/presentation/style/app_text_style_2.dart';

import '../../../../cubit/support/support_cubit.dart';
import '../../../../cubit/support/support_states.dart';
import '../../../style/app_font_size.dart';
import '../widgets/cliam_card.dart';

class ClaimScreen extends StatelessWidget {
  const ClaimScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SupportCubit,SupportStates>(
      bloc: context.read<SupportCubit>()..getClaims(),
      listener: (context, state) {},
      builder: (context, state) =>  Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton:(DataStore.instance.token!=null&&context.read<SupportCubit>().bookingIDList.isNotEmpty)?
        FloatingActionButton(
          onPressed: () {
            AppRouter.navigateTo(context: context, destination:const CreateClaimScreen());
          },
        backgroundColor:AppColors.primary,
          child: const Icon(Icons.add),
        ):null,
        body: Column(
              children: [
                const LogoWidget(),
                (DataStore.instance.token==null)
                    ? Padding(
                      padding:  EdgeInsets.only(top: 0.1.sh),
                      child: const MustLoginScreen(),
                    )
                    :  (state is GetClaimErrorState)
                    ?  CustomErrorScreen(onTap:() => context.read<SupportCubit>().getClaims(),)
                    : (state is ErrorBookingClaimState)
                    ?  CustomErrorScreen(onTap:() => context.read<SupportCubit>().getBookingClaimList(),)
                    : (state is GetClaimLoadingState)
                    ? const Expanded(child: Center(child: CircularProgressIndicator(color: AppColors.darkGreen,)))
                    : context.read<SupportCubit>().claimsList.isEmpty
                    ?  Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppImages.noTripImage),
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Text(context.read<SupportCubit>().bookingIDList.isNotEmpty?'no_claims'.translate():'do_booking'.translate(), style: AppTextStyle2.getBoldStyle(
                            fontSize: AppFontSize.size_16,
                            color:  Colors.black,
                            fontFamily: DataStore.instance.lang=='ar'?'Tajawal':'Poppins',)),
                        ),
                      ],)
                    :  Expanded(
                         child: ListView.builder(
                             shrinkWrap: true,
                             itemBuilder: (context, index) =>  ClaimCard(claimModel: context.read<SupportCubit>().claimsList[index]),
                             itemCount: context.read<SupportCubit>().claimsList.length),
                 )
              ],
            ),
          ),
        );
      }
    }