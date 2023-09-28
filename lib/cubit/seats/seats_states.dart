abstract class SeatsStates{}
class SeatsInitialState extends SeatsStates{}


class TimerState extends SeatsStates{}
class EndTimerState extends SeatsStates{}
class SelectSeatState extends SeatsStates{}



class LoadingSelectSeatsState extends SeatsStates{}
class SuccessSelectSeatsState extends SeatsStates{}
class ErrorSelectSeatsState extends SeatsStates{
  final String? error;
  ErrorSelectSeatsState({required this.error});
}

class StatusValidateState extends SeatsStates{
  final String? error;

  StatusValidateState(this.error);
}
class ValidateSeatsLengthState extends SeatsStates{}
class LoadingUnSelectSeatsState extends SeatsStates{}
class SuccessUnSelectSeatsState extends SeatsStates{}
class ErrorUnSelectSeatsState extends SeatsStates{
  final String? error;
  ErrorUnSelectSeatsState({required this.error});
}

class AddListState extends SeatsStates{}
class AddItemListState extends SeatsStates{}