import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/global.dart';
import '../../data/data_resource/remote_resource/repo/rate_repo.dart';
import '../../presentation/common_widgets/dialog/error_dialog.dart';
import '../../presentation/common_widgets/dialog/loading_dialog.dart';
import '../../presentation/screens/evaluation_dialogs/evaluation_dialog2.dart';
import '../../presentation/screens/evaluation_dialogs/thanks_dialog.dart';
import '../../presentation/style/app_images.dart';
import 'evaluation_states.dart';


class EvaluationCubit extends Cubit<EvaluationStates> {
  EvaluationCubit({required this.rateRepo}) : super(EvaluationInitialState());
  int? index;
  RateRepo rateRepo;
  bool showSuccess=false;
List<String> evalEmojiList=[
  AppImages.emoji1Icon,
  AppImages.emoji2Icon,
  AppImages.emoji3Icon,
  AppImages.emoji4Icon,
  AppImages.loveEmojiIcon,
];

  void changeIndex(int emojiIndex){
    index=emojiIndex;
    emit(ChangeIndexState());
  }




}