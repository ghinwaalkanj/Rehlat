import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/utils/global.dart';
import '../../data/data_resource/local_resource/data_store.dart';
import '../../data/data_resource/remote_resource/repo/rate_repo.dart';
import '../../presentation/screens/evaluation_dialogs/evaluation_dialog2.dart';
import '../evaluation/evaluation_cubit.dart';
import 'main_states.dart';
import 'package:flutter/material.dart';


    class MainCubit extends Cubit<MainStates> {
  MainCubit({required this.rateRepo}) : super(MainInitialState());
  int index=0;
  RateRepo rateRepo;

  String currency=DataStore.instance.lang=='en'?"SYP":"ل.س";

  changeLanguage({required String lang,required Function() whenDone}) async {
    await DataStore.instance.setLang(lang);
    currency=DataStore.instance.lang=='en'?"SYP":"ل.س";
    emit(ChangeLangState());
    Future.delayed(const Duration(milliseconds: 100),whenDone);
    //if navigatorKey.currentContext != null)navigatorKey.currentContext!.read<HomePageBloc>().getHomePageData();
  }
}