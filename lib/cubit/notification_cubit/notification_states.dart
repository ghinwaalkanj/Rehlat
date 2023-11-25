abstract class NotificationStates{}
class NotificationInitialState extends NotificationStates{}

class GetNotificationLoadingState extends NotificationStates{}
class GetNotificationSuccessState extends NotificationStates{}
class GetNotificationErrorState extends NotificationStates{
  final String error;
  GetNotificationErrorState({required this.error});
}
