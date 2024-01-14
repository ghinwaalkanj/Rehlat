abstract class SupportStates{}
class SupportInitialState extends SupportStates{}
class UpdateDateState extends SupportStates{}

class SendClaimLoadingState extends SupportStates{}
class SendClaimSuccessState extends SupportStates{}
class SendClaimErrorState extends SupportStates{
  final String error;
  SendClaimErrorState({required this.error});
}
class GetClaimLoadingState extends SupportStates{}
class GetClaimSuccessState extends SupportStates{}
class GetClaimErrorState extends SupportStates{
  final String error;
  GetClaimErrorState({required this.error});
}

class LoadingBookingClaimState extends SupportStates{}
class SuccessBookingClaimState extends SupportStates{}
class ErrorBookingClaimState extends SupportStates{
  final String error;
  ErrorBookingClaimState({required this.error});
}