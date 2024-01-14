abstract class RootPageStates{}
class ChangeIndexState extends RootPageStates{}
class RootPageInitialState extends RootPageStates{}

class LoadingCheckTripState extends RootPageStates{}
class SuccessCheckTripState extends RootPageStates{}
class ErrorCheckTripState extends RootPageStates{
  final String? error;
  ErrorCheckTripState({required this.error});
}

class LoadingRateTripState extends RootPageStates{}
class SuccessRateTripState extends RootPageStates{}
class ErrorRateTripState extends RootPageStates{
  final String? error;
  ErrorRateTripState({required this.error});
}

class SendLangLoadingState extends RootPageStates{}
class SendLangSuccessState extends RootPageStates{}
class SendLangErrorState extends RootPageStates{
  final String error;
  SendLangErrorState({required this.error});
}