import '../../data/model/booking_trip_model.dart';

abstract class BookingStates{}
class ChangeIndexState extends BookingStates{}
class BookingInitialState extends BookingStates{}

class LoadingBookingState extends BookingStates{}
class SuccessBookingState extends BookingStates{}
class ErrorBookingState extends BookingStates{
  final String error;
  ErrorBookingState({required this.error});
}

class LoadingConfirmReservationState extends BookingStates{}
class SuccessConfirmReservationState extends BookingStates{}
class ErrorConfirmReservationState extends BookingStates{
  final String error;
  ErrorConfirmReservationState({required this.error});
}
class BlockReservationState extends BookingStates{
  final String error;
  BlockReservationState({required this.error});
}

class LoadingRequestConfirmReservationState extends BookingStates{}
class SuccessRequestConfirmReservationState extends BookingStates{
  final BookingTripModel  bookingTripModel ;
  final bool  isBookingScreen ;

  SuccessRequestConfirmReservationState({required this.bookingTripModel,required this.isBookingScreen});
}
class ErrorRequestConfirmReservationState extends BookingStates{
  final String error;
  ErrorRequestConfirmReservationState({required this.error});
}