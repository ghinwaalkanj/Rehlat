import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trips/data/data_resource/local_resource/data_store.dart';
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
  List historyList=[];

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
      },
              (r) {
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
      (await tripsRepo.confirmReservation(bookingId: bookingTripModel.id!,code: code)).fold((l) => emit(ErrorConfirmReservationState(error: l)),
              (r) {
            emit(SuccessConfirmReservationState());
            tempList.remove(bookingTripModel);
            confirmedList.insert(0,bookingTripModel);
          });
         }

  verifyCodeBooking({required BookingTripModel bookingTripModel,required bool isBookingScreen}) async {
       emit(LoadingRequestConfirmReservationState());
      (await tripsRepo.requestConfirmReservation(bookingId: bookingTripModel.id!)).fold((l) => emit(ErrorRequestConfirmReservationState(error: l)),
              (r) {
            emit(SuccessRequestConfirmReservationState(bookingTripModel: bookingTripModel,isBookingScreen: isBookingScreen));
          });
  }

  clearList(){
     confirmedList=[];
     tempList=[];
     historyList=[];
}}