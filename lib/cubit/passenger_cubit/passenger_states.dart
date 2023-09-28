abstract class PassengerStates{}

class PassengerInitialState extends PassengerStates{}
class SuccessValidatePassengersState extends PassengerStates{}
class ErrorValidatePassengersState extends PassengerStates{}

class ErrorSamePassengerValidState extends PassengerStates{
  final String? error;
  ErrorSamePassengerValidState({required this.error});
}

class ChangeSamePrimaryState extends PassengerStates{}
class ErrorPassengerValidState extends PassengerStates{}
class Change2SamePrimaryState extends PassengerStates{}

class LoadingReserveSeatsState extends PassengerStates{}
class SuccessReserveSeatsState extends PassengerStates{}
class ErrorReserveSeatsState extends PassengerStates{
  final String? error;
  ErrorReserveSeatsState({required this.error});
}