import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/data_resource/remote_resource/links.dart';
import '../../data/data_resource/remote_resource/repo/trips_repo.dart';
import '../../data/model/notification_model/notification_model.dart';
import 'notification_states.dart';

class NotificationCubit extends Cubit<NotificationStates> {
  List<NotificationModel> notificationList = [];
  String? notificationUrl = Links.baseUrl + Links.getNotification;
  TripsRepo tripsRepo;
  bool isLoading = true;
  bool isLast = false;
  bool isFirstLoading = true;

  NotificationCubit({required this.tripsRepo }) : super(NotificationInitialState());

  getNotification() async {
    isLoading = true;
    if (notificationUrl != null) {
      emit(GetNotificationLoadingState());
      (await tripsRepo.getNotification(url: notificationUrl!)).fold((l) {
        emit(GetNotificationErrorState(error: l));
      }, (r) {
            notificationList.addAll(r.data?.data ?? []);
            isFirstLoading = false;
            if (notificationUrl != null) notificationUrl = r.data?.nextPageUrl;
            emit(GetNotificationSuccessState());
          });
      isLoading = false;
    }
    else{
      isLast=true;
      isLoading = false;
    }
  }

  refresh(){
    notificationList=[];
    isLast=false;
    isLoading=true;
    isFirstLoading=true;
    notificationUrl = Links.baseUrl + Links.getNotification;
    getNotification();
  }

}