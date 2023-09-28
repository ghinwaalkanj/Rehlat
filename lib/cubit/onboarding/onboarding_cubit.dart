import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_states.dart';


class OnBoardingCubit extends Cubit<OnBoardingStates> {
  OnBoardingCubit() : super(OnBoardingInitialState());
  PageController pageController=PageController();
  int index=0;

  void changeIndex(int pageIndex){
    index=pageIndex;
    emit(ChangeIndexState());
  }
}