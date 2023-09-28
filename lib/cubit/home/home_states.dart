abstract class HomePageStates{}
class HomePageInitialState extends HomePageStates{}

class ShowResultSearchState extends HomePageStates{}
class ChangeGoDateState extends HomePageStates{}
class ReverseState extends HomePageStates{}
class SelectedDateState extends HomePageStates{}


class ReturnDateTimeState extends HomePageStates{}
class ValidateReturnDateState extends HomePageStates{}
class ValidateState extends HomePageStates{}

class LoadingSearchTripState extends HomePageStates{}
class SuccessSearchTripState extends HomePageStates{}
class ErrorSearchTripState extends HomePageStates{
  final String error;
  ErrorSearchTripState({required this.error});
}

class LoadingGetCitiesState extends HomePageStates{}
class SuccessGetCitiesState extends HomePageStates{}
class ErrorGetCitiesState extends HomePageStates{
  final String error;
  ErrorGetCitiesState({required this.error});
}


class LoadingGetCompaniesState extends HomePageStates{}
class SuccessGetCompaniesState extends HomePageStates{}
class ErrorGetCompaniesState extends HomePageStates{
  final String error;
  ErrorGetCompaniesState({required this.error});
}

