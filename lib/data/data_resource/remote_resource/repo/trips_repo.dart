import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../domain/models/passenger_model.dart';
import '../../../../domain/models/search_param_model.dart';
import '../../../model/booking_model.dart';
import '../../../model/city_model.dart';
import '../../../model/company_model.dart';
import '../../../model/full_user_model.dart';
import '../../../model/notification_model/full_notification_model.dart';
import '../../../model/trip_model.dart';
import '../api_handler/base_api_client.dart';
import '../links.dart';

class TripsRepo  {

  Future<Either<String, List<TripModel>>> searchTrip({required SearchTripParamModel searchTripParamModel}) {
    return BaseApiClient.get(
        url: '${Links.baseUrl}${Links.searchTrips}',
        queryParameters: searchTripParamModel.toJson(),
        converter: (value) {
          return   value['data']["trips"] == null ? [] : List<TripModel>.from(value['data']["trips"]!.map((x) => TripModel.fromJson(x)));
        });
  }

  Future<Either<String, TripModel>> getTrip(int id) {
    return BaseApiClient.get(
        url: '${Links.baseUrl}${Links.searchTrips}/$id',
        converter: (value) {
          return TripModel.fromJson(value['data']['trip']);
        });
  }

  Future<Either<String, dynamic>> sendOtp(String phone,String? fullName,{required Function(Headers) getHeaders}) {
    return BaseApiClient.get(
        url: '${Links.baseUrl}${Links.sendOtp}',
        getHeaders11: (p0) =>getHeaders(p0),
        queryParameters: {
          "phone":phone,
          "name":fullName
        },
        converter: (value) {
          return value['message'];
        });
  }

  Future<Either<String, FullUserModel>> phoneVerify(String phone,String code,{required Function(Headers) getHeaders}) {
    return BaseApiClient.post(
        url: '${Links.baseUrl}${Links.phoneVerify}',
        getHeaders11: (p0) =>getHeaders(p0),
        formData: FormData.fromMap({
          "phone": phone,
          "code":code,
        }),
        converter: (value) {
          return  FullUserModel.fromJson(value['data']);
        });
  }

  Future<Either<String, dynamic>> selectSeats(List<int> ids) {
    return BaseApiClient.post(
        url: '${Links.baseUrl}${Links.selectSeats}',
        formData: FormData.fromMap({"ids": [ids],}),
        converter: (value) {
          return value['message'];
        });
  }

  Future<Either<String, dynamic>> unSelectSeats(List<int> ids) {
    return BaseApiClient.post(
        url: '${Links.baseUrl}${Links.unSelectSeats}',
        formData: {"ids": ids,},
        converter: (value) {
          return value['message'];
        });
  }

  Future<Either<String, dynamic>> reserveSeats(
      {required List<int> ids, List<PassengerModel>? passengerList,required bool isTemp}) {
    Map<dynamic, int> idSeatsMap = {};
    Map<String, dynamic> passengersMap = {};
    for (int i = 0; i < ids.length; i++) {
      idSeatsMap['ids[$i]'] = ids[i];
    }

        if(passengerList?.isNotEmpty??false){
        for (int i = 0; i < passengerList!.length; i++) {
          passengersMap.addAll(passengerList[i].toJson(i));
    }}

    return BaseApiClient.post(
        url: '${Links.baseUrl}${Links.reserveSeats}',
        formData:
        FormData.fromMap({
          "is_temp":isTemp==true?1:0,
          ...passengersMap,
          ...idSeatsMap,
        }),
        converter: (value) {
          return value['message'];
        });
  }


  Future<Either<String, List<CityModel>>> getCities() {
    return BaseApiClient.get(
        url: '${Links.baseUrl}${Links.cities}',
        converter: (value) {
          return value['data']['cities']==null?[]: List<CityModel>.from(value["data"]['cities']!.map((x) => CityModel.fromJson(x)));
        });
  }

  Future<Either<String,BookingModel>> getBooingList() {
    return BaseApiClient.get(
        url: '${Links.baseUrl}${Links.booking}',
        converter: (value) {
          return value['data']==null?[]: BookingModel.fromJson(value['data']);
        });

  }

  Future<Either<String, List<CompanyModel>>> getCompanies() {
    return BaseApiClient.get(
        url: '${Links.baseUrl}${Links.companies}',
        converter: (value) {
          return value['data']['companies']==null?[]: List<CompanyModel>.from(value["data"]['companies']!.map((x) => CompanyModel.fromJson(x)));
        });
  }

  Future<Either<String, bool>> confirmReservation({required int bookingId,required String code,required Function(Headers) getHeaders }) {
    return BaseApiClient.post(
        getHeaders11: (p0) =>getHeaders(p0),
        formData: FormData.fromMap({"code":code}),
        url: '${Links.baseUrl}${Links.confirmReservation}/$bookingId',
        converter: (value) {
          return true;
        });
  }

  Future<Either<String, bool>> requestConfirmReservation({required int bookingId}) {
    return BaseApiClient.get(
        url: '${Links.baseUrl}${Links.requestReservation}/$bookingId',
        converter: (value) {
          return true;
        });
  }

  Future<Either<String, dynamic>> sendFcmToken({required String fcmToken}) {
    return BaseApiClient.post(
        formData: {"fcm_token":fcmToken},
        url: Links.baseUrl + Links.updateFcm,
        converter: (value) {
          //  return LoginResponse.fromJson(value["data"]);
        });
  }

  Future<Either<String, FullNotificationModel>> getNotification({required String url}) {
    return BaseApiClient.get(
        url: url,
        converter: (value) {
          return FullNotificationModel.fromJson(value);
        });
  }
}