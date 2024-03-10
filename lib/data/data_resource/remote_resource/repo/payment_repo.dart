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
          print(value);
          return value['url'];
        });
  }
}