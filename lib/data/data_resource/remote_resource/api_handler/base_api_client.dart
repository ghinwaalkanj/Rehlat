import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../local_resource/data_store.dart';
import '../links.dart';
import 'dio_errors_handler.dart';

class BaseApiClient {
  static Dio client = Dio();
  static const String _acceptHeader = 'application/json';

  BaseApiClient() {
    client.interceptors.add(LogInterceptor());
    if (kDebugMode) {
      client.interceptors.add(PrettyDioLogger(
        requestBody: true,
          requestHeader: true, responseHeader: true, request: true));
    }
    //  client.interceptors.add(ClientInterceptor());
    client.options.baseUrl = Links.baseUrl;
  }

  static Future<Either<String, T>> post<T>(
      {required String url,
      dynamic formData,
      Map<String, dynamic>? queryParameters,
      required Function(dynamic) converter,
        Function(String)? saveToken,
        Function(Headers)? getHeaders11,
      dynamic returnOnError}) async {
    try {
      var response = await client.post(
        url,
        queryParameters: queryParameters,
        data: formData,
        onSendProgress: (int sent, int total) {
          if (kDebugMode) {
            print(
                'progress: ${(sent / total * 100).toStringAsFixed(0)}% ($sent/$total)');
          }
        },
        options: Options(
          headers: {
            'accept': _acceptHeader,
            'authorization': 'Bearer ${DataStore.instance.token ?? ''}',
           "Accept-Language":DataStore.instance.lang
          },
        ),
      );
      if (response.statusCode! >= 200 || response.statusCode! <= 205) {
        if (kDebugMode) {
          print(response.data);
        }
        if(saveToken != null)saveToken(response.headers['Authorization']!.first);
        if(getHeaders11 != null)getHeaders11(response.headers);
        print('e.response?.data right');
        print(response?.data);
        return right(converter(response.data));
      } else {
        if(getHeaders11 != null)getHeaders11(response.headers);
        print('e.response?.data else');
        print(response?.data['message']);
        return left(response.data['message']);
      }
    } on DioException catch (e) {
      Map dioError = DioErrorsHandler.onError(e);
      if (kDebugMode) {
        print(e);
      }
      print('e.response?.data DioException');
      print(e.response?.data['message']);
      if(getHeaders11 != null)getHeaders11(e.response!.headers);
      return left(e.response?.data['message']??dioError['message']);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      print('e.response?.data catch');
      print(e.toString());
      return left(e.toString());
    }
  }

  static Future<Either<String, T>> put<T>(
      {required String url,
      dynamic formData,
      Map<String, dynamic>? queryParameters,
      required Function(dynamic) converter,
      dynamic returnOnError}) async {
    try {
      var response = await client.put(
        url,
        data: formData,
        queryParameters: queryParameters,
        onSendProgress: (int sent, int total) {
          if (kDebugMode) {
            print(
                'progress: ${(sent / total * 100).toStringAsFixed(0)}% ($sent/$total)');
          }
        },
        options: Options(
          headers: {
            'accept': _acceptHeader,
            'authorization': 'Bearer ${DataStore.instance.token ?? ''}',
           "Accept-Language":DataStore.instance.lang
          },
        ),
      );
      if (response.statusCode! >= 200 || response.statusCode! <= 205) {
        if (kDebugMode) {
          print(response.data);
        }
      }
      return Right(converter(response.data));
    } on DioException catch (e) {
      Map dioError = DioErrorsHandler.onError(e);

      if (kDebugMode) {
        print(e);
      }
      return Left(dioError['message']);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return left(e.toString());
    }
  }

  static Future<Either<String, T>> get<T>(
      {required String url,
      Map<String, dynamic>? queryParameters,
        Function(Headers)? getHeaders11,
      required Function(dynamic) converter}) async {
    try {
      var response = await client.get(
        url,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${DataStore.instance.token}',
            "Accept-Language":DataStore.instance.lang
          },
        ),
      );
      if (response.statusCode! >= 200 || response.statusCode! <= 205) {
        if (kDebugMode) {
          print(response.data);
        }
        if(getHeaders11 != null)getHeaders11(response.headers);
        return Right(converter(response.data));
      } else {
        if(getHeaders11 != null)getHeaders11(response.headers);
        return left(response.data['message']);
      }
    } on DioException catch (e) {
      Map dioError = DioErrorsHandler.onError(e);

      if (kDebugMode) {
        print(e);
      }
      if(getHeaders11 != null)getHeaders11(e.response!.headers);
      return left(e.response?.data['message']??dioError['message']);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return left(e.toString());
    }
  }

  static Future<Either<String, T>> delete<T>(
      {required String url,
      Map<String, dynamic>? queryParameters,
      required Function(dynamic) converter}) async {
    try {
      var response = await client.delete(
        url,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            'accept': _acceptHeader,
            'authorization': 'Bearer ${DataStore.instance.token ?? ''}',
          },
        ),
      );
      if (response.statusCode! >= 200 || response.statusCode! <= 205) {
        if (kDebugMode) {
          print(response.data);
        }
        return Right(converter(response.data));
      }
      else {


        return left(response.data['message']);
      }
    } on DioException catch (e) {
      Map dioError = DioErrorsHandler.onError(e);
      if (kDebugMode) {
        print(e);
      }
      return left(dioError['message']);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return left(e.toString());
    }
  }
}
