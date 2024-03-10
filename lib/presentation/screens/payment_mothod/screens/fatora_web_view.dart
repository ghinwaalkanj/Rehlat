import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/cubit/fatora/fatora_cubit.dart';
import 'package:trips/presentation/common_widgets/custom_error_screen.dart';
import 'package:trips/presentation/style/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../cubit/fatora/fatora_state.dart';


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
    return BlocBuilder<FatoraCubit,FatoraStates>(
      bloc: context.read<FatoraCubit>()..getFatoraUrl(reservationId: widget.reservationId),
       builder: (context, state) =>  Scaffold(
           backgroundColor: Colors.white,
         body: (state is LoadingFatoraState)
             ? const Center(child: CircularProgressIndicator(color: AppColors.darkGreen,))
             : (state is ErrorFatoraState)
             ?  CustomErrorScreen(onTap:() => context.read<FatoraCubit>().getFatoraUrl(reservationId: widget.reservationId))
             : ( context.read<FatoraCubit>().webViewController != null)
             ?  WebViewWidget(controller: context.read<FatoraCubit>().webViewController!)
             :  CustomErrorScreen(onTap:() => context.read<FatoraCubit>().getFatoraUrl(reservationId:widget.reservationId))
    ));
  }
}