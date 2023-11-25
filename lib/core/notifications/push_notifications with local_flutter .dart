import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:trips/data/data_resource/local_resource/data_store.dart';

import '../../data/data_resource/remote_resource/repo/trips_repo.dart';
import '../di.dart';

class PushNotificationService {
  Future<void> setupInteractedMessage() async {
    var token = await FirebaseMessaging.instance.getToken();
    if(token != null && (DataStore.instance.token?.isNotEmpty??false)){
      DataStore.instance.setFcmToken(token);
      print('fcmmmmmtoken is =====> ${ DataStore.instance.fcmToken}');
     await getIt<TripsRepo>().sendFcmToken(fcmToken: token);
      }
     if (kDebugMode) {
       print('token is =====> $token');}
    await enableIOSNotifications();
    await registerNotificationListeners();
  }
  registerNotificationListeners() async {
    AndroidNotificationChannel channel = androidNotificationChannel();

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    var androidSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    // var iOSSettings = const IOSInitializationSettings(
    //   requestSoundPermission: false,
    //   requestBadgePermission: false,
    //   requestAlertPermission: false,
    // );
    var initSettings =
    InitializationSettings(android: androidSettings, );
    flutterLocalNotificationsPlugin.initialize(initSettings,
       // onSelectNotification: (message) async {  }
    );
  }
  enableIOSNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }
  androidNotificationChannel() => const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.max,
  );
}