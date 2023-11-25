abstract class SupportStates{}
class SupportInitialState extends SupportStates{}
class UpdateDateState extends SupportStates{}

class SendClaimLoadingState extends SupportStates{}
class SendClaimSuccessState extends SupportStates{}
class SendClaimErrorState extends SupportStates{
  final String error;
  SendClaimErrorState({required this.error});
}