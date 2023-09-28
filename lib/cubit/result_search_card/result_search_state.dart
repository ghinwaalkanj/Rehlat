abstract class ResultSearchStates{}
class ResultSearchInitialState extends ResultSearchStates{}

class LoadingGetTripDetailsState extends ResultSearchStates{}
class SuccessGetTripDetailsState extends ResultSearchStates{}
class ErrorGetTripDetailsState extends ResultSearchStates{
  final String? error;
  ErrorGetTripDetailsState({required this.error});
}


class SortState extends ResultSearchStates{}
