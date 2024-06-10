import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:trips/data/data_resource/remote_resource/api_handler/base_api_client.dart';
import 'package:trips/data/data_resource/remote_resource/links.dart';
import 'package:trips/data/model/payment_model.dart';

class PaymentRepo {

  Future<Either<String,List<PaymentMethodsModel>>> getPaymentMethods() {
    return BaseApiClient.get(
        url: '${Links.baseUrl}${Links.getPaymentMethods}',
        converter: (value) {
          return value['data']["methods"] == null ? [] : List<PaymentMethodsModel>.from(value['data']["methods"]!.map((x) => PaymentMethodsModel.fromJson(x)));
        });
  }

  Future<Either<String,String>> getFatoraLink({required int reservationId}) {
    return BaseApiClient.post(
        url: '${Links.baseUrl}${Links.fatora}',
        formData: FormData.fromMap({
          "reservation_id": reservationId,
        }),
        converter: (value) {
          return value['url'];
        });
  }

  Future<Either<String,int>> sendCodeMtn({required int reservationId,required String phone,}) {
    return BaseApiClient.post(
        url: '${Links.baseUrl}${Links.initMtn}',
        formData: FormData.fromMap({
          "reservation_id": reservationId,
          "phone":phone
        }),
        converter: (value) {
          return value['data']['operation_number'];
        });
  }
  Future<Either<String,String>> confirmCodeMtn({required String code,required String operationNumber,}) {
    return BaseApiClient.post(
        url: '${Links.baseUrl}${Links.confirmMtn}',
        formData: FormData.fromMap({
          "operation_number": operationNumber,
          "code":code
        }),
        converter: (value) {
          return 'confirm';
        });
  }

  Future<Either<String,String>> sendCodeSyriatel({required int reservationId,required String phone,}) {
    return BaseApiClient.post(
        url: '${Links.baseUrl}${Links.initSyriatel}',
        formData: FormData.fromMap({
          "reservation_id": reservationId,
          "phone":phone
        }),
        converter: (value) {
          return value['data']['transId'];
        });
  }
  Future<Either<String,String>> confirmCodeSyriatel({required String code,required String transId,required String phoneNumber,}) {
    return BaseApiClient.post(
        url: '${Links.baseUrl}${Links.confirmSyriatel}',
        formData: FormData.fromMap({
        "otp":code,
        "transId":transId,
        "phone":phoneNumber,
        }),
        converter: (value) {
          return 'confirm';
        });
  }


  Future<Either<String,int>> resendCodeSyriatel({required String transId,required String phoneNumber,}) {
    return BaseApiClient.post(
        url: '${Links.baseUrl}${Links.resendSyriatel}',
        formData: FormData.fromMap({
          "transId":transId,
          "phone":phoneNumber,
        }),
        converter: (value) {
          return value['data']['operation_number'];
        });
  }
}