import 'dart:io';

import "package:dio/dio.dart";
import 'package:trips/core/localization/app_localization.dart';

class DioErrorsHandler {
  static Map data = {"statusCode": -1, "message": "Unknown Error"};

  static dynamic onError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      data["message"] = "request_timeout".translate();
      data["statusCode"] = 408;
    } else if (e.error is SocketException ||
        e.type == DioExceptionType.connectionError) {
      data["message"] = "no_internet".translate();
    } else if (e.type == DioExceptionType.cancel) {
      data["message"] = "request_canceled".translate();
    } else if (e.type == DioExceptionType.unknown ||
        e.type == DioExceptionType.badCertificate ||
        e.type == DioExceptionType.badResponse) {
      data["message"] = "went_wrong".translate();
    }
    return data;
  }
}
