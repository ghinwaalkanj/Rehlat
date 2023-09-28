import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/core/utils/global.dart';
import 'package:trips/data/data_resource/local_resource/data_store.dart';
import '../../core/utils/enums.dart';
import '../../data/data_resource/remote_resource/repo/trips_repo.dart';
import '../../data/model/trip_model.dart';
import '../../domain/models/seat_model.dart';
import '../../presentation/common_widgets/dialog/error_dialog.dart';
import '../../presentation/common_widgets/time_over_dialog.dart';
import 'seats_states.dart';

class SeatsCubit extends Cubit<SeatsStates> {
  TripsRepo tripsRepo;
  List<SeatModel> seatsIds=[];
  int price=0;
  int? selectedTicketPrice;
  String? validError;
  bool isHideDialog=false;
  Timer? timer;
  String x='';
  String? errorStatus;
  Duration? seconds;
  List<SeatModel> availableList=[];
  List<SeatModel> tempList=[];
  List<SeatModel> inUseList=[];
  List<SeatModel> unavailableList=[];
  List<SeatModel> selectedList=[];
  bool isPressedOption=false;
  StateType? stateCycleApp;

  SeatsCubit({required this.tripsRepo}) : super(SeatsInitialState());


  Future<void> selectSeats(SeatModel seatModel) async {
    (await tripsRepo.selectSeats([seatModel.id!])).fold((l) {
      seatsIds.removeWhere((element) => element.id==seatModel.id!);
      seatModel.selectedByMe=!(seatModel.selectedByMe??false);
      emit(ErrorSelectSeatsState(error: l));
      ErrorDialog.openDialog(navigatorKey.currentContext!, '$l , ${'try_another'.translate()}');
    },
    (r) {
      addItemToList(seatModel);
    emit(SuccessSelectSeatsState());
    });
  }

  Future<void> unSelectSeats(List<SeatModel> seatModel) async {
    List<int> apiList=[];
    seatModel.forEach((element) {
      apiList.add(element.id!);
    });

    if(seatModel.isNotEmpty){
    (await tripsRepo.unSelectSeats(apiList)).fold((l) {
      seatsIds.addAll(seatModel);
      seatModel[0].selectedByMe=!(seatModel[0].selectedByMe??false);
      emit(ErrorSelectSeatsState(error: l));
      ErrorDialog.openDialog(navigatorKey.currentContext!,'try_another'.translate());
    },
    (r) {
      addItemToList(seatModel[0]);
    emit(SuccessSelectSeatsState());
    });
  }}



  selectSeatEvent(SeatModel seatModel,String passengers){
    errorStatus=null;
    if(seatModel.isSelected==true){
      errorStatus='inUse_status_error'.translate();
      emit(StatusValidateState(errorStatus));
    }
    else if(seatModel.status=='temporary'){
      errorStatus='temp_status_error'.translate();
      emit(StatusValidateState(errorStatus));
    }
    else if(seatModel.status=='unavailable'){
      errorStatus='unavailable_status_error'.translate();
      emit(StatusValidateState(errorStatus));
    }
    else if (seatsIds.contains(seatModel)){
      seatModel.selectedByMe = false;
        emit(LoadingSelectSeatsState());
        if (seatsIds.contains(seatModel)) seatsIds.remove(seatModel);
        getPrice(selectedTicketPrice ?? 1);
        availableList.add(seatModel);
        unSelectSeats([seatModel]);
    }
    else{
      if(seatsIds.length<(int.tryParse(passengers)??1)) {
        seatModel.selectedByMe=true;
        emit(LoadingSelectSeatsState());
        if (!seatsIds.contains(seatModel)) seatsIds.add(seatModel);
        getPrice(selectedTicketPrice ?? 1);
        selectSeats(seatModel);
      }
    else {
      emit(ValidateSeatsLengthState());
    }
    }
  }

  getPrice(int ticketPrice){
    selectedTicketPrice=ticketPrice;
    price=ticketPrice*(seatsIds.length);
  }



  startTime(bool isTimeStop){
      DataStore.instance.setStartTime(DateTime.now());
      if(stateCycleApp!= StateType.inActive) {
        timer = Timer.periodic(const Duration(seconds: 1), (timer1) =>
        {
          if(x != ('00:00')){
            seconds = seconds! - const Duration(seconds: 1),
            x = seconds.toString().substring(0, 7),
            x = x.substring(2),
            // print(x),
            emit(TimerState()),}
          else
            {
              timer?.cancel(),
              emit(EndTimerState()),
              isPressedOption = false,
              isHideDialog=false,
              (navigatorKey.currentContext != null && (isTimeStop == true))
                  ? timeOverDialog(context: navigatorKey.currentContext!,
                  isPressedOption: isPressedOption,isHideDialog:isHideDialog )
                  : null,
            }
        });
      }
 }

 timerAfterResume({required int repeatTime,required Duration? time,required Duration? extraTime}){
    DateTime? start=DataStore.instance.startTime;
    DateTime? resume=DataStore.instance.resumeTime;
    print('start');
    print(start);
    print('resume');
    print(resume);
    print('diff');
    print(resume!.difference(start!)<Duration(minutes: 5));
    if(resume.difference(start)<Duration(minutes: 5)&&repeatTime!=1 ){
      Duration? newTimer = resume.difference(start);
      print('newTimer diff');
      print(newTimer);
      print('sec in cache');

     var newTimer2 = time!-newTimer;
      List<String> components2 = newTimer2.toString().split(':');
     seconds=Duration(minutes:int.parse(components2[1]),seconds: int.parse(components2[2].split('.').first));
     print('newTimer2');
     print(newTimer2);
     print('seconds');
     print(seconds);
    }
    if(resume.difference(start)<Duration(minutes: 3)&&repeatTime==1 ){
      Duration? newTimer = resume.difference(start);
      print('newTimer diff');
      print(newTimer);
      print('sec in cache');
     var newTimer2 = extraTime!-newTimer;
      List<String> components2 = newTimer2.toString().split(':');
     seconds=Duration(minutes:int.parse(components2[1]),seconds: int.parse(components2[2].split('.').first));
     print('newTimer2');
     print(newTimer2);
     print('seconds');
     print(seconds);
    }
 }

 cancelTimer(){
   if(timer?.isActive??false)timer!.cancel();
   seconds=null;
   x='';
   timer?.cancel();
   emit(EndTimerState());
 }



  getAllList({required TripModel tripModel}){
    availableList=[];
    tempList=[];
    selectedList=[];
    unavailableList=[];
    inUseList=[];
    tripModel.seats?.forEach((element) {
      if(element.status=="available"&&(element.isSelected==false))availableList.add(element);
      if(element.status=="temp")tempList.add(element);
      if(element.selectedByMe==true)selectedList.add(element);
      if(element.status=="unavailable")unavailableList.add(element);
      if(element.isSelected==true)inUseList.add(element);
      emit(AddListState());
    });
  }

  addItemToList(SeatModel item){
    //if(item.status=="available")availableList.add(item);
    if(item.status=="temp")tempList.add(item);
    if(item.selectedByMe==true){
      availableList.remove(item);
      selectedList.add(item);}
    if(item.status=="unavailable")unavailableList.add(item);
    if(item.isSelected==true){
      availableList.remove(item);
      inUseList.add(item);}
    emit(AddItemListState());
  }
}