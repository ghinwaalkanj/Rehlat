import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/utils/app_router.dart';
import 'package:trips/cubit/fatora/fatora_cubit.dart';
import 'package:trips/presentation/common_widgets/custom_error_screen.dart';
import 'package:trips/presentation/style/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../cubit/fatora/fatora_state.dart';
import '../../root_screens/root_screen.dart';


class FatoraWebView extends StatefulWidget {
  final int reservationId;
  const FatoraWebView({Key? key, required this.reservationId}) : super(key: key);

  @override
  State<FatoraWebView> createState() => _FatoraWebViewState();
}

class _FatoraWebViewState extends State<FatoraWebView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();}

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FatoraCubit,FatoraStates>(
      bloc: context.read<FatoraCubit>()..getFatoraUrl(reservationId: widget.reservationId),
       listener: (context, state) {
         if(state is IsGoogleState && context.read<FatoraCubit>().isGoogle){
           AppRouter.navigateReplacementTo(context: context, destination: const RootScreen());
         }
       },
       builder: (context, state) =>  Scaffold(
               backgroundColor: Colors.white,
             body: (state is LoadingFatoraState )
             ? const Center(child: CircularProgressIndicator(color: AppColors.darkGreen,))
             : (state is ErrorFatoraState)
             ?  CustomErrorScreen(onTap:() => context.read<FatoraCubit>().getFatoraUrl(reservationId: widget.reservationId))
             : ( context.read<FatoraCubit>().webViewController != null && context.read<FatoraCubit>().completeDownloading==true)
             ?  WebViewWidget(controller: context.read<FatoraCubit>().webViewController!)
             :  context.read<FatoraCubit>().webViewController == null
             ? CustomErrorScreen(onTap:() => context.read<FatoraCubit>().getFatoraUrl(reservationId:widget.reservationId))
                 :const Center(child: CircularProgressIndicator(color: AppColors.darkGreen,))
    ));
  }
}