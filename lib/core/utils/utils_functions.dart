import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trips/core/localization/app_localization.dart';

import '../../data/data_resource/local_resource/data_store.dart';

class FunctionUtils {

  String? getHumanTime(DateTime? dateTime) {
    dateTime ??= DateTime.now();
    var now = DateTime.now();
    var difference = now.difference(dateTime);
    if (difference.inDays == 0 && now.day == dateTime.day) {
      return '${"Today".translate()}, ${"at".translate()} ${DateFormat(
          'jm', DataStore.instance.lang).format(dateTime)}';
    }
    else if (difference.inDays == 1 ||
        (now.day - 1 == dateTime.day && now.month == dateTime.month &&
            now.year == dateTime.year)) {
      return '${"Yesterday".translate()}, ${"at".translate()} ${DateFormat(
          'jm', DataStore.instance.lang).format(dateTime)}';
    }
    else if (difference.inDays < 7) {
      return '${DateFormat('E', DataStore.instance.lang).format(
          dateTime)}, ${"at".translate()} ${DateFormat(
          'jm', DataStore.instance.lang).format(dateTime)}';
    } else if (difference.inDays < 365) {
      return '${DateFormat('yMMMMd', DataStore.instance.lang).format(
          dateTime)}, ${"at".translate()} ${DateFormat(
          'jm', DataStore.instance.lang).format(dateTime)}';
    }
    return null;
  }

  formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min
        .toString()
        .length <= 1 ? "0$min" : "$min";
    String second = sec
        .toString()
        .length <= 1 ? "0$sec" : "$sec";
    return DataStore.instance.lang=='en'? "$minute : $second":"$second : $minute";
  }

  getNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    //
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await Permission.notification.request();
      if (kDebugMode) {
        print('User granted permission');
      }
    } else
    if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('User granted provisional permission');
      }
    } else {
      //     await messaging.requestPermission();
      await Permission.notification.request();
      Permission.notification.shouldShowRequestRationale;
      if (kDebugMode) {
        print('User declined or has not accepted permission');
      }
    }
  }
}