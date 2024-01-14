import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/core/localization/app_localization.dart';
import 'package:trips/data/data_resource/local_resource/data_store.dart';

import '../../core/utils/utils_functions.dart';
import '../../data/data_resource/remote_resource/repo/trips_repo.dart';
import '../../data/model/booking_trip_model.dart';
import 'booking_states.dart';

  class BookingCubit extends Cubit<BookingStates> {
    TripsRepo tripsRepo;
  BookingCubit({required this.tripsRepo}) : super(BookingInitialState());
  int index=0;
  bool isError=false;
  bool isLoading=false;
  String code='';
  List confirmedList=[];
  List tempList=[];
    List<BookingTripModel> historyList=[];
  String? blockedDuration;
  Headers? verifyHeaders;


  void changeBookingPage(int pageIndex){
    index=pageIndex;
    emit(ChangeIndexState());
  }

 getBookingList() async {
    if(DataStore.instance.token!=null){
      isLoading=true;
      isError=false;
       emit(LoadingBookingState());
      (await tripsRepo.getBooingList()).fold((l){
        isLoading=false;
        isError=true;
        confirmedList=[];
        emit(ErrorBookingState(error: l));
      }, (r) {
                isLoading=false;
                confirmedList=r.confirmed??[];
                tempList=r.temp??[];
                historyList=r.history??[];
            emit(SuccessBookingState());
          });
        }
  else{clearList();}
  }

    confirmReservation(BookingTripModel bookingTripModel,String code) async {
       emit(LoadingConfirmReservationState());
      (await tripsRepo.confirmReservation(bookingId: bookingTripModel.id!,code: code,getHeaders: (p0) =>verifyHeaders=p0,)).fold((l) => emit(ErrorConfirmReservationState(error: l)),
              (r) {
            emit(SuccessConfirmReservationState());
            tempList.remove(bookingTripModel);
            confirmedList.insert(0,bookingTripModel);
          });
       if(verifyHeaders?['retry-after']?.first!=null){
         blockedDuration=verifyHeaders!['retry-after']!.first;
         String time=FunctionUtils().formattedTime(timeInSecond: int.parse(blockedDuration!));
         emit(BlockReservationState(error:'${'block_msg'.translate()} \n $time ${'minute'.translate()}'));
       }
         }

  verifyCodeBooking({required BookingTripModel bookingTripModel,required bool isBookingScreen}) async {
       emit(LoadingRequestConfirmReservationState());
      (await tripsRepo.requestConfirmReservation(bookingId: bookingTripModel.id!)).fold((l) => emit(ErrorRequestConfirmReservationState(error: l)),
              (r) {
            emit(SuccessRequestConfirmReservationState(bookingTripModel: bookingTripModel,isBookingScreen: isBookingScreen));
          });
  }

  requestCancelTempBooking({required BookingTripModel bookingTripModel,required bool isBookingScreen}) async {
       emit(LoadingRequestCancelTempState());
      (await tripsRepo.requestCancelTempBooking(bookingId: bookingTripModel.id!,)).fold((l) => emit(ErrorRequestCancelTempState(error: l)),
              (r) {
            emit(SuccessRequestCancelTempState(bookingTripModel:bookingTripModel ,isBookingScreen:isBookingScreen ));
          });
  }

  cancelTempBooking({required BookingTripModel bookingTripModel}) async {
       emit(LoadingCancelTempState());
      (await tripsRepo.cancelTempBooking(bookingId: bookingTripModel.id!,code: code)).fold((l) => emit(ErrorCancelTempState(error: l)),
              (r) {
                tempList.remove(bookingTripModel);
            emit(SuccessCancelTempState());
          });
  }

  clearList(){
     confirmedList=[];
     tempList=[];
     historyList=[];
}

    closeSlidableCard(){
    emit(CloseSlidableState());
      }


  }