import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../model/trip_model.dart';
import '../api_handler/base_api_client.dart';
import '../links.dart';

class RateRepo {

  Future<Either<String, TripModel?>> checkTrip() {
    return BaseApiClient.get(
        url: '${Links.baseUrl}${Links.checkTrip}',
        converter: (value) {
          return TripModel.fromJson(value['data']['trip']);
        });
  }

  Future<Either<String, bool>> rateTrip({required int tripId,required int rate }) {
    return BaseApiClient.post(
        url: '${Links.baseUrl}${Links.rateTrip}',
        formData: FormData.fromMap({
          "trip_id": tripId,
          "rate":rate,
        }),
        converter: (value) {
          return true;
        });
  }

}