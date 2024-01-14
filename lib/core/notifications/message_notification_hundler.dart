import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MessageHandlerWidget extends StatefulWidget {
  final Widget child;
  const MessageHandlerWidget({Key? key, required this.child}) : super(key: key);
  @override
  State createState() => MessageHandlerWidgetState();
}

class MessageHandlerWidgetState extends State<MessageHandlerWidget> {

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  late Widget child = widget.child;
  @override
  void initState() {
    super.initState();
    fetchMessage();

    //background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async =>print('testt22'));//

    //in foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        if (message != null) {
          var androidPlatformChannelSpecifics = const
          AndroidNotificationDetails(
              'high_importance_channel', 'High Importance Notifications',
              channelDescription: 'Receive updates about new features and bug fixes',
              playSound: true,
              importance: Importance.max, priority: Priority.high);
             var platformChannelSpecifics = NotificationDetails(
            android: androidPlatformChannelSpecifics,
            // iOSPlatformChannelSpecifics
          );
          if (kDebugMode) {
            print('Message also contained a notification: ${message.notification.toString()}');
          }
          await flutterLocalNotificationsPlugin.show(
              0, message.notification?.title.toString(), message.notification?.body.toString(),
             platformChannelSpecifics,
              payload: 'item x');
        }
      });
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  fetchMessage() async {
    try{
      //in terminate
      final  initialMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        //todo
        navigateNotification(initialMessage.data);
      }}catch(e){
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}



Future<void> firebaseMessagingBackgroundHandler(RemoteMessage remoteMessage) async {
  debugPrint('Handling a background message ${remoteMessage.messageId}');
}

navigateNotification (Map<String, dynamic> message) async {}